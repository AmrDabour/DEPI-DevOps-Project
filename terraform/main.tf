# Definition of local variables
locals {
  base_apis = [
    "container.googleapis.com",
    "monitoring.googleapis.com",
    "cloudtrace.googleapis.com",
    "cloudprofiler.googleapis.com"
  ]
  memorystore_apis = ["redis.googleapis.com"]
  cluster_name     = google_container_cluster.my_cluster.name
}

# Enable Google Cloud APIs
module "enable_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 18.0"

  project_id                  = var.gcp_project_id
  disable_services_on_destroy = false

  # activate_apis is the set of base_apis and the APIs required by user-configured deployment options
  activate_apis = concat(local.base_apis, var.memorystore ? local.memorystore_apis : [])
}

# Allow external IP access for GKE nodes
resource "google_project_organization_policy" "external_ip_policy" {
  project    = var.gcp_project_id
  constraint = "constraints/compute.vmExternalIpAccess"

  list_policy {
    allow {
      all = true
    }
  }

  depends_on = [
    module.enable_google_apis
  ]
}

# Create GKE cluster
resource "google_container_cluster" "my_cluster" {

  name     = var.name
  location = var.region

  # Enable autopilot for this cluster
  enable_autopilot = true

  # Set an empty ip_allocation_policy to allow autopilot cluster to spin up correctly
  ip_allocation_policy {
  }

  # Avoid setting deletion_protection to false
  # until you're ready (and certain you want) to destroy the cluster.
  deletion_protection = false

  depends_on = [
    module.enable_google_apis,
    google_project_organization_policy.external_ip_policy
  ]
}

# Configure kubectl after cluster creation
resource "null_resource" "configure_kubectl" {
  # Trigger this resource whenever the cluster endpoint changes
  triggers = {
    cluster_endpoint = google_container_cluster.my_cluster.endpoint
  }

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = "gcloud container clusters get-credentials ${google_container_cluster.my_cluster.name} --region=${var.region} --project=${var.gcp_project_id}"
  }

  depends_on = [
    google_container_cluster.my_cluster
  ]
}

# Apply YAML kubernetes-manifest configurations
resource "null_resource" "apply_deployment" {
  # Trigger this resource whenever kubectl is reconfigured
  triggers = {
    kubectl_config = null_resource.configure_kubectl.id
  }

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = "kubectl apply -k ${var.filepath_manifest}"
  }

  depends_on = [
    null_resource.configure_kubectl
  ]
}

# Wait condition for all Pods to be ready before finishing
resource "null_resource" "wait_conditions" {
  # Trigger this resource whenever deployment changes
  triggers = {
    deployment = null_resource.apply_deployment.id
  }

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = <<-EOT
    kubectl wait --for=condition=AVAILABLE apiservice/v1beta1.metrics.k8s.io --timeout=180s
    kubectl wait --for=condition=ready pods --all -n ${var.namespace} --timeout=280s
    EOT
  }

  depends_on = [
    resource.null_resource.apply_deployment
  ]
}

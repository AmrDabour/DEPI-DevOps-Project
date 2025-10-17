variable "gcp_project_id" {
  type        = string
  description = "The GCP project ID to apply this config to"
}

variable "name" {
  type        = string
  description = "Name given to the new GKE cluster"
  default     = "devops-project"
}

variable "region" {
  type        = string
  description = "Region of the new GKE cluster"
  default     = "us-central1"
}

variable "namespace" {
  type        = string
  description = "Kubernetes Namespace in which the DevOps Project resources are to be deployed"
  default     = "default"
}

variable "filepath_manifest" {
  type        = string
  description = "Path to DevOps Project's Kubernetes resources, written using Kustomize"
  default     = "../kustomize/"
}

variable "memorystore" {
  type        = bool
  description = "If true, DevOps Project's in-cluster Redis cache will be replaced with a Google Cloud Memorystore Redis cache"
}

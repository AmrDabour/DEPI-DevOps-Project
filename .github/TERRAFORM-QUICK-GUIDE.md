# ⚡ Terraform Quick Guide

## 🎯 Quick Setup (One Time)

### 1. Create Service Account (2 minutes)

```bash
export PROJECT_ID="saedny"

# Create service account
gcloud iam service-accounts create terraform-sa \
    --display-name="Terraform SA" \
    --project=$PROJECT_ID

# Grant permissions
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:terraform-sa@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/editor"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:terraform-sa@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/container.admin"

# Create key
gcloud iam service-accounts keys create terraform-key.json \
    --iam-account=terraform-sa@$PROJECT_ID.iam.gserviceaccount.com

# Show key
cat terraform-key.json
```

### 2. Add to GitHub Secrets (1 minute)

Go to: **Settings → Secrets → Actions**

| Secret | Value |
|--------|-------|
| `GCP_PROJECT_ID` | `saedny` |
| `GCP_SA_KEY` | Copy the entire JSON from terraform-key.json |

---

## 🚀 Usage

### Create Infrastructure

```
1. Actions → "Terraform Infrastructure Management"
2. Run workflow
3. Select: action = "plan"
4. Click "Run workflow"
5. Review the plan
6. Run workflow again
7. Select: action = "apply"
8. Approve when prompted
9. Wait ~15-20 minutes
10. Done! ✅
```

### Update Infrastructure

```
1. Edit terraform/*.tf files
2. Git commit and push
3. Actions → Terraform → Run → "plan"
4. Review changes
5. Actions → Terraform → Run → "apply"
6. Approve
```

### Destroy Infrastructure

```
⚠️ WARNING: This deletes EVERYTHING!

1. Actions → Terraform → Run workflow
2. Select: action = "destroy"
3. Review destroy plan carefully
4. Approve (if sure!)
5. Everything deleted
```

---

## 📋 What Gets Created

When you run `terraform apply`:

✅ **GKE Cluster**
   - Name: `my_cluster`
   - Zone: `us-central1-a`
   - Autopilot mode

✅ **Networking**
   - VPC network
   - Subnets
   - Firewall rules

✅ **IAM**
   - Service accounts
   - Role bindings

✅ **Monitoring** (Optional)
   - Cloud Monitoring
   - Cloud Logging

✅ **Memorystore Redis** (If enabled)
   - In terraform.tfvars: `memorystore = true`

---

## 🎯 Common Commands

### From GitHub Actions

| Task | Command |
|------|---------|
| Preview changes | Action: `plan` |
| Apply changes | Action: `apply` |
| Destroy all | Action: `destroy` |

### From Local Terminal

```bash
# Navigate to terraform directory
cd terraform

# Initialize
terraform init \
    -backend-config="bucket=saedny-tfstate" \
    -backend-config="prefix=terraform/state"

# Plan
terraform plan -var="gcp_project_id=saedny"

# Apply
terraform apply -var="gcp_project_id=saedny"

# Destroy
terraform destroy -var="gcp_project_id=saedny"

# View outputs
terraform output

# List resources
terraform state list

# Show specific resource
terraform state show google_container_cluster.my_cluster
```

---

## ⚙️ Configuration Files

### terraform/terraform.tfvars
```hcl
gcp_project_id = "saedny"
memorystore = false  # Enable Redis if needed
```

### terraform/variables.tf
```hcl
variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "memorystore" {
  description = "Enable Memorystore Redis"
  type        = bool
  default     = false
}
```

---

## 🔍 Check Status

### In GitHub Actions
```
Actions tab → Recent runs → Click on run → View logs
```

### In GCP Console
- **Clusters:** https://console.cloud.google.com/kubernetes/list?project=saedny
- **Compute:** https://console.cloud.google.com/compute/instances?project=saedny
- **Networks:** https://console.cloud.google.com/networking/networks/list?project=saedny

### Via CLI
```bash
# List GKE clusters
gcloud container clusters list --project=saedny

# Get cluster credentials
gcloud container clusters get-credentials my_cluster \
    --zone us-central1-a \
    --project saedny

# Check cluster nodes
kubectl get nodes

# View all resources
kubectl get all --all-namespaces
```

---

## 🐛 Quick Fixes

### "State is locked"
```bash
# Wait for current operation to finish
# Or force unlock (careful!):
terraform force-unlock <LOCK_ID>
```

### "Insufficient permissions"
```bash
# Add more permissions to service account
gcloud projects add-iam-policy-binding saedny \
    --member="serviceAccount:terraform-sa@saedny.iam.gserviceaccount.com" \
    --role="roles/editor"
```

### "Backend not initialized"
```bash
# Run init again
terraform init \
    -backend-config="bucket=saedny-tfstate" \
    -backend-config="prefix=terraform/state"
```

### "Resource already exists"
```bash
# Import existing resource
terraform import google_container_cluster.my_cluster projects/saedny/locations/us-central1-a/clusters/my_cluster
```

---

## ⏱️ Expected Duration

| Operation | Time |
|-----------|------|
| Plan | 1-2 min |
| Apply (initial) | 15-20 min |
| Apply (update) | 5-10 min |
| Destroy | 10-15 min |

---

## ✅ After Apply

Once infrastructure is created:

```bash
# 1. Get cluster credentials
gcloud container clusters get-credentials my_cluster \
    --zone us-central1-a \
    --project saedny

# 2. Verify cluster
kubectl get nodes
kubectl cluster-info

# 3. Deploy application
# Use "Deploy to Kubernetes" workflow in Actions

# 4. Check application
kubectl get pods
kubectl get services

# 5. Get application URL
kubectl get service frontend-external
```

---

## 📊 Cost Estimate

Approximate monthly costs (GCP us-central1):

| Resource | Cost/Month |
|----------|------------|
| GKE Autopilot Cluster | $72 + usage |
| Networking (Egress) | Variable |
| Load Balancer | $18 |
| Storage (PD) | Variable |
| Memorystore (if enabled) | $50+ |

**Total:** ~$90-150/month (varies with usage)

---

## 🎯 Next Steps

After infrastructure is ready:

1. ✅ Deploy application: `Actions → Deploy to Kubernetes`
2. ✅ Configure monitoring
3. ✅ Set up backups
4. ✅ Configure autoscaling
5. ✅ Add custom domains

---

## 📚 Full Documentation

For detailed information:
- [Full Terraform Workflow Guide](.github/TERRAFORM-WORKFLOW.md)
- [CI/CD Setup Guide](.github/CI-CD-SETUP.md)

---

## 🆘 Need Help?

**Common Issues:**
- Permissions → Check service account roles
- State lock → Wait or force unlock
- Quota → Request increase in GCP Console
- Timeout → Increase timeout in workflow

**Get Support:**
- Check [TERRAFORM-WORKFLOW.md](.github/TERRAFORM-WORKFLOW.md)
- Review workflow logs
- Check GCP Console for errors
- Open an issue

---

**That's it! Your infrastructure is code! 🎉**


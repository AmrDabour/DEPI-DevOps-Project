# 🏗️ Terraform Workflow Guide

Complete guide for managing infrastructure with Terraform via GitHub Actions.

---

## 📋 Overview

The Terraform workflow automates infrastructure management for your GKE cluster and related resources.

### What It Does:
- ✅ **Plan** - Preview infrastructure changes
- ✅ **Apply** - Create/update infrastructure
- ✅ **Destroy** - Delete infrastructure
- ✅ **Drift Detection** - Detect manual changes
- ✅ **PR Comments** - Show plan in pull requests

---

## 🔑 Required Secrets

Add these to GitHub: **Settings → Secrets and variables → Actions**

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `GCP_PROJECT_ID` | Your GCP project ID | From `terraform/terraform.tfvars` (currently: `saedny`) |
| `GCP_SA_KEY` | Service Account JSON key | See below |

### Create Service Account Key

```bash
# Set your project ID
export PROJECT_ID="saedny"

# Create service account
gcloud iam service-accounts create terraform-sa \
    --display-name="Terraform Service Account" \
    --project=$PROJECT_ID

# Grant required permissions
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:terraform-sa@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/editor"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:terraform-sa@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/container.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:terraform-sa@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountUser"

# Create and download key
gcloud iam service-accounts keys create terraform-key.json \
    --iam-account=terraform-sa@$PROJECT_ID.iam.gserviceaccount.com

# Copy content and add as GCP_SA_KEY secret
cat terraform-key.json
```

---

## 🚀 How to Use

### 1. Terraform Plan (Preview Changes)

**When:** Before making any infrastructure changes

**Steps:**
1. Go to **Actions** tab
2. Click **Terraform Infrastructure Management**
3. Click **Run workflow**
4. Select:
   - **Action:** `plan`
   - **Directory:** `terraform`
5. Click **Run workflow**

**Result:** Shows what will be created/changed/destroyed

---

### 2. Terraform Apply (Create Infrastructure)

**When:** Ready to create or update infrastructure

**Steps:**
1. Go to **Actions** tab
2. Click **Terraform Infrastructure Management**
3. Click **Run workflow**
4. Select:
   - **Action:** `apply`
   - **Directory:** `terraform`
   - **Auto approve:** `false` (safer)
5. Click **Run workflow**
6. **Approve** the deployment when prompted

**Result:** Infrastructure is created/updated

**What Gets Created:**
- GKE cluster (`my_cluster`)
- Node pools
- Networking
- IAM permissions
- (Optional) Memorystore Redis

---

### 3. Terraform Destroy (Delete Infrastructure)

**When:** Want to tear down everything

**⚠️ WARNING:** This deletes ALL infrastructure! Cannot be undone!

**Steps:**
1. Go to **Actions** tab
2. Click **Terraform Infrastructure Management**
3. Click **Run workflow**
4. Select:
   - **Action:** `destroy`
   - **Directory:** `terraform`
   - **Auto approve:** `false` (STRONGLY recommended)
5. Click **Run workflow**
6. **Approve** the destruction (requires manual approval)

**Result:** All infrastructure is destroyed

---

## 🔄 Workflow Behavior

### On Pull Request
```
Open PR with Terraform changes
    ↓
✅ Terraform format check
✅ Terraform init
✅ Terraform validate
✅ Terraform plan
    ↓
📝 Plan posted as PR comment
```

### Manual Trigger (Plan)
```
Actions → Run workflow → Select "plan"
    ↓
✅ Format check
✅ Init
✅ Validate
✅ Generate plan
    ↓
📊 Plan saved as artifact (30 days)
💬 Summary in workflow output
```

### Manual Trigger (Apply)
```
Actions → Run workflow → Select "apply"
    ↓
⏸️ Requires approval (production environment)
    ↓
✅ Init
✅ Plan
✅ Apply changes
    ↓
🎉 Infrastructure ready!
📊 Outputs displayed (cluster name, endpoint)
```

### Manual Trigger (Destroy)
```
Actions → Run workflow → Select "destroy"
    ↓
⚠️ Requires approval (destroy-approval environment)
    ↓
✅ Init
✅ Plan destroy
✅ Destroy infrastructure
    ↓
🗑️ Everything deleted!
```

---

## 📊 Understanding Plan Output

### Plan Output Example:
```
Terraform will perform the following actions:

  # google_container_cluster.my_cluster will be created
  + resource "google_container_cluster" "my_cluster" {
      + name     = "my_cluster"
      + location = "us-central1-a"
      ...
    }

Plan: 5 to add, 0 to change, 0 to destroy.
```

### What It Means:
- **+** = Will be created
- **~** = Will be modified
- **-** = Will be destroyed
- **-/+** = Will be replaced (destroyed then created)

---

## 🔒 Safety Features

### 1. Environment Protection
- **Apply** requires approval from `production` environment
- **Destroy** requires approval from `destroy-approval` environment

### 2. State Locking
- Terraform state is locked during operations
- Prevents concurrent modifications
- Stored in GCS bucket

### 3. Plan Artifacts
- Plans are saved for 30 days
- Can be reviewed later
- Audit trail maintained

### 4. PR Comments
- Plans automatically commented on PRs
- Team can review before merge
- Changes are visible

---

## 🏗️ Infrastructure Components

### Main Infrastructure (`terraform/`)

**Creates:**
- GKE Cluster
- Node pools (with autoscaling)
- VPC network
- Firewall rules
- IAM roles and bindings
- (Optional) Memorystore Redis

**Configuration:**
- File: `terraform/terraform.tfvars`
- Project: `saedny`
- Memorystore: `false` (disabled by default)

---

## 🛠️ Advanced Usage

### Using Auto-Approve (Dangerous!)

**⚠️ WARNING:** Only use in non-production or for minor changes!

```yaml
# When running workflow:
- Action: apply
- Auto approve: true  ← Use with caution!
```

### Different Terraform Directory

If you have multiple Terraform configurations:

```yaml
# When running workflow:
- Directory: .github/terraform  ← For CI/CD infrastructure
# OR
- Directory: terraform  ← For main infrastructure
```

### View Terraform State

```bash
# Connect to GCS backend
gsutil ls gs://saedny-tfstate/terraform/state/

# Download state (read-only!)
gsutil cp gs://saedny-tfstate/terraform/state/default.tfstate ./
```

---

## 📝 Common Workflows

### Scenario 1: First-Time Infrastructure Setup

```bash
# 1. Review terraform.tfvars
cat terraform/terraform.tfvars

# 2. Run plan
# Actions → Terraform → Run workflow → plan

# 3. Review plan output

# 4. Run apply
# Actions → Terraform → Run workflow → apply

# 5. Approve when prompted

# 6. Wait for completion (~15-20 minutes)

# 7. Get cluster credentials
gcloud container clusters get-credentials my_cluster \
    --zone us-central1-a \
    --project saedny
```

### Scenario 2: Modify Existing Infrastructure

```bash
# 1. Edit Terraform files
# terraform/main.tf, terraform/variables.tf, etc.

# 2. Create PR
git checkout -b update-infrastructure
git add terraform/
git commit -m "Update GKE node pool size"
git push origin update-infrastructure

# 3. Review plan in PR comments

# 4. Merge PR

# 5. Run apply
# Actions → Terraform → Run workflow → apply
```

### Scenario 3: Tear Down Everything

```bash
# ⚠️ WARNING: This deletes everything!

# 1. Backup any important data

# 2. Export Kubernetes resources if needed
kubectl get all --all-namespaces -o yaml > backup.yaml

# 3. Run destroy
# Actions → Terraform → Run workflow → destroy

# 4. Review destroy plan carefully

# 5. Approve destruction

# 6. Wait for completion (~10-15 minutes)
```

---

## 🐛 Troubleshooting

### Error: "Backend initialization required"

**Solution:**
```bash
# Manually initialize backend
cd terraform
terraform init \
    -backend-config="bucket=saedny-tfstate" \
    -backend-config="prefix=terraform/state"
```

### Error: "State locked"

**Cause:** Another operation is running or previous run failed

**Solution:**
```bash
# Check lock
terraform force-unlock <LOCK_ID>

# Or wait for previous operation to complete
```

### Error: "Insufficient permissions"

**Cause:** Service account lacks required permissions

**Solution:**
```bash
# Grant additional roles
gcloud projects add-iam-policy-binding saedny \
    --member="serviceAccount:terraform-sa@saedny.iam.gserviceaccount.com" \
    --role="roles/editor"
```

### Error: "Quota exceeded"

**Cause:** GCP project quota limits reached

**Solution:**
- Request quota increase in GCP Console
- Or reduce resource requirements in Terraform

---

## 📊 Monitoring Terraform Operations

### View Active Operations
```bash
# Check workflow status
gh workflow view terraform.yml

# List recent runs
gh run list --workflow=terraform.yml

# Watch a run
gh run watch <run-id>
```

### Check Infrastructure State
```bash
# List resources
terraform state list

# Show specific resource
terraform state show google_container_cluster.my_cluster

# View outputs
terraform output
```

### Verify in GCP Console
- **GKE Clusters:** https://console.cloud.google.com/kubernetes/list?project=saedny
- **Networks:** https://console.cloud.google.com/networking/networks/list?project=saedny
- **IAM:** https://console.cloud.google.com/iam-admin/iam?project=saedny

---

## 🎯 Best Practices

### 1. Always Plan Before Apply
- ✅ Run `plan` first
- ✅ Review changes carefully
- ✅ Understand what will change

### 2. Use Version Control
- ✅ Commit Terraform changes to Git
- ✅ Create PRs for review
- ✅ Never apply manually without PR

### 3. State Management
- ✅ State stored in GCS (remote backend)
- ✅ Never edit state files directly
- ✅ Use state locking

### 4. Environment Separation
- ✅ Use workspaces or separate directories
- ✅ Different backends for prod/staging
- ✅ Protect production with approvals

### 5. Documentation
- ✅ Comment your Terraform code
- ✅ Document variables
- ✅ Maintain README in terraform/

---

## 🔐 Security Considerations

### Service Account Permissions
- Use minimum required permissions
- Rotate keys regularly (every 90 days)
- Never commit keys to Git

### State File Security
- State contains sensitive data
- GCS bucket is private
- Enable versioning for backup

### Approval Requirements
- Production changes require approval
- Destroy operations require approval
- Critical changes need team review

---

## 📚 Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [GCP Provider Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [GKE Terraform Guide](https://cloud.google.com/kubernetes-engine/docs/how-to/provisioning-with-terraform)

---

## ✅ Quick Reference

### Commands
| Action | Steps |
|--------|-------|
| **Plan** | Actions → Terraform → Run → Select "plan" |
| **Apply** | Actions → Terraform → Run → Select "apply" → Approve |
| **Destroy** | Actions → Terraform → Run → Select "destroy" → Approve |

### Files
| File | Purpose |
|------|---------|
| `terraform/main.tf` | Main infrastructure definition |
| `terraform/variables.tf` | Input variables |
| `terraform/terraform.tfvars` | Variable values |
| `terraform/outputs.tf` | Output values |

### Secrets
| Secret | Value |
|--------|-------|
| `GCP_PROJECT_ID` | `saedny` |
| `GCP_SA_KEY` | Service account JSON |

---

**Need help?** Check the troubleshooting section or open an issue!


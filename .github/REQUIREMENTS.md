# 📋 CI/CD Requirements Checklist

## Essential Requirements (Must Have)

### 1. Docker Hub Account
- **What:** Container registry to store your Docker images
- **Sign up:** https://hub.docker.com/signup
- **Cost:** Free for public repositories

### 2. GitHub Repository Secrets

Add these in: **Settings → Secrets and variables → Actions**

| Secret Name | Required | Description |
|-------------|----------|-------------|
| `DOCKER_USERNAME` | ✅ Yes | Your Docker Hub username |
| `DOCKER_PASSWORD` | ✅ Yes | Docker Hub access token |

---

## Optional Requirements (For Deployment)

### Option A: Google Kubernetes Engine (GKE)

If deploying to GKE, add these secrets:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `GCP_PROJECT_ID` | Your GCP project ID | `saedny` |
| `GCP_SA_KEY` | Service account JSON key | `{...JSON content...}` |
| `GKE_CLUSTER_NAME` | Cluster name | `my_cluster` |
| `GKE_ZONE` | Cluster zone | `us-central1-a` |

### Option B: Any Kubernetes Cluster

If deploying to any K8s cluster:

| Secret Name | Description |
|-------------|-------------|
| `KUBE_CONFIG` | Base64 encoded kubeconfig file |

---

## What You Need to Provide

### Immediately (to enable CI/CD):

```
1. Docker Hub username: ________________
2. Docker Hub access token: ________________
```

### Later (for deployment):

```
3. GCP Project ID (if using GKE): ________________
4. GKE Cluster Name: ________________
5. GKE Zone: ________________

OR

6. Kubeconfig file (for non-GKE clusters)
```

---

## Quick Commands

### Get Docker Hub Access Token
```bash
# Go to: https://hub.docker.com/settings/security
# Create new access token
```

### Get GCP Service Account Key
```bash
export PROJECT_ID="your-project-id"

gcloud iam service-accounts create github-actions \
    --display-name="GitHub Actions SA" \
    --project=$PROJECT_ID

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/container.developer"

gcloud iam service-accounts keys create key.json \
    --iam-account=github-actions@$PROJECT_ID.iam.gserviceaccount.com

cat key.json
```

### Get Kubeconfig (Base64 encoded)
```bash
cat ~/.kube/config | base64 -w 0
```

---

## Validation Checklist

After setup, verify:

- [ ] GitHub Actions are enabled in repository
- [ ] `DOCKER_USERNAME` secret is set
- [ ] `DOCKER_PASSWORD` secret is set
- [ ] Workflows are visible in `.github/workflows/` folder
- [ ] First workflow run completed successfully
- [ ] Images appear in Docker Hub
- [ ] (Optional) GCP/K8s secrets are set for deployment

---

## Support

Need help? Check:
- 🚀 [Quick Start Guide](QUICK-START.md) - Get started in 5 minutes
- 📖 [Full Setup Guide](CI-CD-SETUP.md) - Detailed documentation
- 🔧 Troubleshooting section in setup guide


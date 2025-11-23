# CI/CD Setup Guide

This guide will help you set up the CI/CD pipeline for your microservices application.

## 📋 Overview

The CI/CD pipeline consists of 3 main workflows:

1. **Build and Test** - Runs on every PR and push
2. **Build and Push Docker Images** - Builds and pushes images to Docker Hub on push to main
3. **Deploy to Kubernetes** - Deploys the application to your Kubernetes cluster (manual trigger)

---

## 🔑 Required GitHub Secrets

You need to configure the following secrets in your GitHub repository:

### For Docker Hub (Required for image building)

Go to: **Settings → Secrets and variables → Actions → New repository secret**

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `DOCKER_USERNAME` | Your Docker Hub username | Your Docker Hub account username |
| `DOCKER_PASSWORD` | Docker Hub access token | [Create token here](https://hub.docker.com/settings/security) |

#### How to create Docker Hub Access Token:
1. Go to https://hub.docker.com/settings/security
2. Click "New Access Token"
3. Give it a name (e.g., "GitHub Actions")
4. Copy the token and save it as `DOCKER_PASSWORD` secret

---

### For GKE Deployment (Optional - if deploying to Google Kubernetes Engine)

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `GCP_PROJECT_ID` | Your GCP project ID | From `terraform.tfvars` or GCP Console |
| `GCP_SA_KEY` | Service Account JSON key | See instructions below |
| `GKE_CLUSTER_NAME` | Your GKE cluster name | Default: `my_cluster` (check terraform output) |
| `GKE_ZONE` | GKE cluster zone | Default: `us-central1-a` (check terraform) |

#### How to create GCP Service Account Key:

```bash
# 1. Set your project ID
export PROJECT_ID="your-project-id"

# 2. Create a service account
gcloud iam service-accounts create github-actions \
    --display-name="GitHub Actions SA" \
    --project=$PROJECT_ID

# 3. Grant necessary permissions
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/container.developer"

# 4. Create and download the key
gcloud iam service-accounts keys create key.json \
    --iam-account=github-actions@$PROJECT_ID.iam.gserviceaccount.com

# 5. Copy the content of key.json and save it as GCP_SA_KEY secret
cat key.json
```

---

### For Any Kubernetes Cluster (Alternative to GKE)

If you're using a different Kubernetes cluster (AWS EKS, Azure AKS, on-premise, etc.):

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `KUBE_CONFIG` | Base64 encoded kubeconfig | See instructions below |

#### How to get your kubeconfig:

```bash
# Encode your kubeconfig to base64
cat ~/.kube/config | base64 -w 0

# Copy the output and save it as KUBE_CONFIG secret
```

---

## 🚀 How to Use the CI/CD Pipeline

### 1. Automatic Testing
- Every pull request and push will automatically:
  - Run tests for all microservices
  - Validate code quality
  - Report results in the PR

### 2. Building and Pushing Images

When you push to `main` branch:
- All microservices will be built as Docker images
- Images will be pushed to Docker Hub
- Images will be tagged with:
  - `latest` (always points to the latest main)
  - `main-<short-sha>` (specific commit)
  - Version tags (if you create a release tag like `v1.0.0`)

### 3. Deploying to Kubernetes

Deployment is manual (on-demand):

1. Go to **Actions** tab in GitHub
2. Select **Deploy to Kubernetes** workflow
3. Click **Run workflow**
4. Choose:
   - Environment (staging/production)
   - Image tag (optional - leave empty for latest)
5. Click **Run workflow**

---

## 🔧 Configuration

### Change Docker Registry

If you want to use a different container registry (Google Container Registry, AWS ECR, etc.), edit `.github/workflows/build-push-images.yml`:

```yaml
env:
  REGISTRY: gcr.io  # or your registry
  IMAGE_PREFIX: ${{ secrets.DOCKER_USERNAME || 'your-project-id' }}
```

### Customize Build Process

Each service is built separately. To modify build settings:
- Edit the `matrix.service` list to add/remove services
- Modify build arguments in the Docker build step

---

## 📊 Monitoring Your Pipeline

### View Workflow Runs
1. Go to **Actions** tab in your GitHub repository
2. Click on any workflow to see its runs
3. Click on a specific run to see detailed logs

### Troubleshooting

#### Build fails with authentication error
- Check that `DOCKER_USERNAME` and `DOCKER_PASSWORD` are correctly set
- Verify your Docker Hub access token is still valid

#### Deployment fails
- Check that your GKE cluster is running: `gcloud container clusters list`
- Verify your service account has correct permissions
- Check kubectl can connect: `kubectl get pods`

#### Images not found
- Verify images were pushed successfully to Docker Hub
- Check the image names match in your Kubernetes manifests

---

## 🎯 Quick Start Checklist

- [ ] Create Docker Hub account
- [ ] Create Docker Hub access token
- [ ] Add `DOCKER_USERNAME` secret to GitHub
- [ ] Add `DOCKER_PASSWORD` secret to GitHub
- [ ] (Optional) Set up GCP service account for GKE deployment
- [ ] (Optional) Add GKE-related secrets to GitHub
- [ ] Push to main branch to trigger first build
- [ ] Verify images are in Docker Hub
- [ ] Run deployment workflow manually

---

## 📝 Notes

- The pipeline uses multi-platform builds (linux/amd64, linux/arm64) for better compatibility
- Images are cached to speed up subsequent builds
- The `loadgenerator` service is built but you may want to exclude it from production deployments
- You can modify the workflows to add additional steps like security scanning, smoke tests, etc.

---

## 🆘 Need Help?

If you encounter issues:
1. Check the workflow logs in the Actions tab
2. Verify all secrets are correctly set
3. Ensure your Kubernetes cluster is accessible
4. Check Docker Hub for image availability

For more information:
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Hub Documentation](https://docs.docker.com/docker-hub/)
- [Google Kubernetes Engine Documentation](https://cloud.google.com/kubernetes-engine/docs)


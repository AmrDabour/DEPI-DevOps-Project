# GitHub Actions Workflows

This directory contains all CI/CD workflows for the microservices application.

## 📁 Workflows Overview

### 🧪 `build-and-test.yml`
**Trigger:** On every push and pull request

**Purpose:** Run automated tests for all microservices

**Services tested:**
- Go services (checkoutservice, frontend, productcatalogservice, shippingservice)
- Python services (emailservice, recommendationservice)
- Node.js services (currencyservice, paymentservice)
- Java service (adservice)
- C# service (cartservice)

**Duration:** ~5-10 minutes

---

### 🐳 `build-push-images.yml`
**Trigger:** On push to main branch, tags, or manual

**Purpose:** Build Docker images for all microservices and push to Docker Hub

**Features:**
- Multi-platform builds (linux/amd64, linux/arm64)
- Automatic tagging (latest, branch name, commit SHA)
- Image caching for faster builds
- Automatic manifest updates

**Duration:** ~15-25 minutes

**Required secrets:**
- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`

---

### 🚀 `deploy-kubernetes.yml`
**Trigger:** Manual (workflow_dispatch)

**Purpose:** Deploy application to Kubernetes cluster

**Options:**
- Deploy to GKE (Google Kubernetes Engine)
- Deploy to any Kubernetes cluster (using kubeconfig)
- Choose environment (staging/production)
- Specify image tag

**Duration:** ~3-5 minutes

**Required secrets:**
- For GKE: `GCP_PROJECT_ID`, `GCP_SA_KEY`, `GKE_CLUSTER_NAME`, `GKE_ZONE`
- For any K8s: `KUBE_CONFIG`

---

### 🔒 `security-scan.yml`
**Trigger:** Push, PR, weekly schedule (Mondays 9 AM), or manual

**Purpose:** Security scanning for vulnerabilities

**Scans:**
- Dependency vulnerabilities (Trivy)
- Docker image vulnerabilities
- Secret leaks (Gitleaks)

**Duration:** ~10-15 minutes

**Reports:** Results uploaded to GitHub Security tab

---

### 🎁 `release.yml`
**Trigger:** On version tags (v*.*.*) or manual

**Purpose:** Create releases and build versioned images

**Features:**
- Automatic changelog generation
- GitHub release creation
- Build and push versioned Docker images
- Tag images as `latest` and version number

**Duration:** ~20-30 minutes

**Required secrets:**
- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`

---

### 🏗️ `terraform.yml`
**Trigger:** Manual (workflow_dispatch) or PR with terraform changes

**Purpose:** Manage infrastructure with Terraform

**Actions:**
- **Plan** - Preview infrastructure changes
- **Apply** - Create/update infrastructure
- **Destroy** - Delete all infrastructure
- **Drift Detection** - Detect manual changes

**Features:**
- Automatic plan on Terraform PRs
- Approval required for apply/destroy
- State management in GCS
- Drift detection

**Duration:** ~15-20 minutes (apply), ~1-2 min (plan)

**Required secrets:**
- `GCP_PROJECT_ID`
- `GCP_SA_KEY`

**Documentation:** See [TERRAFORM-QUICK-GUIDE.md](../TERRAFORM-QUICK-GUIDE.md)

---

## 🔄 Workflow Sequence

### Development Workflow
```
1. Developer creates PR
   ↓
2. build-and-test.yml runs (automated)
   ↓
3. security-scan.yml runs (automated)
   ↓
4. PR is reviewed and merged
   ↓
5. build-push-images.yml runs (automated)
   ↓
6. Images pushed to Docker Hub
   ↓
7. deploy-kubernetes.yml runs (manual)
   ↓
8. Application deployed to cluster
```

### Release Workflow
```
1. Create version tag (v1.0.0)
   ↓
2. release.yml triggered
   ↓
3. Changelog generated
   ↓
4. GitHub release created
   ↓
5. Versioned images built and pushed
   ↓
6. Notify team
```

---

## 🎯 Quick Actions

### Run Tests
```bash
# Automatically runs on push/PR
# Or manually trigger from Actions tab
```

### Build Images
```bash
# Automatically runs on push to main
# Or manually:
# Actions → "Build and Push Docker Images" → "Run workflow"
```

### Deploy
```bash
# Actions → "Deploy to Kubernetes" → "Run workflow"
# Choose environment and image tag
```

### Create Release
```bash
# Create and push a tag
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

---

## 📊 Monitoring

### View Workflow Status
- Go to **Actions** tab
- Click on workflow name
- View runs and logs

### Check Security Issues
- Go to **Security** tab
- Click **Code scanning**
- Review findings

---

## 🛠️ Customization

### Modify Build Process
Edit `build-push-images.yml`:
- Change Docker registry
- Modify platform targets
- Add build arguments

### Add Tests
Edit `build-and-test.yml`:
- Add new test frameworks
- Modify test commands
- Add code coverage

### Adjust Security Scanning
Edit `security-scan.yml`:
- Change scan frequency
- Modify severity levels
- Add custom scanners

---

## 📚 Documentation

- [Quick Start Guide](../QUICK-START.md) - Get started in 5 minutes
- [Full Setup Guide](../CI-CD-SETUP.md) - Detailed configuration
- [Requirements](../REQUIREMENTS.md) - What you need to provide

---

## 🆘 Troubleshooting

### Workflow Not Running
- Check Actions are enabled in repository settings
- Verify workflow YAML syntax
- Check trigger conditions

### Build Failures
- Review workflow logs
- Check Docker Hub credentials
- Verify service Dockerfiles

### Deployment Issues
- Verify cluster access
- Check service account permissions
- Review Kubernetes manifests

---

## 💡 Best Practices

1. **Always run tests before merging** - Don't skip CI checks
2. **Review security scan results** - Address high/critical issues
3. **Use semantic versioning** - v1.0.0, v1.1.0, v2.0.0
4. **Test in staging first** - Before deploying to production
5. **Monitor workflow costs** - GitHub Actions has usage limits

---

## 🔗 Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Build Push Action](https://github.com/docker/build-push-action)
- [Trivy Security Scanner](https://github.com/aquasecurity/trivy)
- [Kubernetes Documentation](https://kubernetes.io/docs/)


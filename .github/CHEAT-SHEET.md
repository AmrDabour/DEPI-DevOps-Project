# 🚀 CI/CD Cheat Sheet - Quick Commands

## ⚡ Initial Setup (One Time Only)

### 1. Create Docker Hub Token
```bash
# Go to: https://hub.docker.com/settings/security
# Click: New Access Token
# Name: GitHub Actions
# Copy the token
```

### 2. Add GitHub Secrets
```bash
# Go to: https://github.com/YOUR_USERNAME/YOUR_REPO/settings/secrets/actions
# Add:
#   - DOCKER_USERNAME: your-dockerhub-username
#   - DOCKER_PASSWORD: your-access-token
```

### 3. Enable Actions
```bash
# Go to: https://github.com/YOUR_USERNAME/YOUR_REPO/actions
# Click: "I understand my workflows, go ahead and enable them"
```

---

## 📦 Daily Workflow Commands

### Test Your Code
```bash
# Create branch
git checkout -b feature/my-feature

# Make changes
# ... edit files ...

# Commit and push
git add .
git commit -m "Add new feature"
git push origin feature/my-feature

# Create PR on GitHub
# Tests run automatically ✅
```

### Merge to Main
```bash
# After PR approval
git checkout main
git pull origin main
git merge feature/my-feature
git push origin main

# Images build automatically ✅
# Check: https://hub.docker.com
```

### Deploy to Kubernetes
```bash
# Option 1: Via GitHub UI
# Go to: Actions → Deploy to Kubernetes → Run workflow

# Option 2: Via CLI (if you set up GitHub CLI)
gh workflow run deploy-kubernetes.yml \
  -f environment=staging \
  -f image_tag=main-abc123
```

### Create a Release
```bash
# Tag a version
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# Release workflow runs automatically ✅
# Check: Releases tab in GitHub
```

### Manage Infrastructure (Terraform)
```bash
# Plan infrastructure changes
# Go to: Actions → Terraform → Run workflow → action = "plan"

# Apply changes (create/update infrastructure)
# Go to: Actions → Terraform → Run workflow → action = "apply"

# Destroy all infrastructure (⚠️ CAREFUL!)
# Go to: Actions → Terraform → Run workflow → action = "destroy"

# Via CLI (if needed)
cd terraform
terraform init -backend-config="bucket=saedny-tfstate"
terraform plan -var="gcp_project_id=saedny"
terraform apply -var="gcp_project_id=saedny"
```

---

## 🔍 Monitoring Commands

### Check Workflow Status
```bash
# Via GitHub CLI
gh run list
gh run view <run-id>
gh run watch <run-id>

# Via Web
# Go to: Actions tab in GitHub
```

### View Logs
```bash
# Via GitHub CLI
gh run view <run-id> --log

# Via Web
# Actions → Click on workflow → Click on job
```

### Check Images
```bash
# List your Docker Hub images
docker search amrdabour

# Pull an image
docker pull amrdabour/frontend:latest

# Check image details
docker inspect amrdabour/frontend:latest
```

### Check Deployment
```bash
# Connect to your cluster
gcloud container clusters get-credentials my_cluster \
  --zone us-central1-a \
  --project saedny

# Check pods
kubectl get pods

# Check services
kubectl get services

# Check logs
kubectl logs deployment/frontend

# Get external IP
kubectl get service frontend-external
```

---

## 🛠️ Maintenance Commands

### Update Dependencies
```bash
# Go services
cd src/checkoutservice
go get -u ./...
go mod tidy

# Python services
cd src/emailservice
pip-compile requirements.in

# Node.js services
cd src/currencyservice
npm update

# Commit and push
git add .
git commit -m "Update dependencies"
git push
```

### Fix Failed Build
```bash
# View logs
gh run view --log

# Fix locally
# ... make changes ...

# Test locally
cd src/frontend
go test ./...

# Push fix
git add .
git commit -m "Fix build issue"
git push
```

### Rollback Deployment
```bash
# Get previous image tag
kubectl get deployment frontend -o yaml | grep image:

# Rollback
kubectl rollout undo deployment/frontend

# Or set specific version
kubectl set image deployment/frontend \
  frontend=amrdabour/frontend:v1.0.0

# Check status
kubectl rollout status deployment/frontend
```

---

## 🔒 Security Commands

### View Security Scan Results
```bash
# Via Web
# Go to: Security → Code scanning alerts

# Via GitHub CLI
gh api repos/:owner/:repo/code-scanning/alerts
```

### Scan Locally Before Push
```bash
# Install Trivy
# macOS: brew install trivy
# Linux: See https://aquasecurity.github.io/trivy/

# Scan dependencies
trivy fs .

# Scan Docker image
docker build -t myservice:test ./src/frontend
trivy image myservice:test
```

### Check for Secrets
```bash
# Install gitleaks
# macOS: brew install gitleaks

# Scan repository
gitleaks detect --source . --verbose
```

---

## 📊 Useful Queries

### Count Workflow Runs
```bash
gh run list --limit 100 | wc -l
```

### Check Success Rate
```bash
gh run list --limit 50 --status success | wc -l
gh run list --limit 50 --status failure | wc -l
```

### Get Build Time
```bash
gh run view <run-id> --json conclusion,createdAt,updatedAt
```

### List All Images
```bash
# All services
for service in adservice cartservice checkoutservice currencyservice \
               emailservice frontend loadgenerator paymentservice \
               productcatalogservice recommendationservice shippingservice \
               shoppingassistantservice; do
  echo "=== $service ==="
  docker pull amrdabour/$service:latest
done
```

---

## 🎯 Common Scenarios

### Scenario: Hotfix in Production
```bash
# 1. Create hotfix branch from main
git checkout main
git pull
git checkout -b hotfix/critical-bug

# 2. Fix the bug
# ... make changes ...

# 3. Test locally
docker-compose up

# 4. Push and create PR
git add .
git commit -m "Fix critical bug"
git push origin hotfix/critical-bug

# 5. After tests pass, merge to main
# 6. Tag as new patch version
git tag -a v1.0.1 -m "Hotfix: critical bug"
git push origin v1.0.1

# 7. Deploy immediately
# Actions → Deploy to Kubernetes → Run workflow
```

### Scenario: New Feature Development
```bash
# 1. Create feature branch
git checkout -b feature/new-payment-method

# 2. Develop feature
# ... make changes ...

# 3. Test locally
cd src/paymentservice
npm test

# 4. Push and create PR
git add .
git commit -m "Add new payment method"
git push origin feature/new-payment-method

# 5. Wait for CI checks
# 6. Request review
# 7. After approval, merge to main
```

### Scenario: Performance Issue
```bash
# 1. Check current deployment
kubectl top pods
kubectl top nodes

# 2. View logs
kubectl logs deployment/frontend --tail=100

# 3. Check metrics
kubectl describe deployment frontend

# 4. Scale if needed
kubectl scale deployment frontend --replicas=5

# 5. Monitor
kubectl get pods -w
```

---

## 🆘 Emergency Commands

### All Builds Failing
```bash
# 1. Check GitHub Actions status
# https://www.githubstatus.com/

# 2. Check Docker Hub status
# https://status.docker.com/

# 3. Check secrets are correct
# Settings → Secrets → Verify values

# 4. Re-run failed workflows
gh run rerun <run-id>
```

### Can't Access Application
```bash
# 1. Check pods
kubectl get pods

# 2. Check services
kubectl get services

# 3. Check ingress/load balancer
kubectl get ingress
kubectl describe service frontend-external

# 4. Check pod logs
kubectl logs -l app=frontend --tail=50

# 5. Restart if needed
kubectl rollout restart deployment/frontend
```

### Out of Docker Hub Storage
```bash
# 1. Login to Docker Hub
docker login

# 2. Delete old images
# Via Web: https://hub.docker.com/repositories
# Delete old tags manually

# 3. Update retention policy
# Settings → Repository Settings → Tag retention
```

---

## 📚 Reference Links

- **GitHub Actions Docs:** https://docs.github.com/en/actions
- **Docker Hub:** https://hub.docker.com
- **Kubectl Cheat Sheet:** https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- **GitHub CLI:** https://cli.github.com/manual/

---

## 💡 Pro Tips

### Speed Up Builds
```yaml
# Use build cache
- uses: docker/build-push-action@v5
  with:
    cache-from: type=gha
    cache-to: type=gha,mode=max
```

### Parallel Testing
```bash
# Run multiple tests in parallel
go test -parallel 4 ./...
```

### Debug Failed Workflow
```bash
# Enable debug logging
gh secret set ACTIONS_RUNNER_DEBUG -b"true"
gh secret set ACTIONS_STEP_DEBUG -b"true"
```

### Save GitHub Actions Minutes
```bash
# Use self-hosted runners for private repos
# Settings → Actions → Runners → New self-hosted runner
```

---

## 🎓 Learning Resources

### Beginner
- Read: [QUICK-START.md](QUICK-START.md)
- Watch GitHub Actions in Actions tab
- Try: Make a small change and watch it build

### Intermediate
- Read: [CI-CD-SETUP.md](CI-CD-SETUP.md)
- Customize workflows for your needs
- Set up deployment automation

### Advanced
- Implement blue-green deployments
- Add canary releases
- Set up multi-region deployment
- Implement auto-scaling based on metrics

---

**Save this file for quick reference! 📌**


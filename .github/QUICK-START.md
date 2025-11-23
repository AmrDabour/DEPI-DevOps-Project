# 🚀 CI/CD Quick Start Guide

Get your CI/CD pipeline up and running in **5 minutes**!

---

## Step 1: Get Your Docker Hub Credentials (2 minutes)

### 1.1 Create Access Token

1. Go to https://hub.docker.com/settings/security
2. Click **"New Access Token"**
3. Name it: `GitHub Actions`
4. Copy the token (you won't see it again!)

### 1.2 Get Your Docker Hub Username

Your username is displayed in the Docker Hub dashboard (e.g., `amrdabour`)

---

## Step 2: Add Secrets to GitHub (1 minute)

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **"New repository secret"** and add:

| Name | Value |
|------|-------|
| `DOCKER_USERNAME` | Your Docker Hub username |
| `DOCKER_PASSWORD` | The access token you just created |

---

## Step 3: Enable GitHub Actions (30 seconds)

1. Go to the **Actions** tab in your repository
2. If prompted, click **"I understand my workflows, go ahead and enable them"**

---

## Step 4: Trigger Your First Build (30 seconds)

### Option A: Push to main branch
```bash
git add .
git commit -m "Enable CI/CD pipeline"
git push origin main
```

### Option B: Manually trigger a workflow
1. Go to **Actions** tab
2. Select **"Build and Push Docker Images"**
3. Click **"Run workflow"**
4. Click the green **"Run workflow"** button

---

## Step 5: Monitor the Build (1 minute)

1. Go to **Actions** tab
2. Click on the running workflow
3. Watch the progress in real-time!

Expected duration: **15-25 minutes** for all 12 services to build

---

## ✅ Success! What Happens Next?

Your pipeline will automatically:

- ✅ **Test your code** on every pull request
- ✅ **Build Docker images** when you push to main
- ✅ **Push images to Docker Hub** with proper tags
- ✅ **Scan for security vulnerabilities** weekly
- ✅ **Create releases** when you tag a version

---

## 🎯 Next Steps (Optional)

### Deploy to Kubernetes

If you want to deploy automatically:

1. **For Google Kubernetes Engine (GKE):**
   - Read: [CI-CD-SETUP.md](CI-CD-SETUP.md#for-gke-deployment-optional---if-deploying-to-google-kubernetes-engine)
   - Add GCP secrets to GitHub
   - Run the **"Deploy to Kubernetes"** workflow

2. **For any Kubernetes cluster:**
   - Get your kubeconfig: `cat ~/.kube/config | base64 -w 0`
   - Add as `KUBE_CONFIG` secret
   - Run the **"Deploy to Kubernetes"** workflow

---

## 📊 Verify Your Setup

### Check Docker Hub
1. Go to https://hub.docker.com/repositories
2. You should see all 12 services with the `latest` and `main-xxxxxx` tags

### Check GitHub Actions
1. Go to **Actions** tab
2. All workflows should show green checkmarks ✅

---

## 🆘 Troubleshooting

### Build fails with "Error: unauthorized: incorrect username or password"
- Double-check your `DOCKER_USERNAME` and `DOCKER_PASSWORD` secrets
- Make sure the access token has write permissions
- Try regenerating the token

### Workflow doesn't start
- Check that Actions are enabled in your repository
- Look for a `.github/workflows/` folder in your repo
- Verify the workflow YAML files are present

### Images not appearing in Docker Hub
- Check the workflow logs for errors
- Verify your Docker Hub account has space for new repositories
- Make sure the workflow completed successfully (green checkmark)

---

## 🎓 Learn More

- 📖 [Full CI/CD Setup Documentation](CI-CD-SETUP.md)
- 🔒 [Security Scanning Details](CI-CD-SETUP.md#monitoring-your-pipeline)
- 🚀 [Release Management](CI-CD-SETUP.md#how-to-use-the-cicd-pipeline)

---

## 💡 Pro Tips

1. **Use branch protection:** Require CI checks to pass before merging PRs
2. **Set up notifications:** Get alerted when builds fail
3. **Monitor costs:** Building 12 services uses GitHub Actions minutes
4. **Cache everything:** The workflows use caching to speed up builds
5. **Test locally first:** Use `docker-compose` or `skaffold` before pushing

---

## 🎉 That's It!

You now have a professional CI/CD pipeline for your microservices application!

**Questions?** Check the [full documentation](CI-CD-SETUP.md) or open an issue.


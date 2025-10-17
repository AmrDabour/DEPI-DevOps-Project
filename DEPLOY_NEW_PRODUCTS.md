# Deploy New Products to Your App

Your products.json has been updated with 31 new products, but you need to build and deploy a new Docker image to see them in the running app.

## Prerequisites

1. Docker Desktop installed and running
2. Docker Hub account (free at https://hub.docker.com)
3. kubectl configured to access your GKE cluster

## Quick Steps

### Step 1: Build the Docker Image

Replace `YOUR_DOCKERHUB_USERNAME` with your actual Docker Hub username:

```powershell
# Build the image
cd src/productcatalogservice
docker build -t YOUR_DOCKERHUB_USERNAME/productcatalogservice:v1.0-custom .
cd ../..
```

### Step 2: Login to Docker Hub

```powershell
docker login
# Enter your Docker Hub username and password
```

### Step 3: Push to Docker Hub

```powershell
docker push YOUR_DOCKERHUB_USERNAME/productcatalogservice:v1.0-custom
```

### Step 4: Update Kubernetes Deployment

```powershell
# Update the running deployment to use your new image
kubectl set image deployment/productcatalogservice server=YOUR_DOCKERHUB_USERNAME/productcatalogservice:v1.0-custom
```

### Step 5: Wait for Rollout

```powershell
# Watch the rollout status
kubectl rollout status deployment/productcatalogservice

# Check pods are running
kubectl get pods -l app=productcatalogservice
```

### Step 6: Verify New Products

Visit your app URL and you should see 31 products instead of 9!

## Alternative: Use Automated Script

Edit `build_and_push.ps1` and change the username, then run:

```powershell
# Edit the file first to set your Docker Hub username
.\build_and_push.ps1
```

## What Changed?

- ❌ **Removed**: All 9 old products (sunglasses, tank top, watch, etc.)
- ✅ **Added**: 31 new products across multiple categories:
  - Electronics (headphones, smart watch, keyboard, etc.)
  - Office (desk chair, standing desk, organizers)
  - Sports (running shoes, yoga mat, gym bag)
  - Home (smart bulb, diffuser, wall clock)
  - Accessories (backpack, wallet, sunglasses)

## Troubleshooting

**Issue**: "docker: command not found"
- Solution: Install Docker Desktop for Windows

**Issue**: "permission denied while trying to connect to Docker daemon"
- Solution: Make sure Docker Desktop is running

**Issue**: "Error response from daemon: Get https://registry-1.docker.io/v2/"
- Solution: Run `docker login` first

**Issue**: Pods still showing old products
- Solution: Force restart: `kubectl rollout restart deployment/productcatalogservice`

## Permanent Deployment

To make this change permanent, you would need to:

1. Update `release/kubernetes-manifests.yaml`
2. Change the image line from:
   ```yaml
   image: amrdabour/productcatalogservice:latest
   ```
   To:
   ```yaml
   image: YOUR_DOCKERHUB_USERNAME/productcatalogservice:v1.0-custom
   ```
3. Commit to your git repository


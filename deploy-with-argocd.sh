#!/bin/bash

# Complete Deployment Script with Argo CD
# This script deploys both Argo CD and your microservices application

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if required variables are set
if [ -z "$PROJECT_ID" ] || [ -z "$REGION" ]; then
    echo -e "${RED}❌ Error: PROJECT_ID and REGION must be set${NC}"
    echo ""
    echo "Usage:"
    echo "  export PROJECT_ID=your-project-id"
    echo "  export REGION=us-central1"
    echo "  ./deploy-with-argocd.sh"
    exit 1
fi

echo -e "${BLUE}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Deploying Microservices with Argo CD           ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}📋 Configuration:${NC}"
echo "  Project ID: $PROJECT_ID"
echo "  Region: $REGION"
echo "  Cluster: online-boutique"
echo ""

# Step 1: Create GKE Cluster
echo -e "${BLUE}🏗️  Step 1/4: Creating GKE cluster...${NC}"
gcloud container clusters create-auto online-boutique \
    --project=${PROJECT_ID} \
    --region=${REGION}

echo -e "${GREEN}✅ Cluster created!${NC}"
echo ""

# Step 2: Get cluster credentials
echo -e "${BLUE}🔑 Step 2/4: Getting cluster credentials...${NC}"
gcloud container clusters get-credentials online-boutique \
    --project=${PROJECT_ID} \
    --region=${REGION}

echo -e "${GREEN}✅ Credentials configured!${NC}"
echo ""

# Step 3: Install Argo CD
echo -e "${BLUE}📦 Step 3/4: Installing Argo CD...${NC}"

# Create namespace
kubectl create namespace argocd

# Install Argo CD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for Argo CD to be ready
echo -e "${YELLOW}⏳ Waiting for Argo CD to be ready (2-3 minutes)...${NC}"
kubectl wait --for=condition=available --timeout=300s \
    deployment/argocd-server \
    deployment/argocd-repo-server \
    deployment/argocd-applicationset-controller \
    -n argocd

# Patch service to LoadBalancer (optional)
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

echo -e "${GREEN}✅ Argo CD installed!${NC}"
echo ""

# Step 4: Deploy Application
echo -e "${BLUE}🚀 Step 4/4: Deploying microservices application...${NC}"

# Option A: Deploy directly (traditional way)
echo -e "${YELLOW}Deploying application manifests...${NC}"
kubectl apply -f ./release/kubernetes-manifests.yaml

# Option B: Also create Argo CD application for future GitOps
echo -e "${YELLOW}Creating Argo CD application for GitOps...${NC}"
kubectl apply -f ./argocd/applications/microservices-app.yaml

echo -e "${GREEN}✅ Application deployed!${NC}"
echo ""

# Wait for frontend to be ready
echo -e "${BLUE}⏳ Waiting for frontend service to get external IP...${NC}"
for i in {1..30}; do
    EXTERNAL_IP=$(kubectl get service frontend-external -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "")
    if [ ! -z "$EXTERNAL_IP" ]; then
        break
    fi
    echo -n "."
    sleep 10
done
echo ""

# Get service information
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Application Frontend
FRONTEND_IP=$(kubectl get service frontend-external -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "pending...")
echo -e "${BLUE}🛍️  Application:${NC}"
echo "   URL: http://${FRONTEND_IP}"
echo "   Status: kubectl get service frontend-external"
echo ""

# Argo CD Access
ARGOCD_IP=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "pending...")
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d 2>/dev/null || echo "")

echo -e "${BLUE}🚀 Argo CD:${NC}"
if [ ! -z "$ARGOCD_IP" ] && [ "$ARGOCD_IP" != "pending..." ]; then
    echo "   URL: https://${ARGOCD_IP}"
else
    echo "   Port-forward: kubectl port-forward svc/argocd-server -n argocd 8080:443"
    echo "   Then visit: https://localhost:8080"
fi
echo "   Username: admin"
echo "   Password: ${ARGOCD_PASSWORD}"
echo ""

echo -e "${BLUE}📊 Useful Commands:${NC}"
echo "   View all pods:        kubectl get pods -A"
echo "   View services:        kubectl get svc"
echo "   View Argo CD apps:    kubectl get applications -n argocd"
echo "   Access Argo CD UI:    kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo ""

echo -e "${BLUE}🗑️  To delete everything:${NC}"
echo "   ./delete-all.sh"
echo "   or"
echo "   gcloud container clusters delete online-boutique --project=${PROJECT_ID} --region=${REGION}"
echo ""

echo -e "${GREEN}🎉 Your microservices are now running with GitOps enabled!${NC}"


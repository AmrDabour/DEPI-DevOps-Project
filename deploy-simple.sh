#!/bin/bash

# Simple Deployment Script (Your Current Workflow)
# This deploys ONLY the microservices application, no Argo CD

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
    echo "  ./deploy-simple.sh"
    exit 1
fi

echo -e "${BLUE}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Simple Microservices Deployment                ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}📋 Configuration:${NC}"
echo "  Project ID: $PROJECT_ID"
echo "  Region: $REGION"
echo "  Cluster: online-boutique"
echo ""

# Step 1: Create GKE Cluster
echo -e "${BLUE}🏗️  Step 1/3: Creating GKE cluster...${NC}"
gcloud container clusters create-auto online-boutique \
    --project=${PROJECT_ID} \
    --region=${REGION}

echo -e "${GREEN}✅ Cluster created!${NC}"
echo ""

# Step 2: Get cluster credentials
echo -e "${BLUE}🔑 Step 2/3: Getting cluster credentials...${NC}"
gcloud container clusters get-credentials online-boutique \
    --project=${PROJECT_ID} \
    --region=${REGION}

echo -e "${GREEN}✅ Credentials configured!${NC}"
echo ""

# Step 3: Deploy Application
echo -e "${BLUE}🚀 Step 3/3: Deploying microservices application...${NC}"
kubectl apply -f ./release/kubernetes-manifests.yaml

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

FRONTEND_IP=$(kubectl get service frontend-external | awk 'NR==2 {print $4}')
echo -e "${BLUE}🛍️  Application URL:${NC}"
echo "   http://${FRONTEND_IP}"
echo ""

echo -e "${BLUE}📊 Useful Commands:${NC}"
echo "   View all pods:        kubectl get pods"
echo "   View services:        kubectl get svc"
echo "   Check frontend:       kubectl get service frontend-external"
echo ""

echo -e "${BLUE}🗑️  To delete:${NC}"
echo "   gcloud container clusters delete online-boutique --project=${PROJECT_ID} --region=${REGION}"
echo ""


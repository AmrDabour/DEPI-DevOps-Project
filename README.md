# 🛍️ Microservices E-Commerce Demo

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)]()
[![License](https://img.shields.io/badge/license-Apache%202.0-blue)]()
[![Kubernetes](https://img.shields.io/badge/kubernetes-ready-326CE5?logo=kubernetes)]()
[![Docker](https://img.shields.io/badge/docker-enabled-2496ED?logo=docker)]()

A cloud-native microservices demonstration application showcasing modern e-commerce architecture built with multiple programming languages and deployed on Kubernetes.

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Services](#-services)
- [Technology Stack](#-technology-stack)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Deployment Options](#-deployment-options)
- [Configuration](#-configuration)
- [Development](#-development)
- [Testing](#-testing)
- [Monitoring](#-monitoring)
- [Contributing](#-contributing)
- [Troubleshooting](#-troubleshooting)
- [License](#-license)

---

## 🎯 Overview

This project demonstrates a complete microservices-based e-commerce platform that includes:

- **11 Microservices** written in different programming languages
- **gRPC** for inter-service communication
- **Kubernetes** for container orchestration
- **Terraform** for infrastructure as code
- **Skaffold** for continuous development
- **Kustomize** for Kubernetes configuration management

### Key Features

✅ Polyglot architecture (Go, Python, Java, Node.js, C#)  
✅ Cloud-native design patterns  
✅ Service mesh support (Istio)  
✅ Observability (tracing, metrics, logging)  
✅ CI/CD ready  
✅ Multi-platform support (linux/amd64, linux/arm64)  
✅ Load testing capabilities  
✅ Shopping assistant with AI integration  

---

## 🏗️ Architecture

```
┌─────────────┐
│   Frontend  │
│   (Go)      │
└─────┬───────┘
      │
      ├─────────────┬──────────────┬─────────────┬──────────────┬─────────────┐
      │             │              │             │              │             │
┌─────▼──────┐ ┌───▼────────┐ ┌──▼──────────┐ ┌▼──────────┐ ┌─▼──────────┐ │
│  AdService │ │ Cart       │ │ Product     │ │ Currency  │ │ Checkout   │ │
│  (Java)    │ │ Service    │ │ Catalog     │ │ Service   │ │ Service    │ │
│            │ │ (C#)       │ │ Service     │ │ (Node.js) │ │ (Go)       │ │
└────────────┘ └────────────┘ │ (Go)        │ └───────────┘ └─────┬──────┘ │
                               └─────────────┘                     │        │
                                      │                            │        │
                               ┌──────▼───────┐           ┌────────▼──────┐ │
                               │Recommendation│           │   Payment     │ │
                               │  Service     │           │   Service     │ │
                               │  (Python)    │           │   (Node.js)   │ │
                               └──────────────┘           └───────────────┘ │
                                                                             │
                            ┌────────────────────────────────────────────────┘
                            │
                    ┌───────▼────────┐         ┌──────────────────┐
                    │   Shipping     │         │   Email          │
                    │   Service      │         │   Service        │
                    │   (Go)         │         │   (Python)       │
                    └────────────────┘         └──────────────────┘
```

### Communication Flow

- **Frontend** serves the web UI and aggregates data from backend services
- **gRPC** is used for all inter-service communication
- **REST/HTTP** endpoints for health checks and external access
- **Shopping Assistant** provides AI-powered recommendations

---

## 🎛️ Services

| Service | Language | Description | Port |
|---------|----------|-------------|------|
| **frontend** | Go | Exposes an HTTP server for the web UI. Handles user requests and aggregates data from backend services | 8080 |
| **cartservice** | C# (.NET) | Stores shopping cart items in Redis and manages cart operations | 7070 |
| **productcatalogservice** | Go | Provides product information from a JSON file and serves product queries | 3550 |
| **currencyservice** | Node.js | Converts currency amounts using real-time exchange rates | 7000 |
| **paymentservice** | Node.js | Processes payment transactions (mock implementation) | 50051 |
| **shippingservice** | Go | Calculates shipping costs based on cart items and destination | 50051 |
| **emailservice** | Python | Sends order confirmation emails to customers | 8080 |
| **checkoutservice** | Go | Orchestrates the checkout process: payment, shipping, and email | 5050 |
| **recommendationservice** | Python | Recommends products based on cart contents using ML | 8080 |
| **adservice** | Java | Serves contextual advertisements based on keywords | 9555 |
| **shoppingassistantservice** | Python | AI-powered shopping assistant for product recommendations | 8080 |
| **loadgenerator** | Python/Locust | Continuously generates realistic user traffic for testing | 8089 |

---

## 💻 Technology Stack

### Languages & Frameworks
- **Go** - Frontend, Product Catalog, Checkout, Shipping
- **Python** - Email, Recommendation, Shopping Assistant, Load Generator
- **Java** - Ad Service
- **Node.js** - Currency, Payment
- **C# (.NET)** - Cart Service

### Infrastructure & Tools
- **Kubernetes** - Container orchestration
- **Docker** - Containerization
- **Skaffold** - Local development and CI/CD
- **Kustomize** - Kubernetes configuration management
- **Terraform** - Infrastructure as Code (GCP)
- **Istio** - Service mesh (optional)

### Data Stores
- **Redis** - Cart session storage
- **Memorystore** - Managed Redis (GCP)
- **Spanner** - Distributed SQL database (optional)
- **AlloyDB** - PostgreSQL-compatible database (optional)

### Observability
- **OpenTelemetry** - Distributed tracing
- **Google Cloud Operations** - Logging and monitoring
- **Prometheus** - Metrics collection
- **Grafana** - Metrics visualization

---

## 📦 Prerequisites

Before you begin, ensure you have the following installed:

### Required
- **Docker** (v20.10+) - [Install Docker](https://docs.docker.com/get-docker/)
- **Kubernetes** (v1.24+) - [Install kubectl](https://kubernetes.io/docs/tasks/tools/)
- **Git** - [Install Git](https://git-scm.com/downloads)

### Recommended
- **Skaffold** (v2.0+) - [Install Skaffold](https://skaffold.dev/docs/install/)
- **Kustomize** (v4.5+) - [Install Kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/)
- **Terraform** (v1.0+) - [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### For Local Development
- **Minikube** or **Kind** - For local Kubernetes cluster
- **Skaffold** - For hot-reload development

### For GCP Deployment
- **Google Cloud SDK (gcloud)** - [Install gcloud](https://cloud.google.com/sdk/docs/install)
- **Active GCP Project** with billing enabled
- **Container Registry** or **Artifact Registry** access

---

## 🚀 Quick Start

**🎯 Choose your deployment method:** See [DEPLOYMENT-GUIDE.md](DEPLOYMENT-GUIDE.md) for all options.

### Option 1: Automated GKE Deployment (Recommended)

**Simple deployment (just the app):**
```bash
export PROJECT_ID=your-project-id
export REGION=us-central1
./deploy-simple.sh
```

**With Argo CD (includes GitOps):**
```bash
export PROJECT_ID=your-project-id
export REGION=us-central1
./deploy-with-argocd.sh
```

### Option 2: Manual Deployment (Your Current Method)

```bash
# 1. Create GKE cluster
gcloud container clusters create-auto online-boutique \
    --project=${PROJECT_ID} --region=${REGION}

# 2. Deploy application
kubectl apply -f ./release/kubernetes-manifests.yaml

# 3. Get frontend URL
kubectl get service frontend-external | awk '{print $4}'
```

**Delete:** `./delete-all.sh` or `gcloud container clusters delete online-boutique --project=${PROJECT_ID} --region=${REGION}`

### Option 3: Using Pre-built Images (Any K8s Cluster)

Deploy the application using pre-built images from the release directory:

```bash
# Clone the repository
git clone https://github.com/AmrDabour/DEPI-DevOps-Project.git
cd microservices-demo

# Deploy to Kubernetes
kubectl apply -f ./release/kubernetes-manifests.yaml

# Wait for all pods to be ready
kubectl wait --for=condition=ready pod --all -n default --timeout=300s

# Get the frontend external IP
kubectl get service frontend-external

# Access the application
# Navigate to http://<EXTERNAL-IP>
```

### Option 2: Using Skaffold (Development)

Build and deploy with hot-reload for development:

```bash
# Clone the repository
git clone https://github.com/AmrDabour/DEPI-DevOps-Project.git
cd microservices-demo

# Start skaffold in dev mode
skaffold dev

# Or run once without watching
skaffold run

# Access the application at http://localhost:8080
```

### Option 3: Build and Push Custom Images

Build all services and push to your Docker Hub repository:

```bash
# Login to Docker Hub
docker login

# Build and push all services (PowerShell)
.\build_all_services.ps1

# Or using bash
./build_and_push.sh

# Update manifests with your image registry
# Edit kubernetes-manifests/*.yaml files to use your images

# Deploy to Kubernetes
kubectl apply -f kubernetes-manifests/
```

### Verify Deployment

```bash
# Check all pods are running
kubectl get pods

# Check services
kubectl get services

# View logs for a specific service
kubectl logs -l app=frontend

# Access the application
kubectl port-forward svc/frontend 8080:80
# Navigate to http://localhost:8080
```

---

## 🌐 Deployment Options

### Local Kubernetes (Minikube/Kind)

```bash
# Start minikube
minikube start --cpus=4 --memory=8192

# Enable addons
minikube addons enable ingress
minikube addons enable metrics-server

# Deploy using skaffold
skaffold dev

# Access the application
minikube service frontend-external
```

### Google Kubernetes Engine (GKE)

#### Using Terraform

```bash
cd terraform

# Initialize Terraform
terraform init

# Create terraform.tfvars file
cat > terraform.tfvars << EOF
gcp_project_id = "your-project-id"
region         = "us-central1"
zone           = "us-central1-a"
cluster_name   = "microservices-demo"
EOF

# Plan and apply
terraform plan
terraform apply

# Get cluster credentials
gcloud container clusters get-credentials microservices-demo \
  --region us-central1 --project your-project-id

# Deploy the application
skaffold run --default-repo=gcr.io/your-project-id
```

#### Manual GKE Setup

```bash
# Create GKE cluster
gcloud container clusters create microservices-demo \
  --zone=us-central1-a \
  --machine-type=e2-standard-2 \
  --num-nodes=4 \
  --enable-autoscaling \
  --min-nodes=3 \
  --max-nodes=10

# Get credentials
gcloud container clusters get-credentials microservices-demo --zone=us-central1-a

# Deploy
kubectl apply -f release/kubernetes-manifests.yaml
```

### Using Kustomize Components

Kustomize allows you to customize deployments with various components:

```bash
# Base deployment
kubectl apply -k kustomize/base

# With specific components
kubectl apply -k kustomize/components/memorystore
kubectl apply -k kustomize/components/service-mesh-istio
kubectl apply -k kustomize/components/google-cloud-operations

# Custom combination
cat <<EOF > kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- kustomize/base
components:
- kustomize/components/memorystore
- kustomize/components/google-cloud-operations
- kustomize/components/network-policies
EOF

kubectl apply -k .
```

### Available Kustomize Components

- **alloydb** - Use AlloyDB for database
- **memorystore** - Use Google Cloud Memorystore for Redis
- **spanner** - Use Cloud Spanner for database
- **service-mesh-istio** - Deploy with Istio service mesh
- **google-cloud-operations** - Enable GCP logging and monitoring
- **network-policies** - Apply network security policies
- **shopping-assistant** - Enable AI shopping assistant
- **cymbal-branding** - Custom branding
- **non-public-frontend** - Internal-only frontend
- **without-loadgenerator** - Disable load generator
- **custom-base-url** - Custom base URL configuration
- **container-images-registry** - Use custom container registry
- **container-images-tag** - Use specific image tags

### GitOps with Argo CD 🚀 NEW!

Deploy and manage your microservices using GitOps principles with Argo CD:

```bash
# Quick install (5 minutes)
./argocd/install/install-argocd.sh

# Access Argo CD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
# Visit: https://localhost:8080

# Deploy all microservices via GitOps
kubectl apply -f argocd/applications/microservices-app.yaml
```

**Benefits of using Argo CD:**
- ✅ Automated synchronization from Git
- ✅ Declarative GitOps continuous delivery
- ✅ Easy rollback to any Git commit
- ✅ Beautiful UI for visualization
- ✅ Multi-environment support
- ✅ Automatic drift detection and remediation

**Deployment Strategies:**
1. **Single App** - All services managed together (recommended for beginners)
2. **Kustomize-Based** - Environment-specific configurations (recommended for production)
3. **Individual Services** - Per-service control (advanced)
4. **App of Apps** - Hierarchical management (enterprise)

**📖 Full Documentation:** See [argocd/](argocd/) directory for complete guides:
- [Quick Start Guide](argocd/QUICK-START.md) - Get started in 5 minutes
- [Complete Guide](argocd/ARGOCD-GUIDE.md) - In-depth documentation
- [README](argocd/README.md) - Directory overview

---

## ⚙️ Configuration

### Environment Variables

Each service can be configured using environment variables. Common configurations:

```yaml
# Frontend
PORT: "8080"
PRODUCT_CATALOG_SERVICE_ADDR: "productcatalogservice:3550"
CURRENCY_SERVICE_ADDR: "currencyservice:7000"
CART_SERVICE_ADDR: "cartservice:7070"
RECOMMENDATION_SERVICE_ADDR: "recommendationservice:8080"
CHECKOUT_SERVICE_ADDR: "checkoutservice:5050"
SHIPPING_SERVICE_ADDR: "shippingservice:50051"
AD_SERVICE_ADDR: "adservice:9555"

# Cart Service (Redis)
REDIS_ADDR: "redis-cart:6379"

# Currency Service
PORT: "7000"
```

### Custom Configuration

1. **Edit Kubernetes manifests** in `kubernetes-manifests/` directory
2. **Use Kustomize overlays** for environment-specific configurations
3. **Set environment variables** in deployment YAML files
4. **Configure resource limits** for each service

### Image Registry Configuration

To use your own Docker registry:

```bash
# Using Skaffold
skaffold run --default-repo=your-registry.io/your-project

# Using Kustomize component
kubectl apply -k kustomize/components/container-images-registry
# Edit the component to set your registry
```

---

## 👨‍💻 Development

### Local Development Workflow

```bash
# Start Skaffold in dev mode for hot reload
skaffold dev

# Make changes to source code
# Skaffold will automatically:
# 1. Rebuild the affected service
# 2. Push the new image
# 3. Redeploy to Kubernetes
# 4. Stream logs to your terminal
```

### Building Individual Services

```bash
# Navigate to service directory
cd src/frontend

# Build Docker image
docker build -t frontend:dev .

# Run locally
docker run -p 8080:8080 frontend:dev
```

### Running Services Locally (Without Docker)

Each service directory contains specific instructions. Example for frontend:

```bash
cd src/frontend

# Install dependencies
go mod download

# Run the service
go run .
```

### Code Structure

```
src/
├── adservice/              # Java service with Gradle
│   ├── src/
│   ├── build.gradle
│   └── Dockerfile
├── cartservice/            # C# service with .NET
│   ├── src/
│   ├── cartservice.sln
│   └── Dockerfile
├── checkoutservice/        # Go service
│   ├── main.go
│   ├── go.mod
│   └── Dockerfile
└── [other services...]
```

---

## 🧪 Testing

### Load Testing

The project includes a load generator using Locust:

```bash
# Deploy with load generator
skaffold run

# Access Locust UI
kubectl port-forward svc/loadgenerator 8089:8089

# Navigate to http://localhost:8089
```

### Manual Testing

```bash
# Test product catalog
curl http://<frontend-ip>/api/products

# Test health endpoints
kubectl exec -it <frontend-pod> -- curl localhost:8080/_healthz
```

### Verify Products Script

```bash
# Verify all products are accessible
python verify_products.py
```

### Integration Tests

Each service may include unit and integration tests:

```bash
# Example: Cart Service tests
cd src/cartservice
dotnet test

# Example: Frontend tests
cd src/frontend
go test ./...
```

---

## 📊 Monitoring

### Health Checks

All services expose health check endpoints:

```bash
# Check frontend health
kubectl exec -it <frontend-pod> -- curl localhost:8080/_healthz

# Check all pods
kubectl get pods -o wide
```

### Logs

```bash
# View logs for specific service
kubectl logs -f deployment/frontend

# View logs for all services
kubectl logs -f -l app

# Tail logs with stern (if installed)
stern frontend
```

### Metrics with Google Cloud Operations

When deployed with the `google-cloud-operations` component:

```bash
# Deploy with monitoring
kubectl apply -k kustomize/components/google-cloud-operations

# View in GCP Console:
# - Cloud Trace for distributed tracing
# - Cloud Logging for centralized logs
# - Cloud Monitoring for metrics and alerts
```

### Service Mesh Observability (Istio)

```bash
# Deploy with Istio
kubectl apply -k kustomize/components/service-mesh-istio

# Access Kiali dashboard
istioctl dashboard kiali

# Access Grafana
istioctl dashboard grafana

# Access Jaeger for tracing
istioctl dashboard jaeger
```

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### Reporting Issues

- Use GitHub Issues to report bugs
- Include detailed reproduction steps
- Attach relevant logs and screenshots

### Submitting Changes

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow the existing code style for each language
- Add tests for new features
- Update documentation as needed
- Ensure all services build successfully
- Test in a local Kubernetes environment before submitting

---

## 🔧 Troubleshooting

### Common Issues

#### Pods Not Starting

```bash
# Check pod status
kubectl get pods

# Describe problematic pod
kubectl describe pod <pod-name>

# Check events
kubectl get events --sort-by='.lastTimestamp'
```

#### Image Pull Errors

```bash
# Verify image exists
docker pull <image-name>

# Check image pull secrets
kubectl get secrets

# Create docker registry secret if needed
kubectl create secret docker-registry regcred \
  --docker-server=<your-registry> \
  --docker-username=<username> \
  --docker-password=<password>
```

#### Service Communication Issues

```bash
# Check service endpoints
kubectl get endpoints

# Test service connectivity from a pod
kubectl run -it --rm debug --image=alpine --restart=Never -- sh
# Inside pod: wget -O- http://frontend:80
```

#### Memory or CPU Issues

```bash
# Check resource usage
kubectl top pods
kubectl top nodes

# Adjust resource limits in manifests
# Edit kubernetes-manifests/<service>.yaml
```

### Debugging Tips

1. **Enable verbose logging** in service configurations
2. **Use kubectl port-forward** to access services locally
3. **Check service dependencies** are running before dependent services
4. **Review resource limits** if pods are being OOMKilled
5. **Examine network policies** if using the network-policies component

### Getting Help

- **GitHub Issues**: [Report a bug or request a feature](https://github.com/AmrDabour/DEPI-DevOps-Project/issues)
- **Discussions**: Join community discussions
- **Documentation**: Check service-specific READMEs in `src/*/README.md`

---

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Based on Google Cloud Platform's microservices demo
- Built as part of the DEPI DevOps Project
- Maintained by [AmrDabour](https://github.com/AmrDabour)

---

## 📞 Contact

**Project Owner**: Amr Dabour  
**Repository**: [DEPI-DevOps-Project](https://github.com/AmrDabour/DEPI-DevOps-Project)

---

## 🗺️ Roadmap

- [ ] Add Helm charts for deployment
- [x] **Implement GitOps with ArgoCD** ✅ [See Documentation](argocd/)
- [ ] Add more comprehensive tests
- [ ] Support for additional cloud providers (AWS, Azure)
- [ ] Enhanced monitoring dashboards
- [x] **Security scanning integration** ✅ [Implemented in CI/CD]
- [ ] Performance optimization guides

---

<div align="center">

**⭐ If you find this project helpful, please consider giving it a star! ⭐**

Made with ❤️ by the DEPI DevOps Team

</div>

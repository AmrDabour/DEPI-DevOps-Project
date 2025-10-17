#!/bin/bash

# Configuration
DOCKER_USERNAME="your-dockerhub-username"  # Change this to your Docker Hub username
IMAGE_NAME="productcatalogservice"
IMAGE_TAG="v1.0-custom"

# Full image name
FULL_IMAGE="${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"

echo "Building productcatalogservice with new products..."
echo "=========================================="

# Build the Docker image
cd src/productcatalogservice
docker build -t ${FULL_IMAGE} .

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "To push to Docker Hub:"
    echo "1. Login: docker login"
    echo "2. Push: docker push ${FULL_IMAGE}"
    echo ""
    echo "To use in Kubernetes, update the image in kubernetes manifests:"
    echo "   image: ${FULL_IMAGE}"
else
    echo "❌ Build failed!"
    exit 1
fi


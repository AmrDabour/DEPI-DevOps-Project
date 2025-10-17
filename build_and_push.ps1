# PowerShell script to build and push Frontend Docker image
# Modern Dark Mode & AWS-Style Design

# Configuration
$DOCKER_USERNAME = "amrdabour"
$IMAGE_NAME = "frontend"
$IMAGE_TAG = "latest"  # Using latest tag for glass effect update

# Full image name
$FULL_IMAGE = "${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
$LATEST_IMAGE = "${DOCKER_USERNAME}/${IMAGE_NAME}:latest"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Building Modern Frontend Image" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Image: $FULL_IMAGE" -ForegroundColor Yellow
Write-Host "Latest: $LATEST_IMAGE" -ForegroundColor Yellow
Write-Host "Features:" -ForegroundColor White
Write-Host "  - Dark Mode Design" -ForegroundColor Green
Write-Host "  - AWS-Inspired UI" -ForegroundColor Green
Write-Host "  - Glassmorphism Effects" -ForegroundColor Green
Write-Host "  - Modern Landing Page" -ForegroundColor Green
Write-Host "  - 31 New Products" -ForegroundColor Green
Write-Host "  - Social Links Footer`n" -ForegroundColor Green

# Build the Docker image
Set-Location src\frontend

Write-Host "Building Docker image..." -ForegroundColor Yellow
docker build -t $FULL_IMAGE -t $LATEST_IMAGE .

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Build successful!" -ForegroundColor Green
    
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Next Steps:" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    Write-Host "1. Push to Docker Hub:" -ForegroundColor White
    Write-Host "   docker push $FULL_IMAGE" -ForegroundColor Yellow
    Write-Host "   docker push $LATEST_IMAGE`n" -ForegroundColor Yellow
    
    Write-Host "2. Update manifest files with new version:" -ForegroundColor White
    Write-Host "   release/kubernetes-manifests.yaml" -ForegroundColor Yellow
    Write-Host "   kubernetes-manifests/frontend.yaml`n" -ForegroundColor Yellow
    
    Write-Host "3. Update Kubernetes deployment:" -ForegroundColor White
    Write-Host "   kubectl set image deployment/frontend server=$FULL_IMAGE`n" -ForegroundColor Yellow
    
    Write-Host "4. Apply changes:" -ForegroundColor White
    Write-Host "   kubectl apply -f release/kubernetes-manifests.yaml`n" -ForegroundColor Yellow
    
    # Ask if user wants to push
    $push = Read-Host "`nDo you want to push to Docker Hub now? (y/n)"
    if ($push -eq "y" -or $push -eq "Y") {
        Write-Host "`nPushing to Docker Hub..." -ForegroundColor Yellow
        docker push $FULL_IMAGE
        docker push $LATEST_IMAGE
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "`n✅ Pushed successfully!" -ForegroundColor Green
            
            # Ask if user wants to update manifests
            $updateManifest = Read-Host "`nDo you want to update the manifest files? (y/n)"
            if ($updateManifest -eq "y" -or $updateManifest -eq "Y") {
                Set-Location ..\..
                
                Write-Host "`nUpdating manifest files..." -ForegroundColor Yellow
                
                # Update release/kubernetes-manifests.yaml
                (Get-Content release/kubernetes-manifests.yaml) -replace 'image: amrdabour/frontend:v[0-9]+\.[0-9]+-modern', "image: $FULL_IMAGE" | Set-Content release/kubernetes-manifests.yaml
                
                # Update kubernetes-manifests/frontend.yaml
                (Get-Content kubernetes-manifests/frontend.yaml) -replace 'image: amrdabour/frontend:v[0-9]+\.[0-9]+-modern', "image: $FULL_IMAGE" | Set-Content kubernetes-manifests/frontend.yaml
                
                Write-Host "✅ Manifest files updated!" -ForegroundColor Green
                
                $deploy = Read-Host "`nDo you want to deploy to Kubernetes now? (y/n)"
                if ($deploy -eq "y" -or $deploy -eq "Y") {
                    Write-Host "`nDeploying to Kubernetes..." -ForegroundColor Yellow
                    kubectl set image deployment/frontend server=$FULL_IMAGE
                    kubectl rollout status deployment/frontend
                    Write-Host "`n✅ Deployment complete!" -ForegroundColor Green
                    
                    Write-Host "`nGetting external IP..." -ForegroundColor Yellow
                    kubectl get service frontend-external
                }
            }
        }
    }
} else {
    Write-Host "`n❌ Build failed!" -ForegroundColor Red
    exit 1
}

Set-Location ..\..

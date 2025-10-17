# Build and Push All Microservices to amrdabour Docker Hub
# This script builds all microservices and pushes them to amrdabour Docker Hub repository

Write-Host "🚀 Starting build and push process for all microservices..." -ForegroundColor Green

# Set the Docker Hub repository
$DOCKER_REPO = "amrdabour"
$TAG = "latest"

# Array of services to build
$services = @(
    @{name="emailservice"; path="src/emailservice"; dockerfile="Dockerfile"},
    @{name="checkoutservice"; path="src/checkoutservice"; dockerfile="Dockerfile"},
    @{name="recommendationservice"; path="src/recommendationservice"; dockerfile="Dockerfile"},
    @{name="frontend"; path="src/frontend"; dockerfile="Dockerfile"},
    @{name="paymentservice"; path="src/paymentservice"; dockerfile="Dockerfile"},
    @{name="productcatalogservice"; path="src/productcatalogservice"; dockerfile="Dockerfile"},
    @{name="cartservice"; path="src/cartservice"; dockerfile="Dockerfile"},
    @{name="currencyservice"; path="src/currencyservice"; dockerfile="Dockerfile"},
    @{name="shippingservice"; path="src/shippingservice"; dockerfile="Dockerfile"},
    @{name="adservice"; path="src/adservice"; dockerfile="Dockerfile"},
    @{name="loadgenerator"; path="src/loadgenerator"; dockerfile="Dockerfile"}
)

# Function to build and push a service
function Build-AndPush-Service {
    param(
        [string]$ServiceName,
        [string]$ServicePath,
        [string]$Dockerfile
    )
    
    Write-Host "🔨 Building $ServiceName..." -ForegroundColor Yellow
    
    # Change to service directory
    Push-Location $ServicePath
    
    try {
        # Build the Docker image
        Write-Host "   Building Docker image for $ServiceName..." -ForegroundColor Cyan
        docker build -t "$DOCKER_REPO/$ServiceName`:$TAG" -f $Dockerfile .
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ Build successful for $ServiceName" -ForegroundColor Green
            
            # Push the Docker image
            Write-Host "   📤 Pushing $ServiceName to Docker Hub..." -ForegroundColor Cyan
            docker push "$DOCKER_REPO/$ServiceName`:$TAG"
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "   ✅ Push successful for $ServiceName" -ForegroundColor Green
            } else {
                Write-Host "   ❌ Push failed for $ServiceName" -ForegroundColor Red
                return $false
            }
        } else {
            Write-Host "   ❌ Build failed for $ServiceName" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "   ❌ Error building/pushing $ServiceName`: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
    finally {
        Pop-Location
    }
    
    return $true
}

# Build and push all services
$successCount = 0
$totalServices = $services.Count

foreach ($service in $services) {
    Write-Host "`n📦 Processing $($service.name)..." -ForegroundColor Magenta
    
    if (Build-AndPush-Service -ServiceName $service.name -ServicePath $service.path -Dockerfile $service.dockerfile) {
        $successCount++
    } else {
        Write-Host "❌ Failed to build/push $($service.name)" -ForegroundColor Red
    }
}

Write-Host "`n📊 Build Summary:" -ForegroundColor Green
Write-Host "   ✅ Successful: $successCount/$totalServices" -ForegroundColor Green
Write-Host "   ❌ Failed: $($totalServices - $successCount)/$totalServices" -ForegroundColor Red

if ($successCount -eq $totalServices) {
    Write-Host "`n🎉 All services built and pushed successfully!" -ForegroundColor Green
    Write-Host "🔗 Images are available at: https://hub.docker.com/r/$DOCKER_REPO" -ForegroundColor Cyan
} else {
    Write-Host "`n⚠️  Some services failed to build/push. Please check the errors above." -ForegroundColor Yellow
}

Write-Host "`n📝 Next steps:" -ForegroundColor Blue
Write-Host "   1. Update kubernetes-manifests.yaml with new image references" -ForegroundColor White
Write-Host "   2. Deploy using: kubectl apply -f ./release/kubernetes-manifests.yaml" -ForegroundColor White


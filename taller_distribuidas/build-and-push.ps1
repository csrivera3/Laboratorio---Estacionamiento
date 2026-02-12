param(
    [Parameter(Mandatory=$true)]
    [string]$DockerUser,
    
    [Parameter(Mandatory=$false)]
    [string]$Version = "1.0.0"
)

# Función para imprimir colores
function Write-Success {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Cyan
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Red
}

function Write-Header {
    param([string]$Title)
    Write-Host ""
    Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
}

# Servicios a construir
$Services = @("ms-clientes", "ms-tickets", "notificacion-service", "zone-core")

Write-Header "Docker Build & Push Script"
Write-Info "📦 Iniciando construcción de imágenes Docker"
Write-Info "👤 Usuario Docker Hub: $DockerUser"
Write-Info "🏷️  Versión: $Version"

# Verificar que Docker está instalado
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error-Custom "❌ Docker no está instalado o no está en el PATH"
    exit 1
}

# Construir todas las imágenes
Write-Header "Construcción de Imágenes"

foreach ($service in $Services) {
    Write-Info "🔨 Construyendo: $service"
    
    $imageName = "$DockerUser/$service"
    $imageTag = "$imageName:$Version"
    $imageLatest = "$imageName:latest"
    
    # Cambiar a directorio del servicio
    Push-Location "./$service"
    
    try {
        # Construir imagen
        Write-Info "  → Creando: $imageTag"
        docker build -t $imageTag -t $imageLatest . | Out-Null
        
        if ($LASTEXITCODE -eq 0) {
            Write-Success "  ✅ Imagen construida: $imageTag"
            Write-Success "  ✅ Imagen construida: $imageLatest"
        } else {
            Write-Error-Custom "  ❌ Error al construir $service"
            Pop-Location
            exit 1
        }
    } finally {
        Pop-Location
    }
    
    Write-Host ""
}

Write-Success "════════════════════════════════════════"
Write-Success "✅ Todas las imágenes han sido construidas"
Write-Success "════════════════════════════════════════"

Write-Host ""
Write-Info "Imágenes disponibles:"
foreach ($service in $Services) {
    Write-Host "  • $DockerUser/$service`:$Version" -ForegroundColor Yellow
    Write-Host "  • $DockerUser/$service`:latest" -ForegroundColor Yellow
}

# Opción para publicar
Write-Host ""
$response = Read-Host "¿Deseas publicar las imágenes en Docker Hub? (s/n)"

if ($response -eq 's' -or $response -eq 'S') {
    Write-Header "Publicando Imágenes"
    
    # Verificar login
    Write-Info "🔐 Verificando autenticación en Docker..."
    
    foreach ($service in $Services) {
        $imageName = "$DockerUser/$service"
        $imageTag = "$imageName`:$Version"
        $imageLatest = "$imageName`:latest"
        
        Write-Info "📤 Publicando: $service"
        
        # Publicar versión específica
        Write-Info "  → Subiendo: $imageTag"
        docker push $imageTag | Out-Null
        
        if ($LASTEXITCODE -ne 0) {
            Write-Error-Custom "❌ Error al publicar $imageTag"
            Write-Info "Asegúrate de estar logueado: docker login -u $DockerUser"
            exit 1
        }
        Write-Success "  ✅ Publicado: $imageTag"
        
        # Publicar latest
        Write-Info "  → Subiendo: $imageLatest"
        docker push $imageLatest | Out-Null
        
        if ($LASTEXITCODE -eq 0) {
            Write-Success "  ✅ Publicado: $imageLatest"
        }
        
        Write-Host ""
    }
    
    Write-Success "════════════════════════════════════════"
    Write-Success "✅ ¡Publicación completada!"
    Write-Success "════════════════════════════════════════"
    
    Write-Host ""
    Write-Info "📝 Para descargar y ejecutar:"
    Write-Host "  docker pull $DockerUser/<service>`:latest" -ForegroundColor Yellow
    Write-Host "  docker run -p <puerto>:<puerto> $DockerUser/<service>`:latest" -ForegroundColor Yellow
} else {
    Write-Info ""
    Write-Success "✅ Imágenes construidas localmente"
    Write-Info ""
    Write-Info "Para publicar manualmente, ejecuta:"
    foreach ($service in $Services) {
        Write-Host "  docker push $DockerUser/$service`:$Version" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Info "Para ejecutar todo con docker-compose:"
Write-Host "  docker-compose up -d" -ForegroundColor Yellow

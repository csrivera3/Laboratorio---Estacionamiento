#!/bin/bash

# Script para construir y publicar imágenes Docker
# Uso: ./build-and-push.sh <docker-hub-user>

if [ -z "$1" ]; then
    echo "❌ Error: Debes proporcionar tu usuario de Docker Hub"
    echo "Uso: $0 <docker-hub-user>"
    exit 1
fi

DOCKER_USER=$1
VERSION="1.0.0"
REGISTRY="docker.io"

echo "📦 Iniciando construcción de imágenes Docker..."
echo "👤 Usuario Docker Hub: $DOCKER_USER"
echo "🏷️  Versión: $VERSION"
echo ""

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Servicios a construir
declare -a SERVICES=("ms-clientes" "ms-tickets" "notificacion-service" "zone-core")

# Función para construir y publicar
build_and_push() {
    local service=$1
    local port=$2
    
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${BLUE}🔨 Construyendo: $service${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    
    # Construir imagen
    if docker build -t ${DOCKER_USER}/${service}:${VERSION} \
                    -t ${DOCKER_USER}/${service}:latest \
                    ./${service}; then
        echo -e "${GREEN}✅ Imagen construida exitosamente: ${DOCKER_USER}/${service}:${VERSION}${NC}"
    else
        echo -e "${RED}❌ Error al construir ${service}${NC}"
        exit 1
    fi
    
    echo ""
}

# Función para publicar
push_images() {
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${BLUE}🚀 Publicando imágenes en Docker Hub${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""
    
    for service in "${SERVICES[@]}"; do
        echo -e "${BLUE}📤 Publicando: $service${NC}"
        
        if docker push ${DOCKER_USER}/${service}:${VERSION} && \
           docker push ${DOCKER_USER}/${service}:latest; then
            echo -e "${GREEN}✅ ${service} publicado exitosamente${NC}"
        else
            echo -e "${RED}❌ Error al publicar ${service}${NC}"
            exit 1
        fi
        echo ""
    done
}

# Verificar si estamos logueados en Docker
echo -e "${BLUE}🔐 Verificando autenticación en Docker Hub...${NC}"
if ! docker info | grep -q "Username: $DOCKER_USER"; then
    echo -e "${RED}⚠️  No pareces estar logueado como $DOCKER_USER${NC}"
    echo "Ejecuta: docker login -u $DOCKER_USER"
    read -p "¿Deseas continuar? (s/n): " confirm
    if [ "$confirm" != "s" ]; then
        exit 1
    fi
fi
echo -e "${GREEN}✅ Autenticación confirmada${NC}"
echo ""

# Construir todas las imágenes
for service in "${SERVICES[@]}"; do
    build_and_push $service
done

# Preguntar si publicar
echo ""
read -p "¿Deseas publicar las imágenes en Docker Hub? (s/n): " publish

if [ "$publish" == "s" ]; then
    push_images
    
    echo ""
    echo -e "${GREEN}════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ ¡Proceso completado exitosamente!${NC}"
    echo -e "${GREEN}════════════════════════════════════════${NC}"
    echo ""
    echo "🐳 Imágenes disponibles en Docker Hub:"
    for service in "${SERVICES[@]}"; do
        echo "  - ${DOCKER_USER}/${service}:${VERSION}"
        echo "  - ${DOCKER_USER}/${service}:latest"
    done
    echo ""
    echo "📝 Para descargar y ejecutar:"
    echo "  docker pull ${DOCKER_USER}/<service>:latest"
    echo "  docker run -p <port>:<port> ${DOCKER_USER}/<service>:latest"
else
    echo ""
    echo -e "${GREEN}✅ Imágenes construidas localmente${NC}"
    echo ""
    echo "Para publicar manualmente, ejecuta:"
    for service in "${SERVICES[@]}"; do
        echo "  docker push ${DOCKER_USER}/${service}:${VERSION}"
    done
fi

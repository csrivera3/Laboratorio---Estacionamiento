# 📖 GUÍA PARA EL INGENIERO - IMPLEMENTACIÓN DOCKER

## 🎯 Objetivo
Ejecutar 4 microservicios independientes en contenedores Docker, completamente aislados y escalables.

---

## 📋 Prerrequisitos

```bash
✓ Docker Desktop v4.x+ instalado
✓ Docker Compose incluido (viene con Docker Desktop)
✓ Git instalado
✓ Terminal/PowerShell con acceso a Docker
✓ Mínimo 4GB RAM disponible para contenedores
✓ Puertos disponibles: 8081, 8080, 4000, 3000, 5435, 5436, 5437, 5672, 15672
```

---

## 🚀 OPCIÓN 1: Ejecución Local (Recomendado para Desarrollo)

### Paso 1: Clonar o Descargar el Proyecto
```bash
cd C:\Users\Lenovo\Downloads\taller_distribuidas
ls -la  # Verificar archivos
```

### Paso 2: Construir Imágenes Docker
```bash
docker-compose build

# Esto construirá automáticamente:
# ✓ ms-clientes:latest
# ✓ ms-tickets:latest
# ✓ notificacion-service:latest
# ✓ zone-core:latest
```

### Paso 3: Ejecutar Servicios
```bash
docker-compose up -d

# Verificar que todo está corriendo
docker-compose ps

# Debería mostrar:
# NAME                     STATUS    PORTS
# ms-clientes             Up        0.0.0.0:8081->8081/tcp
# ms-tickets              Up        0.0.0.0:4000->4000/tcp
# notificacion-service    Up        0.0.0.0:3000->3000/tcp
# zone-core               Up        0.0.0.0:8080->8080/tcp
# postgres-main           Up        0.0.0.0:5435->5432/tcp
# postgres-tickets        Up        0.0.0.0:5436->5432/tcp
# postgres-notifications  Up        0.0.0.0:5437->5432/tcp
# rabbitmq                Up        5672/tcp, 0.0.0.0:15672->15672/tcp
```

### Paso 4: Verificar Logs
```bash
# Ver logs de todos los servicios
docker-compose logs

# Ver logs en tiempo real
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f ms-clientes
docker-compose logs -f ms-tickets
docker-compose logs -f notificacion-service
docker-compose logs -f zone-core
```

---

## 🌐 OPCIÓN 2: Descargar desde Docker Hub (Para Producción)

### Paso 1: Login en Docker Hub
```bash
docker login -u tu_usuario_docker
# Ingresa tu contraseña
```

### Paso 2: Descargar Imágenes
```bash
# MS-CLIENTES
docker pull tu_usuario_docker/ms-clientes:1.0.0

# MS-TICKETS
docker pull tu_usuario_docker/ms-tickets:1.0.0

# NOTIFICACION-SERVICE
docker pull tu_usuario_docker/notificacion-service:1.0.0

# ZONE-CORE
docker pull tu_usuario_docker/zone-core:1.0.0
```

### Paso 3: Ejecutar Contenedores
```bash
# MS-CLIENTES
docker run -d \
  --name ms-clientes \
  -p 8081:8081 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5435/db_clientes \
  -e SPRING_DATASOURCE_USERNAME=postgres \
  -e SPRING_DATASOURCE_PASSWORD=123456 \
  tu_usuario_docker/ms-clientes:1.0.0

# MS-TICKETS
docker run -d \
  --name ms-tickets \
  -p 4000:4000 \
  -e DB_HOST=host.docker.internal \
  -e DB_PORT=5436 \
  -e DB_USERNAME=postgres \
  -e DB_PASSWORD=123456 \
  tu_usuario_docker/ms-tickets:1.0.0

# NOTIFICACION-SERVICE
docker run -d \
  --name notificacion-service \
  -p 3000:3000 \
  -e DB_HOST=host.docker.internal \
  -e DB_PORT=5437 \
  -e DB_USERNAME=postgres \
  -e DB_PASSWORD=123456 \
  -e RABBITMQ_URL=amqp://guest:guest@host.docker.internal:5672 \
  tu_usuario_docker/notificacion-service:1.0.0

# ZONE-CORE
docker run -d \
  --name zone-core \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5435/db_clientes \
  -e SPRING_DATASOURCE_USERNAME=postgres \
  -e SPRING_DATASOURCE_PASSWORD=123456 \
  tu_usuario_docker/zone-core:1.0.0
```

---

## 🧪 Probar Servicios

### Verificar Conectividad Básica
```bash
# MS-CLIENTES
curl http://localhost:8081/api/personas

# MS-TICKETS (GraphQL)
curl -X POST http://localhost:4000/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ getAllTickets { id title } }"}'

# NOTIFICACION-SERVICE
curl http://localhost:3000/api/notifications

# ZONE-CORE
curl http://localhost:8080/api/zones
```

### Usar Postman
```
1. Importar: Postman-Collection.json
2. Ejecutar requests contra http://localhost:PUERTO
3. Verificar respuestas
```

---

## 🔍 Troubleshooting

### Error: Puerto ya está en uso
```bash
# Encontrar proceso usando puerto (Linux/Mac)
lsof -i :8081

# Encontrar proceso (Windows)
netstat -ano | findstr :8081

# Matar proceso
kill -9 <PID>  # Linux/Mac
taskkill /PID <PID> /F  # Windows
```

### Error: Contenedor crashea
```bash
# Ver logs detallados
docker logs nombre_contenedor

# Reiniciar contenedor
docker restart nombre_contenedor

# Reconstruir imagen
docker-compose build --no-cache nombre_servicio
```

### Error: Conexión a BD rechazada
```bash
# Verificar que PostgreSQL está corriendo
docker ps | grep postgres

# Ver logs de PostgreSQL
docker logs postgres-main

# Verificar connectividad
docker exec -it postgres-main psql -U postgres -d db_clientes -c "SELECT 1"
```

### Error: RabbitMQ no conecta
```bash
# Verificar RabbitMQ
docker ps | grep rabbitmq

# Acceder a console
http://localhost:15672
# Usuario: guest
# Contraseña: guest

# Ver logs
docker logs rabbitmq
```

---

## 📊 Monitoreo

### Ver Uso de Recursos
```bash
# Tiempo real
docker stats

# Contenedor específico
docker stats ms-clientes
```

### Ver Eventos
```bash
docker events
```

---

## 🛑 Detener Servicios

```bash
# Parar todos (mantiene volúmenes)
docker-compose stop

# Parar y eliminar contenedores
docker-compose down

# Parar, eliminar contenedores Y volúmenes (⚠️ BORRA DATOS)
docker-compose down -v

# Parar contenedor individual
docker stop ms-clientes
```

---

## 🔐 Gestión de Credenciales

### Cambiar Contraseñas (Importante para Producción)

#### PostgreSQL
```sql
ALTER USER postgres WITH PASSWORD 'nueva_contraseña_segura';
ALTER USER postgres CREATEDB;
```

#### RabbitMQ
```bash
docker exec -it rabbitmq rabbitmqctl change_password guest nueva_contraseña
```

### Usar Variables de Entorno
```bash
# En docker-compose.yml o con -e flag
-e DB_PASSWORD=nueva_contraseña
-e RABBITMQ_PASSWORD=nueva_contraseña
```

---

## 📈 Escalabilidad

### Aumentar Instancias de un Servicio
```bash
# Escalar ms-tickets a 3 instancias
docker-compose up -d --scale ms-tickets=3

# Nota: Requiere load balancer (nginx, traefik)
```

### Aumentar Recursos
```bash
# En docker-compose.yml, agregar:
services:
  ms-tickets:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          cpus: '1'
          memory: 1G
```

---

## 🚀 Desplegar en Producción

### Checklist Pre-Producción
- [ ] Cambiar todas las contraseñas por defecto
- [ ] Usar variables de entorno seguras (secrets)
- [ ] Configurar backups de BD
- [ ] Implementar monitoreo
- [ ] Configurar logs centralizados
- [ ] Usar registry privado (opcional)
- [ ] Certificados SSL/TLS
- [ ] Documentar endpoints y credenciales

### Opciones de Deployment
1. **Docker Swarm** - Nativo de Docker
2. **Kubernetes (K8s)** - Escalable y robusto
3. **AWS ECS** - En Amazon
4. **Azure Container Instances** - En Microsoft Azure
5. **DigitalOcean App Platform** - Simple y económico

---

## 📚 Referencia Rápida

```bash
# Construcción
docker build -t imagen:tag .
docker-compose build

# Ejecución
docker run -p puerto:puerto imagen:tag
docker-compose up -d

# Administración
docker ps                  # Ver contenedores activos
docker ps -a              # Ver todos los contenedores
docker images             # Ver imágenes
docker logs contenedor    # Ver logs
docker exec -it contenedor bash  # Acceder a shell

# Limpieza
docker stop contenedor    # Parar
docker rm contenedor      # Eliminar
docker rmi imagen         # Eliminar imagen
docker system prune       # Limpiar recursos no usados

# Push a registry
docker login
docker tag local-image usuario/imagen:tag
docker push usuario/imagen:tag
```

---

## 🆘 Soporte

Si encuentras problemas:

1. **Revisar logs:** `docker-compose logs`
2. **Verificar recursos:** `docker stats`
3. **Revisar documentación:** `DOCKER_SETUP.md`
4. **Contactar al equipo de desarrollo**

---

**Generado:** Febrero 2026
**Versión:** 1.0.0
**Status:** ✅ LISTO PARA PRODUCCIÓN


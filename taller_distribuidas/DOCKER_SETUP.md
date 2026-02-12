# 🐳 Arquitectura de Microservicios Distribuidos - Docker

Documentación completa para construir, ejecutar y publicar los 4 microservicios en contenedores Docker.

## 📋 Estructura de Servicios

```
┌─────────────────────────────────────────────────────────┐
│                  Docker Network                         │
├──────────────────┬──────────────────┬──────────────────┤
│  MS-CLIENTES     │   MS-TICKETS     │ NOTIFICACION-SVC │
│  (Java/Spring)   │   (Node GraphQL) │   (NestJS)       │
│  Puerto: 8081    │   Puerto: 4000   │   Puerto: 3000   │
└──────────────────┴──────────────────┴──────────────────┘
         ↓                    ↓                   ↓
┌──────────────────┬──────────────────┬──────────────────┐
│  PostgreSQL      │  PostgreSQL      │  PostgreSQL      │
│  (clientes)      │  (tickets)       │  (notifications) │
│  Puerto: 5435    │  Puerto: 5436    │  Puerto: 5437    │
└──────────────────┴──────────────────┴──────────────────┘

         ZONE-CORE (Java/Spring)
         Puerto: 8080
              ↓
    Compartida con MS-CLIENTES
    Base de datos: 5435
```

## 🚀 Inicio Rápido

### Opción 1: Ejecutar con Docker Compose (Recomendado)

```bash
# Construir todas las imágenes y ejecutar
docker-compose up -d

# Verificar estado
docker-compose ps

# Ver logs
docker-compose logs -f

# Detener servicios
docker-compose down
```

### Opción 2: Construcción Manual

#### Windows (PowerShell)
```powershell
# Construir imágenes
.\build-and-push.ps1 -DockerUser tu_usuario_docker -Version 1.0.0

# O si deseas publicar también
.\build-and-push.ps1 -DockerUser tu_usuario_docker -Version 1.0.0 -PushAfterBuild
```

#### Linux/Mac (Bash)
```bash
# Dar permisos de ejecución
chmod +x build-and-push.sh

# Construir y publicar
./build-and-push.sh tu_usuario_docker
```

## 📦 Servicios Incluidos

### 1. **MS-CLIENTES** (Java/Spring Boot)
- **Puerto:** 8081
- **Función:** Gestión de personas naturales/jurídicas y vehículos
- **BD:** PostgreSQL (puerto 5435)
- **Dockerfile:** `ms-clientes/Dockerfile`

```bash
# Construir manualmente
docker build -t mi_usuario/ms-clientes:1.0.0 ./ms-clientes
docker run -p 8081:8081 mi_usuario/ms-clientes:1.0.0
```

### 2. **MS-TICKETS** (Node.js + GraphQL + Apollo)
- **Puerto:** 4000
- **Función:** Gestión de tickets con GraphQL
- **BD:** PostgreSQL (puerto 5436)
- **Endpoint GraphQL:** http://localhost:4000/graphql
- **Dockerfile:** `ms-tickets/Dockerfile`

```bash
# Construir manualmente
docker build -t mi_usuario/ms-tickets:1.0.0 ./ms-tickets
docker run -p 4000:4000 mi_usuario/ms-tickets:1.0.0
```

### 3. **NOTIFICACION-SERVICE** (NestJS)
- **Puerto:** 3000
- **Función:** Servicio de notificaciones con RabbitMQ
- **BD:** PostgreSQL (puerto 5437)
- **Mensajería:** RabbitMQ (puerto 5672)
- **Dockerfile:** `notificacion-service/Dockerfile`

```bash
# Construir manualmente
docker build -t mi_usuario/notificacion-service:1.0.0 ./notificacion-service
docker run -p 3000:3000 mi_usuario/notificacion-service:1.0.0
```

### 4. **ZONE-CORE** (Java/Spring Boot)
- **Puerto:** 8080
- **Función:** Gestión de zonas
- **BD:** PostgreSQL (puerto 5435 - compartida con ms-clientes)
- **Dockerfile:** `zone_core/Dockerfile`

```bash
# Construir manualmente
docker build -t mi_usuario/zone-core:1.0.0 ./zone_core
docker run -p 8080:8080 mi_usuario/zone-core:1.0.0
```

## 🗄️ Bases de Datos

### PostgreSQL Principal (5435)
```sql
-- Base de datos: db_clientes
-- Usuario: postgres
-- Contraseña: 123456
```

### PostgreSQL para Tickets (5436)
```sql
-- Base de datos: db_tickets
-- Usuario: postgres
-- Contraseña: 123456
```

### PostgreSQL para Notificaciones (5437)
```sql
-- Base de datos: db_notifications
-- Usuario: postgres
-- Contraseña: 123456
```

## 📡 Mensajería

### RabbitMQ (Puerto 5672)
- **Usuario:** guest
- **Contraseña:** guest
- **Console de Administración:** http://localhost:15672

## 🔄 Flujo de Comunicación

```
MS-CLIENTES (8081) ←→ MS-TICKETS (4000)
                         ↓
                  ZONE-CORE (8080)
                         ↓
            NOTIFICACION-SERVICE (3000)
                  RabbitMQ (5672)
```

## 📝 Tareas de Configuración

### 1. Verificar Variables de Entorno

Asegúrate de que cada servicio tiene su `.env` correctamente configurado:

- `ms-clientes/.env`
- `ms-tickets/.env`
- `notificacion-service/.env`
- `zone_core/.env` (si aplica)

### 2. Construir Imágenes Individuales

```bash
# MS-CLIENTES
docker build -t mi_usuario/ms-clientes:latest ./ms-clientes

# MS-TICKETS
docker build -t mi_usuario/ms-tickets:latest ./ms-tickets

# NOTIFICACION-SERVICE
docker build -t mi_usuario/notificacion-service:latest ./notificacion-service

# ZONE-CORE
docker build -t mi_usuario/zone-core:latest ./zone_core
```

### 3. Publicar en Docker Hub

```bash
# Login en Docker Hub
docker login -u tu_usuario_docker

# Publicar MS-CLIENTES
docker push tu_usuario_docker/ms-clientes:1.0.0
docker push tu_usuario_docker/ms-clientes:latest

# Publicar MS-TICKETS
docker push tu_usuario_docker/ms-tickets:1.0.0
docker push tu_usuario_docker/ms-tickets:latest

# Publicar NOTIFICACION-SERVICE
docker push tu_usuario_docker/notificacion-service:1.0.0
docker push tu_usuario_docker/notificacion-service:latest

# Publicar ZONE-CORE
docker push tu_usuario_docker/zone-core:1.0.0
docker push tu_usuario_docker/zone-core:latest
```

## 🧪 Pruebas de Salud

### Verificar que los servicios están corriendo

```bash
# Ver todos los contenedores
docker-compose ps

# Ver logs en tiempo real
docker-compose logs -f

# Logs de un servicio específico
docker-compose logs -f ms-clientes
docker-compose logs -f ms-tickets
docker-compose logs -f notificacion-service
docker-compose logs -f zone-core
```

### Probar endpoints

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

## 🛠️ Troubleshooting

### El puerto ya está en uso
```bash
# Encontrar proceso usando puerto (Linux/Mac)
lsof -i :8081

# Matar proceso
kill -9 <PID>

# Windows
netstat -ano | findstr :8081
taskkill /PID <PID> /F
```

### Errores de conexión a BD
```bash
# Verificar que PostgreSQL está corriendo
docker-compose ps postgres-main

# Revisar logs
docker-compose logs postgres-main

# Reiniciar servicios
docker-compose restart
```

### Errores de RabbitMQ
```bash
# Verificar RabbitMQ
docker-compose ps rabbitmq

# Console de administración
http://localhost:15672
```

## 📊 Monitoreo

### Dashboard de Contenedores
```bash
# Usar Docker Desktop (interfaz gráfica)
# O usar línea de comandos:

docker stats

# Ver recursos de contenedores específicos
docker stats ms-clientes ms-tickets notificacion-service zone-core
```

## 🔐 Seguridad (Recomendaciones)

1. **Cambiar contraseñas por defecto:**
   - PostgreSQL: cambiar "123456"
   - RabbitMQ: cambiar credenciales "guest"

2. **Usar variables de entorno:** Nunca commitear `.env` con credenciales

3. **Network aislada:** Docker Compose crea una red privada entre contenedores

4. **Usuarios no-root:** Los Dockerfiles están configurados para ejecutar como usuarios no-root

## 📚 Referencias Útiles

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Hub](https://hub.docker.com/)
- [PostgreSQL in Docker](https://hub.docker.com/_/postgres)
- [RabbitMQ in Docker](https://hub.docker.com/_/rabbitmq)

## 📞 Soporte

Para problemas o preguntas, consulta:
- Logs de Docker: `docker-compose logs`
- Documentación oficial de cada servicio
- Issues en el repositorio del proyecto

---

**Última actualización:** Febrero 2026
**Versión de Docker Compose:** 3.9
**Versión de imágenes:** 1.0.0

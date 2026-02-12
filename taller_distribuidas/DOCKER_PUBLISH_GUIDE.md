# 📦 Instrucciones de Construcción y Publicación Docker

## 🚀 Inicio Rápido

```bash
# 1. Construir todas las imágenes
docker-compose build

# 2. Ejecutar todos los servicios
docker-compose up -d

# 3. Verificar estado
docker-compose ps
```

## 📋 Servicios Docker

### Imagen 1: MS-CLIENTES (Java/Spring Boot)
**Dockerfile:** `ms-clientes/Dockerfile`
```bash
docker build -t tu_usuario/ms-clientes:1.0.0 ./ms-clientes
docker push tu_usuario/ms-clientes:1.0.0
```

**Puertos:** 8081 (API)
**Base de datos:** PostgreSQL 5435
**URL:** http://localhost:8081/api

---

### Imagen 2: MS-TICKETS (Node.js + GraphQL)
**Dockerfile:** `ms-tickets/Dockerfile`
```bash
docker build -t tu_usuario/ms-tickets:1.0.0 ./ms-tickets
docker push tu_usuario/ms-tickets:1.0.0
```

**Puertos:** 4000 (GraphQL)
**Base de datos:** PostgreSQL 5436
**GraphQL Playground:** http://localhost:4000/graphql

---

### Imagen 3: NOTIFICACION-SERVICE (NestJS)
**Dockerfile:** `notificacion-service/Dockerfile`
```bash
docker build -t tu_usuario/notificacion-service:1.0.0 ./notificacion-service
docker push tu_usuario/notificacion-service:1.0.0
```

**Puertos:** 3000 (API)
**Base de datos:** PostgreSQL 5437
**Mensajería:** RabbitMQ 5672
**URL:** http://localhost:3000

---

### Imagen 4: ZONE-CORE (Java/Spring Boot)
**Dockerfile:** `zone_core/Dockerfile`
```bash
docker build -t tu_usuario/zone-core:1.0.0 ./zone_core
docker push tu_usuario/zone-core:1.0.0
```

**Puertos:** 8080 (API)
**Base de datos:** PostgreSQL 5435 (compartida)
**URL:** http://localhost:8080/api

---

##  🔐 Autenticación Docker Hub

```bash
# Login
docker login -u tu_usuario_docker

# Verificar login
docker whoami
```

---

## 📤 Publicar en Docker Hub

### Opción 1: Construir y Publicar Individual

```bash
# MS-CLIENTES
docker build -t tu_usuario/ms-clientes:1.0.0 -t tu_usuario/ms-clientes:latest ./ms-clientes
docker push tu_usuario/ms-clientes:1.0.0
docker push tu_usuario/ms-clientes:latest

# MS-TICKETS
docker build -t tu_usuario/ms-tickets:1.0.0 -t tu_usuario/ms-tickets:latest ./ms-tickets
docker push tu_usuario/ms-tickets:1.0.0
docker push tu_usuario/ms-tickets:latest

# NOTIFICACION-SERVICE
docker build -t tu_usuario/notificacion-service:1.0.0 -t tu_usuario/notificacion-service:latest ./notificacion-service
docker push tu_usuario/notificacion-service:1.0.0
docker push tu_usuario/notificacion-service:latest

# ZONE-CORE
docker build -t tu_usuario/zone-core:1.0.0 -t tu_usuario/zone-core:latest ./zone_core
docker push tu_usuario/zone-core:1.0.0
docker push tu_usuario/zone-core:latest
```

### Opción 2: Usar Docker Compose para Construir

```bash
# En la raíz del proyecto
docker-compose build --no-cache
```

---

## 🧪 Probar Localmente

```bash
# Levantar todos los servicios
docker-compose up -d

# Ver logs
docker-compose logs -f

# Parar servicios
docker-compose down

# Parar y eliminar volúmenes
docker-compose down -v
```

---

## 📊 Información de Contenedores

```bash
# Ver imágenes construidas
docker images | grep tu_usuario

# Ver contenedores corriendo
docker ps

# Ver logs de un servicio
docker logs nombre_contenedor

# Ejecutar comando en contenedor
docker exec -it nombre_contenedor /bin/bash
```

---

## 🌐 Verificar Servicios

```bash
# MS-CLIENTES
curl http://localhost:8081/api/personas

# MS-TICKETS
curl -X POST http://localhost:4000/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ getAllTickets { id title } }"}'

# NOTIFICACION-SERVICE  
curl http://localhost:3000/api/notifications

# ZONE-CORE
curl http://localhost:8080/api/zones
```

---

## 📝 Información para tu Ingeniero

**Repositorio Docker Hub:** 
```
docker.io/tu_usuario/ms-clientes
docker.io/tu_usuario/ms-tickets
docker.io/tu_usuario/notificacion-service
docker.io/tu_usuario/zone-core
```

**Ejemplo de descarga y ejecución:**
```bash
docker pull tu_usuario/ms-clientes:1.0.0
docker run -p 8081:8081 tu_usuario/ms-clientes:1.0.0
```

**Variables de entorno necesarias:**
- `DB_HOST`, `DB_PORT`, `DB_USERNAME`, `DB_PASSWORD`
- `NODE_ENV` para Node.js
- `SPRING_PROFILES_ACTIVE` para Java

---

## ⚠️ Notas Importantes

1. **Cambiar credenciales por defecto** antes de producción
2. **Usar secretos de Docker** para credenciales sensibles
3. **Revisar logs** de cada servicio para errores
4. **Verificar connectivity** entre servicios
5. **Documentar variables de entorno** en producción

---

**Última actualización:** Febrero 2026

# Etapa 1: Build
FROM node:20-alpine AS build

WORKDIR /app

# Copiar archivos de dependencias
COPY package*.json ./
COPY tsconfig.build.json ./
COPY tsconfig.json ./
COPY nest-cli.json ./

# Instalar dependencias
RUN npm ci

# Copiar código fuente
COPY src ./src

# Compilar la aplicación
RUN npm run build

# Etapa 2: Runtime
FROM node:20-alpine

WORKDIR /app

# Instalar dumb-init
RUN apk add --no-cache dumb-init

# Copiar package.json
COPY package*.json ./

# Instalar solo dependencias de producción
RUN npm ci --only=production

# Copiar archivos compilados desde el build
COPY --from=build /app/dist ./dist

# Crear usuario no-root
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nestjs -u 1001

USER nestjs

# Exponer puerto
EXPOSE 3000

# Entrypoint
ENTRYPOINT ["dumb-init", "--"]

# Comando para iniciar
CMD ["node", "dist/main.js"]

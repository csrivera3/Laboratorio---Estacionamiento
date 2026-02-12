# Etapa 1: Compilación
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copiar archivos de configuración de Maven
COPY pom.xml .

# Descargar dependencias (se cachea esta capa)
RUN mvn dependency:go-offline -B || true

# Copiar código fuente
COPY src ./src

# Compilar la aplicación
RUN mvn clean package -DskipTests

# Etapa 2: Imagen final
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Instalar dumb-init
RUN apk add --no-cache dumb-init

# Crear usuario no-root
RUN addgroup -g 1001 -S java && \
    adduser -S spring -u 1001

# Copiar el JAR compilado desde la etapa de build
COPY --from=build /app/target/*.jar app.jar

# Cambiar propietario
RUN chown -R spring:java /app

USER spring

# Exponer el puerto de la aplicación
EXPOSE 8080

# Entrypoint
ENTRYPOINT ["dumb-init", "--"]

# Comando para ejecutar
CMD ["java", "-jar", "app.jar"]

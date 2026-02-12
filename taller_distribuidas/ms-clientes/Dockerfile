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

# Copiar el JAR compilado desde la etapa de build
COPY --from=build /app/target/*.jar app.jar

# Exponer el puerto de la aplicación
EXPOSE 8081

# Comando para ejecutar
CMD ["java", "-jar", "app.jar"]
# Variables de entorno por defecto (se pueden sobrescribir en docker-compose)
ENV SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/db_parkin_users
ENV SPRING_DATASOURCE_USERNAME=postgres
ENV SPRING_DATASOURCE_PASSWORD=1234

# Ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]

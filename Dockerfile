
# ---- Build Stage ----
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /build
COPY myapp /build/myapp
RUN mvn -f myapp/pom.xml clean package

# ---- Runtime Stage ----
FROM eclipse-temurin:17-jre
# Create a non-root user and group
RUN groupadd -r appgroup && useradd -r -g appgroup appuser
WORKDIR /app
COPY --from=build /build/myapp/target/*.jar /app/app.jar
RUN chown appuser:appgroup /app/app.jar
USER appuser
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

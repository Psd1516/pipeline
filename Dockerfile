# First stage: Build the application using Maven and OpenJDK 21
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy the pom.xml and download dependencies (to cache Maven dependencies)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the entire source code and build the application
COPY src ./src
RUN mvn package -DskipTests

# Second stage: Create a lightweight image to run the Spring Boot app
FROM openjdk:21-jdk
WORKDIR /app

# Copy the JAR file from the first stage
COPY --from=build /app/target/pipeline-0.0.1-SNAPSHOT.jar /app/app.jar

# Expose the port that your Spring Boot app listens on
EXPOSE 8080

# Command to run the Spring Boot application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

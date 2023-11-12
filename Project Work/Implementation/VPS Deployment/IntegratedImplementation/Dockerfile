# run in terminal: docker compose up --build
# add -d if u want to continue using your terminal
# Use Ubuntu 22.04 as the base image for the Spring Boot application
FROM ubuntu:22.04

# Install OpenJDK 17
RUN apt-get update -y 
RUN apt-get install -y openjdk-17-jdk
RUN apt-get clean

# Copy the source code of your Spring Boot application into the container
COPY . /app

# Set the working directory in the container
WORKDIR /app

# Build the Spring Boot application using Gradle
# gradle build always throws error when it reaches the test.
# just manually build before compose
# RUN ./gradlew build

# Expose the port on which your Spring Boot app will run
EXPOSE 8080

# Command to run the Spring Boot application
CMD ["java", "-jar", "build/libs/dbconnect-0.0.1-SNAPSHOT.jar"]
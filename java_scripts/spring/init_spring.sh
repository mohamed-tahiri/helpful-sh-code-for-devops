#!/bin/bash

set -e

# Parameters
SPRING_BOOT_VERSION="3.3.6"
GROUP_ID="com.example"
ARTIFACT_ID="spring-boot-app"
PROJECT_NAME="spring-boot-app"
PACKAGE_NAME="com.example.springbootapp"
DEPENDENCIES="web,data-jpa,postgresql"
SPRING_DIR="/var/www/html/spring"

# Ensure project directory exists
echo "📂 Creating project directory: $SPRING_DIR..."
sudo mkdir -p "$SPRING_DIR"

# Generate Spring Boot project
SPRING_URL="https://start.spring.io/starter.zip?type=maven-project&language=java&bootVersion=$SPRING_BOOT_VERSION&groupId=$GROUP_ID&artifactId=$ARTIFACT_ID&name=$PROJECT_NAME&description=Demo%20Spring%20Boot%20Application&packageName=$PACKAGE_NAME&dependencies=$DEPENDENCIES"

echo "⚙️ Generating Spring Boot project..."
sudo curl -sL "$SPRING_URL" -o "$SPRING_DIR/$PROJECT_NAME.zip"

# Unzip the project
echo "📦 Unzipping project files..."
sudo unzip -o "$SPRING_DIR/$PROJECT_NAME.zip" -d "$SPRING_DIR"

echo "✅ Spring Boot project initialized successfully!"

#!/bin/bash

set -e

# Parameters
SPRING_BOOT_VERSION="3.3.6"
GROUP_ID="com.example"
ARTIFACT_ID="spring-boot-app"
PROJECT_NAME="spring-boot-app"
PACKAGE_NAME="com.example.springbootapp"
DEPENDENCIES="web"
SPRING_DIR="/var/www/html/spring"
NGINX_CONF="/etc/nginx/sites-available/$PROJECT_NAME"
NGINX_LINK="/etc/nginx/sites-enabled/$PROJECT_NAME"

# Functions
check_command() {
    command -v "$1" >/dev/null 2>&1 || { echo "❌ Command $1 not found! Please install it."; exit 1; }
}

# Ensure required commands are available
check_command curl
check_command unzip
check_command java
check_command mvn

# Ensure project directory exists
echo "📂 Creating project directory: $SPRING_DIR..."
sudo mkdir -p "$SPRING_DIR"
sudo chown -R $USER:$USER "$SPRING_DIR"

# Generate Spring Boot project
SPRING_URL="https://start.spring.io/starter.zip?type=maven-project&language=java&bootVersion=$SPRING_BOOT_VERSION&groupId=$GROUP_ID&artifactId=$ARTIFACT_ID&name=$PROJECT_NAME&description=Demo%20Spring%20Boot%20Application&packageName=$PACKAGE_NAME&dependencies=$DEPENDENCIES"

echo "⚙️ Generating Spring Boot project..."
curl -sL "$SPRING_URL" -o "$SPRING_DIR/$PROJECT_NAME.zip"

# Unzip the project
echo "📦 Unzipping project files..."
unzip -o "$SPRING_DIR/$PROJECT_NAME.zip" -d "$SPRING_DIR"

# Build the project
echo "🔨 Building the Spring Boot application..."
cd "$SPRING_DIR" || exit
./mvnw clean package -DskipTests

# Ensure JAR file is available
JAR_FILE=$(find target -name "$ARTIFACT_ID*.jar" | head -n 1)
if [ ! -f "$JAR_FILE" ]; then
    echo "❌ Build failed. JAR file not found!"
    exit 1
fi
echo "✅ Build successful: $JAR_FILE"

# Create a systemd service file for Spring Boot
SERVICE_FILE="/etc/systemd/system/$PROJECT_NAME.service"
echo "📝 Creating systemd service file: $SERVICE_FILE..."
sudo bash -c "cat > $SERVICE_FILE <<EOF
[Unit]
Description=Spring Boot Application - $PROJECT_NAME
After=network.target

[Service]
User=$USER
WorkingDirectory=$SPRING_DIR
ExecStart=/usr/bin/java -jar $SPRING_DIR/$JAR_FILE
SuccessExitStatus=143
Restart=always

[Install]
WantedBy=multi-user.target
EOF"

# Reload systemd and start the service
echo "🔄 Reloading systemd and starting the Spring Boot application..."
sudo systemctl daemon-reload
sudo systemctl enable "$PROJECT_NAME"
sudo systemctl start "$PROJECT_NAME"

# Configure Nginx
echo "🛠️ Configuring Nginx..."


# Success message
echo "✅ Spring Boot application is running and accessible through Nginx!"

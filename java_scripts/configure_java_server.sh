#!/bin/bash

set -e  # Exit immediately on error

# Check Java version argument
if [ -z "$1" ]; then
    echo "❌ Error: No Java version specified!"
    echo "Usage: $0 <java_version> (e.g., 11, 17, 20)"
    exit 1
fi

JAVA_VERSION=$1

echo "🔧 Configuring server with Java $JAVA_VERSION..."

# Update system packages
echo "⏳ Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
echo "📦 Installing essentials..."
sudo apt install -y software-properties-common curl wget unzip git

# Install Java
echo "☕ Installing OpenJDK $JAVA_VERSION..."
sudo apt install -y openjdk-$JAVA_VERSION-jdk

# Verify Java installation
echo "🔍 Verifying Java installation..."
if java -version 2>&1 | grep -q "openjdk version \"$JAVA_VERSION"; then
    echo "✅ OpenJDK $JAVA_VERSION installed successfully."
else
    echo "❌ Failed to install OpenJDK $JAVA_VERSION. Please check manually."
    exit 1
fi

# Install Maven
echo "📦 Installing Maven..."
sudo apt install -y maven
mvn -v

# Install Gradle (optional)
echo "📦 Installing Gradle..."
sudo apt install -y gradle
gradle -v

# Install Tomcat
echo "🐱 Installing Tomcat server..."
TOMCAT_VERSION="10.1.13"
TOMCAT_DIR="/opt/tomcat"
wget https://downloads.apache.org/tomcat/tomcat-10/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz -P /tmp
sudo mkdir -p $TOMCAT_DIR
sudo tar -xvzf /tmp/apache-tomcat-$TOMCAT_VERSION.tar.gz -C $TOMCAT_DIR --strip-components=1
sudo rm /tmp/apache-tomcat-$TOMCAT_VERSION.tar.gz

# Set permissions for Tomcat
echo "🔑 Setting permissions for Tomcat..."
sudo chmod +x $TOMCAT_DIR/bin/*.sh
sudo chown -R www-data:www-data $TOMCAT_DIR

# Create systemd service for Tomcat
echo "⚙️ Configuring Tomcat as a service..."
cat <<EOL | sudo tee /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking
User=www-data
Group=www-data
Environment="JAVA_HOME=/usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64"
Environment="CATALINA_HOME=$TOMCAT_DIR"
ExecStart=$TOMCAT_DIR/bin/startup.sh
ExecStop=$TOMCAT_DIR/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat

# Confirm Tomcat installation
echo "🌐 Checking Tomcat status..."
if sudo systemctl status tomcat | grep -q "active (running)"; then
    echo "✅ Tomcat is running. Access it at http://<server-ip>:8080"
else
    echo "❌ Tomcat failed to start. Please check the logs."
    exit 1
fi

# Optional: Install Node.js (if needed for modern Java projects)
echo "🌐 Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

echo "🎉 Configuration completed! Java $JAVA_VERSION, Maven, Gradle, and Tomcat are ready to use."


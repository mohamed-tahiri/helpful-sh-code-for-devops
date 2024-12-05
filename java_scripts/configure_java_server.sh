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

# Install and Configure Nginx
echo "🌐 Installing and configuring Nginx..."
sudo apt install -y nginx

# Create a basic Nginx configuration file
cat <<EOL | sudo tee /etc/nginx/sites-available/java_server
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:8080;  # Forward requests to Java app running on port 8080
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    error_page 404 /404.html;
    location = /404.html {
        root /usr/share/nginx/html;
    }
}
EOL

# Enable the Nginx configuration
sudo ln -s /etc/nginx/sites-available/java_server /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Test and restart Nginx
echo "🔧 Testing Nginx configuration..."
sudo nginx -t

echo "🔄 Restarting Nginx..."
sudo systemctl restart nginx
sudo systemctl enable nginx

# Optional: Install Node.js (if needed for modern Java projects)
echo "🌐 Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

echo "🎉 Configuration completed! Java $JAVA_VERSION, Maven, Gradle, and Nginx are ready to use."

#!/bin/bash

set -e  # Exit immediately on error

# Check Node.js version argument
if [ -z "$1" ]; then
    echo "❌ Error: No Node.js version specified!"
    echo "Usage: $0 <node_version>"
    exit 1
fi

NODE_VERSION=$1

echo "🔧 Configuring server with Node.js $NODE_VERSION..."

# Update packages
echo "⏳ Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
echo "📦 Installing essentials..."
sudo apt install -y curl wget git build-essential

# Install Node.js and npm
echo "🌐 Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x | sudo -E bash -
sudo apt install -y nodejs

# Verify Node.js and npm installation
echo "✅ Verifying Node.js and npm installation..."
if node -v | grep -q "v$NODE_VERSION"; then
    echo "✅ Node.js $NODE_VERSION installed successfully."
else
    echo "❌ Failed to install Node.js $NODE_VERSION. Please check manually."
    exit 1
fi

# Install Yarn
echo "🎩 Installing Yarn..."
sudo npm install -g yarn

# Install PM2
echo "⚙️ Installing PM2 for process management..."
sudo npm install -g pm2

# Set up basic project directory
echo "🛠 Setting up basic project structure..."
PROJECT_DIR="/var/www/javascript_app"
sudo mkdir -p $PROJECT_DIR
sudo chown -R $USER:$USER $PROJECT_DIR
cd $PROJECT_DIR
echo "console.log('Hello, JavaScript!');" > app.js

# Set permissions
echo "🛠 Setting permissions for $PROJECT_DIR..."
sudo chown -R www-data:www-data $PROJECT_DIR
sudo chmod -R 755 $PROJECT_DIR

# Start application with PM2
echo "🚀 Starting application with PM2..."
pm2 start app.js --name "javascript-app"
pm2 save
pm2 startup

# Optional: Install ESLint
echo "📏 Installing ESLint for code linting..."
sudo npm install -g eslint

echo "🎉 JavaScript server setup completed! Your application is running with PM2."


#!/bin/bash

# Script to verify server setup for a PHP environment

set -e  # Stop on any error

echo "🔍 Starting server verification process..."

# Function to check service status
check_service() {
    SERVICE=$1
    echo -n "🛠 Checking $SERVICE status... "
    if systemctl is-active --quiet "$SERVICE"; then
        echo "✅ Running"
    else
        echo "❌ Not running"
        echo "Attempting to start $SERVICE..."
        sudo systemctl start "$SERVICE"
        if systemctl is-active --quiet "$SERVICE"; then
            echo "✅ $SERVICE started successfully"
        else
            echo "❌ Failed to start $SERVICE. Please check manually."
            exit 1
        fi
    fi
}

# Function to check if a command exists
check_command() {
    COMMAND=$1
    echo -n "🔧 Checking $COMMAND... "
    if command -v "$COMMAND" > /dev/null 2>&1; then
        echo "✅ Found"
    else
        echo "❌ Not found"
        echo "Please install $COMMAND."
        exit 1
    fi
}

# Check Nginx service
check_service "nginx"

# Check MariaDB service
check_service "mariadb"

# Check PHP version
PHP_VERSION="8.2"
echo -n "🐘 Checking PHP version... "
if php -v | grep -q "$PHP_VERSION"; then
    echo "✅ PHP $PHP_VERSION installed"
else
    echo "❌ PHP $PHP_VERSION not found. Please check your installation."
    exit 1
fi

# Check Composer
check_command "composer"

# Check Node.js version
NODE_MIN_VERSION="20"
echo -n "🌐 Checking Node.js version... "
NODE_VERSION=$(node -v | grep -oP '\d+')
if [ "$NODE_VERSION" -ge "$NODE_MIN_VERSION" ]; then
    echo "✅ Node.js version $NODE_VERSION"
else
    echo "❌ Node.js version $NODE_VERSION is below the minimum required ($NODE_MIN_VERSION)."
    exit 1
fi

# Check permissions for /var/www/html
echo -n "🛠 Checking permissions for /var/www/html... "
if [ "$(stat -c "%U:%G" /var/www/html)" = "www-data:www-data" ]; then
    echo "✅ Correct"
else
    echo "❌ Incorrect. Fixing permissions..."
    sudo chown -R www-data:www-data /var/www/html
    sudo chmod -R 755 /var/www/html
    echo "✅ Permissions fixed"
fi

# Verify Nginx configuration
echo -n "🔧 Testing Nginx configuration... "
if sudo nginx -t > /dev/null 2>&1; then
    echo "✅ Configuration is valid"
else
    echo "❌ Invalid Nginx configuration. Please check logs."
    exit 1
fi

# Verify MariaDB connection
echo "🔒 Testing MariaDB connection..."
if mysqladmin ping -u root -proot > /dev/null 2>&1; then
    echo "✅ MariaDB connection successful"
else
    echo "❌ MariaDB connection failed. Please check your credentials."
    exit 1
fi

# Summary
echo "🎉 Server verification completed successfully!"


#!/bin/bash

# Script to configure a server for a PHP environment with specified PHP version
# Supports: WordPress, Drupal, PrestaShop, Sylius

set -e  # Exit immediately if a command exits with a non-zero status

# Check if a PHP version argument is passed
if [ -z "$1" ]; then
    echo "❌ Error: No PHP version specified!"
    echo "Usage: $0 <php_version>"
    echo "Example: $0 8.2"
    exit 1
fi

PHP_VERSION=$1

echo "🔧 Starting server configuration for PHP environment with PHP $PHP_VERSION..."

# Update and upgrade system packages
echo "⏳ Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
echo "📦 Installing essential packages..."
sudo apt install -y software-properties-common curl wget unzip git

# Add PHP PPA and install PHP
echo "🐘 Adding PHP repository and installing PHP $PHP_VERSION..."
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update
sudo apt install -y php$PHP_VERSION php$PHP_VERSION-cli php$PHP_VERSION-fpm \
  php$PHP_VERSION-mysql php$PHP_VERSION-xml php$PHP_VERSION-mbstring \
  php$PHP_VERSION-curl php$PHP_VERSION-zip php$PHP_VERSION-gd php$PHP_VERSION-intl

# Install database server (MySQL or MariaDB)
echo "📂 Installing MariaDB server..."
sudo apt install -y mariadb-server mariadb-client
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure MariaDB installation
echo "🔒 Securing MariaDB..."
sudo mysql_secure_installation <<EOF

y
root
root
y
y
y
y
EOF

# Install and configure Nginx
echo "🚀 Installing and configuring Nginx..."
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Create a sample Nginx configuration for PHP applications
echo "🔧 Configuring Nginx for PHP $PHP_VERSION..."
cat <<EOL | sudo tee /etc/nginx/sites-available/php_app
server {
    listen 80;
    server_name localhost;

    root /var/www/html;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php$PHP_VERSION-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOL

# Enable the new Nginx configuration
sudo ln -s /etc/nginx/sites-available/php_app /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# Permissions for the web directory
echo "🛠 Setting permissions for /var/www/html..."
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# Optional: Install Composer
echo "🎼 Installing Composer (PHP package manager)..."
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Optional: Install Node.js and npm (useful for themes and frontend builds)
echo "🌐 Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -y nodejs

echo "🎉 Server configuration completed! Ready for WordPress, Drupal, PrestaShop, or Sylius."

# End of script


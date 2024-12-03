#!/bin/bash

set -e  # Exit immediately on error

# Check PHP version
if [ -z "$1" ]; then
    echo "❌ Error: No PHP version specified!"
    echo "Usage: $0 <php_version>"
    exit 1
fi

PHP_VERSION=$1

echo "🔧 Updating server to use PHP $PHP_VERSION..."

# Update packages
echo "⏳ Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
echo "📦 Installing essentials..."
sudo apt install -y software-properties-common curl wget unzip git

# Add PHP PPA and install PHP version
echo "🐘 Installing PHP $PHP_VERSION..."
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update
sudo apt install -y php$PHP_VERSION php$PHP_VERSION-fpm \
  php$PHP_VERSION-mysql php$PHP_VERSION-xml php$PHP_VERSION-mbstring \
  php$PHP_VERSION-curl php$PHP_VERSION-zip php$PHP_VERSION-gd php$PHP_VERSION-intl

# Set PHP version as default
echo "🔄 Setting PHP $PHP_VERSION as the default version..."
sudo update-alternatives --set php /usr/bin/php$PHP_VERSION
sudo systemctl restart php$PHP_VERSION-fpm

# Install MariaDB
echo "📂 Installing MariaDB..."
sudo apt install -y mariadb-server mariadb-client
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure MariaDB
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

# Install phpMyAdmin
echo "📦 Installing phpMyAdmin..."
sudo apt install -y phpmyadmin

# Ensure web root exists and link phpMyAdmin
echo "🔗 Configuring phpMyAdmin with Nginx..."
sudo mkdir -p /var/www/html
sudo ln -sf /usr/share/phpmyadmin /var/www/html/phpmyadmin
sudo chown -R www-data:www-data /usr/share/phpmyadmin
sudo chmod -R 755 /usr/share/phpmyadmin

# Install and configure Nginx
echo "🚀 Configuring Nginx..."
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Create Nginx configuration
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

# Enable Nginx configuration
sudo ln -sf /etc/nginx/sites-available/php_app /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# Set web directory permissions
echo "🛠 Setting permissions for /var/www/html..."
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# Optional: Install Composer
echo "🎼 Installing Composer..."
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Optional: Install Node.js and npm
echo "🌐 Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

echo "🎉 PHP $PHP_VERSION setup completed! Access phpMyAdmin at http://<server-ip>/phpmyadmin"

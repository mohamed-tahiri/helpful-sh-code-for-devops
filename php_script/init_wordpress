#!/bin/bash

set -e

echo "🌟 Initialisation de WordPress..."

# Variables
DB_NAME="wordpress"
DB_USER="wp_user"
DB_PASSWORD="wp_pass"
WP_DIR="/var/www/html/wordpress"

# Vérifier si WordPress est déjà installé
if [ -d "$WP_DIR" ]; then
    echo "⚠️ WordPress semble déjà installé dans $WP_DIR. Aucune action nécessaire."
    exit 0
fi

# Vérifier si la base de données existe déjà
DB_EXISTS=$(sudo mysql -u root -proot -e "SHOW DATABASES LIKE '$DB_NAME';")
if [ -z "$DB_EXISTS" ]; then
    echo "📂 Création de la base de données pour WordPress..."
    sudo mysql -u root -proot -e "CREATE DATABASE $DB_NAME;"
else
    echo "⚠️ La base de données $DB_NAME existe déjà. Passage à l'étape suivante..."
fi

# Vérifier si l'utilisateur existe déjà
USER_EXISTS=$(sudo mysql -u root -proot -e "SELECT User FROM mysql.user WHERE User = '$DB_USER';")
if [ -z "$USER_EXISTS" ]; then
    echo "🧑‍💻 Création de l'utilisateur WordPress..."
    sudo mysql -u root -proot -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
    sudo mysql -u root -proot -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
    sudo mysql -u root -proot -e "FLUSH PRIVILEGES;"
else
    echo "⚠️ L'utilisateur $DB_USER existe déjà. Passage à l'étape suivante..."
fi

# Télécharger et configurer WordPress
echo "⬇️ Téléchargement de WordPress..."
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz

# Déplacer WordPress dans le bon répertoire et ajuster les permissions
echo "🚚 Déplacement de WordPress dans $WP_DIR..."
sudo mv wordpress $WP_DIR

# Réglage des permissions
echo "🔧 Réglage des permissions pour le répertoire WordPress..."
sudo chown -R www-data:www-data $WP_DIR
sudo chmod -R 755 $WP_DIR

# Configurer wp-config.php
echo "🛠 Configuration de WordPress..."
cp $WP_DIR/wp-config-sample.php $WP_DIR/wp-config.php
sed -i "s/database_name_here/$DB_NAME/" $WP_DIR/wp-config.php
sed -i "s/username_here/$DB_USER/" $WP_DIR/wp-config.php
sed -i "s/password_here/$DB_PASSWORD/" $WP_DIR/wp-config.php

# Redémarrer les services
echo "🔄 Redémarrage de Nginx et PHP-FPM..."
sudo systemctl restart nginx
sudo systemctl restart php8.1-fpm

# Test d'accès
echo "🌐 Test de connectivité à WordPress via HTTP..."
curl -I http://localhost | grep "HTTP"

# Instructions pare-feu
echo "🔓 Autorisation du trafic HTTP dans le pare-feu..."
sudo ufw allow 80
sudo ufw reload

echo "🎉 WordPress est prêt ! Accédez à votre site pour terminer l'installation."


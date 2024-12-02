#!/bin/bash

set -e

echo "🌟 Initialisation de Drupal..."

# Variables
DB_NAME="drupal"
DB_USER="drupal_user"
DB_PASSWORD="drupal_pass"
DRUPAL_DIR="/var/www/html/drupal"
DRUPAL_VERSION="10.1.3"
ADMIN_USER="admin"
ADMIN_PASS="admin123"
ADMIN_EMAIL="admin@example.com"
SITE_NAME="MonSiteDrupal"
SITE_URL="localhost"

# Vérifier si Drupal est déjà installé
if [ -d "$DRUPAL_DIR" ]; then
    echo "⚠️ Drupal semble déjà installé dans $DRUPAL_DIR. Aucune action nécessaire."
    exit 0
fi

# Vérifier si la base de données existe déjà
DB_EXISTS=$(sudo mysql -u root -proot -e "SHOW DATABASES LIKE '$DB_NAME';")
if [ -z "$DB_EXISTS" ]; then
    echo "📂 Création de la base de données pour Drupal..."
    sudo mysql -u root -proot -e "CREATE DATABASE $DB_NAME;"
else
    echo "⚠️ La base de données $DB_NAME existe déjà. Passage à l'étape suivante..."
fi

# Vérifier si l'utilisateur existe déjà
USER_EXISTS=$(sudo mysql -u root -proot -e "SELECT User FROM mysql.user WHERE User = '$DB_USER';")
if [ -z "$USER_EXISTS" ]; then
    echo "🧑‍💻 Création de l'utilisateur Drupal..."
    sudo mysql -u root -proot -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
    sudo mysql -u root -proot -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
    sudo mysql -u root -proot -e "FLUSH PRIVILEGES;"
else
    echo "⚠️ L'utilisateur $DB_USER existe déjà. Passage à l'étape suivante..."
fi

# Télécharger et configurer Drupal
echo "⬇️ Téléchargement de Drupal..."
sudo wget https://ftp.drupal.org/files/projects/drupal-$DRUPAL_VERSION.tar.gz -O drupal.tar.gz
sudo tar -xzf drupal.tar.gz
sudo mv drupal-$DRUPAL_VERSION $DRUPAL_DIR
sudo rm -rf drupal.tar.gz

# Installer Composer si nécessaire
if ! command -v composer &> /dev/null; then
    echo "⬇️ Installation de Composer..."
    sudo curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
fi

# Réglage des permissions
echo "🔧 Réglage des permissions pour le répertoire Drupal..."
sudo chown -R www-data:www-data $DRUPAL_DIR
sudo chmod -R 755 $DRUPAL_DIR
sudo chmod -R 775 $DRUPAL_DIR/sites/default/

# Redémarrer les services
echo "🔄 Redémarrage de Nginx et PHP-FPM..."
sudo systemctl restart nginx
sudo systemctl restart php8.1-fpm

# Instructions pare-feu
echo "🔓 Autorisation du trafic HTTP dans le pare-feu..."
sudo ufw allow 80
sudo ufw reload

echo "🎉 Drupal est prêt ! Accédez à http://$SITE_URL pour configurer votre site."

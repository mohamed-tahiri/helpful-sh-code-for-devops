#!/bin/bash

set -e

echo "🌟 Initialisation de Drupal..."

# Variables
DB_NAME="drupal"
DB_USER="drupal_user"
DB_PASSWORD="drupal_pass"
DRUPAL_DIR="/var/www/html/drupal"

# Créer la base de données et l'utilisateur
echo "📂 Création de la base de données pour Drupal..."
sudo mysql -uroot -proot -e "CREATE DATABASE $DB_NAME;"
sudo mysql -uroot -proot -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
sudo mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
sudo mysql -uroot -proot -e "FLUSH PRIVILEGES;"

# Télécharger et configurer Drupal
echo "⬇️ Téléchargement de Drupal..."
wget https://www.drupal.org/download-latest/tar.gz -O drupal.tar.gz
tar -xzf drupal.tar.gz
sudo mv drupal-* $DRUPAL_DIR
sudo chown -R www-data:www-data $DRUPAL_DIR
sudo chmod -R 755 $DRUPAL_DIR

echo "🎉 Drupal est prêt ! Accédez à /core/install.php pour terminer l'installation."


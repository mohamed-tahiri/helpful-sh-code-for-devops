#!/bin/bash

set -e

echo "🌟 Initialisation d'un projet Symfony..."

# Variables
DB_NAME="symfony_db"
DB_USER="symfony_user"
DB_PASSWORD="symfony_pass"
SYMFONY_DIR="/var/www/html/symfony"

# Vérifier si le projet Symfony est déjà installé
if [ -d "$SYMFONY_DIR" ]; then
    echo "⚠️ Le projet Symfony semble déjà être installé dans $SYMFONY_DIR. Aucune action nécessaire."
    exit 0
fi

# Vérifier si la base de données existe déjà
DB_EXISTS=$(sudo mysql -u root -proot -e "SHOW DATABASES LIKE '$DB_NAME';")
if [ -z "$DB_EXISTS" ]; then
    echo "📂 Création de la base de données pour Symfony..."
    sudo mysql -u root -proot -e "CREATE DATABASE $DB_NAME;"
else
    echo "⚠️ La base de données $DB_NAME existe déjà. Passage à l'étape suivante..."
fi

# Vérifier si l'utilisateur existe déjà
USER_EXISTS=$(sudo mysql -u root -proot -e "SELECT User FROM mysql.user WHERE User = '$DB_USER';")
if [ -z "$USER_EXISTS" ]; then
    echo "🧑‍💻 Création de l'utilisateur Symfony..."
    sudo mysql -u root -proot -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
    sudo mysql -u root -proot -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
    sudo mysql -u root -proot -e "FLUSH PRIVILEGES;"
else
    echo "⚠️ L'utilisateur $DB_USER existe déjà. Passage à l'étape suivante..."
fi

# Vérification de Symfony CLI
echo "⚙️ Vérification de Symfony CLI..."
if ! command -v symfony &> /dev/null; then
  echo "⬇️ Installation de Symfony CLI..."
  wget https://get.symfony.com/cli/installer -O - | bash
  sudo mv ~/.symfony*/bin/symfony /usr/local/bin/symfony
fi

# Créer un projet Symfony avec Composer
echo "🛠  Création d'un nouveau projet Symfony..."
sudo COMPOSER_MEMORY_LIMIT=-1 composer create-project symfony/skeleton $SYMFONY_DIR

cd $SYMFONY_DIR

# Configurer les permissions
sudo chown -R www-data:www-data $SYMFONY_DIR
sudo chmod -R 755 $SYMFONY_DIR

# Configuration de la base de données dans .env
echo "🛠  Configuration de la connexion à la base de données dans .env..."
sudo sed -i "s/DATABASE_URL=\".*/DATABASE_URL=\"mysql:\/\/$DB_USER:$DB_PASSWORD@localhost:3306\/$DB_NAME?serverVersion=5.7\"/" .env

# Installer les dépendances de Symfony
echo "📦 Installation des dépendances de Symfony..."
sudo composer install

echo "🎉 Symfony est prêt ! Vous pouvez maintenant commencer à développer votre application."

#!/bin/bash

set -e

echo "🌟 Initialisation d'un projet Symfony..."

# Variables
SYMFONY_DIR="/var/www/html/symfony"

# Installer Symfony CLI si nécessaire
echo "⚙️ Vérification de Symfony CLI..."
if ! command -v symfony &> /dev/null; then
  echo "⬇️ Installation de Symfony CLI..."
  wget https://get.symfony.com/cli/installer -O - | bash
  sudo mv ~/.symfony*/bin/symfony /usr/local/bin/symfony
fi

# Créer un projet Symfony
echo "🛠 Création d'un nouveau projet Symfony..."
symfony new $SYMFONY_DIR --webapp
cd $SYMFONY_DIR

# Configurer les permissions
sudo chown -R www-data:www-data $SYMFONY_DIR
sudo chmod -R 755 $SYMFONY_DIR

echo "🎉 Symfony est prêt ! Vous pouvez maintenant commencer à développer."


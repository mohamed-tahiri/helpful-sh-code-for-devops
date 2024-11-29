#!/bin/bash

set -e

echo "🌟 Initialisation de Sylius..."

# Variables
SYLIUS_DIR="/var/www/html/sylius"

# Installer Symfony CLI si nécessaire
echo "⚙️ Vérification de Symfony CLI..."
if ! command -v symfony &> /dev/null; then
  echo "⬇️ Installation de Symfony CLI..."
  wget https://get.symfony.com/cli/installer -O - | bash
  sudo mv ~/.symfony*/bin/symfony /usr/local/bin/symfony
fi

# Créer un projet Sylius
echo "🛠 Création d'un nouveau projet Sylius..."
symfony new $SYLIUS_DIR --full
cd $SYLIUS_DIR

# Installer les dépendances
echo "📦 Installation des dépendances Sylius..."
composer create-project sylius/sylius .

# Configurer les permissions
sudo chown -R www-data:www-data $SYLIUS_DIR
sudo chmod -R 755 $SYLIUS_DIR

echo "🎉 Sylius est prêt ! Accédez à votre projet pour terminer la configuration."


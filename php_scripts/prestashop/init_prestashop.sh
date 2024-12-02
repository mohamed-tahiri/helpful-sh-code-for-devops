#!/bin/bash

set -e

echo "🌟 Initialisation de PrestaShop..."

# Variables
DB_NAME="prestashop"
DB_USER="ps_user"
DB_PASSWORD="ps_pass"
PS_DIR="/var/www/html/prestashop"

# Vérifier si PrestaShop est déjà installé
if [ -d "$PS_DIR" ]; then
    echo "⚠️ PrestaShop semble déjà installé dans $PS_DIR. Aucune action nécessaire."
    exit 0
fi

# Vérifier si la base de données existe déjà
DB_EXISTS=$(sudo mysql -u root -proot -e "SHOW DATABASES LIKE '$DB_NAME';")
if [ -z "$DB_EXISTS" ]; then
    echo "📂 Création de la base de données pour PrestaShop..."
    sudo mysql -u root -proot -e "CREATE DATABASE $DB_NAME;"
else
    echo "⚠️ La base de données $DB_NAME existe déjà. Passage à l'étape suivante..."
fi

# Vérifier si l'utilisateur existe déjà
USER_EXISTS=$(sudo mysql -u root -proot -e "SELECT User FROM mysql.user WHERE User = '$DB_USER';")
if [ -z "$USER_EXISTS" ]; then
    echo "🧑‍💻 Création de l'utilisateur PrestaShop..."
    sudo mysql -u root -proot -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
    sudo mysql -u root -proot -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
    sudo mysql -u root -proot -e "FLUSH PRIVILEGES;"
else
    echo "⚠️ L'utilisateur $DB_USER existe déjà. Passage à l'étape suivante..."
fi

# Télécharger et configurer PrestaShop
echo "⬇️ Téléchargement de PrestaShop..."
wget https://download.prestashop.com/download/releases/prestashop_1.7.6.7.zip -O prestashop.zip
unzip prestashop.zip -d prestashop-tmp

# Déplacer PrestaShop dans le bon répertoire et ajuster les permissions
echo "🚚 Déplacement de PrestaShop dans $PS_DIR..."
sudo mkdir -p $PS_DIR
sudo mv prestashop-tmp/* $PS_DIR
sudo rm -rf prestashop-tmp prestashop.zip

# Décompresser PrestaShop dans le bon répertoire
echo "📂 Décompression de PrestaShop dans $PS_DIR..."
sudo unzip /var/www/html/prestashop/prestashop.zip -d /var/www/html/prestashop/
sudo rm -rf /var/www/html/prestashop/prestashop.zip  # Supprimer le fichier zip une fois décompressé

# Réglage des permissions
echo "🔧 Réglage des permissions pour le répertoire PrestaShop..."
sudo chown -R www-data:www-data $PS_DIR
sudo chmod -R 755 $PS_DIR
sudo chmod -R 775 $PS_DIR/var
sudo rm -rf $PS_DIR/var/cache/*

# Vérifier si le fichier index_cli.php existe avant de le lancer
if [ -f "$PS_DIR/install/index.php" ]; then
    echo "🛠 Configuration automatique de PrestaShop..."
    php $PS_DIR/install/index_cli.php \
        --domain=localhost \
        --db_server=localhost \
        --db_name=$DB_NAME \
        --db_user=$DB_USER \
        --db_password=$DB_PASSWORD \
        --firstname=Admin \
        --lastname=User \
        --email=admin@example.com \
        --password=admin123 \
        --language=fr \
        --country=fr \
        --newsletter=0 \
        --send_email=0
else
    echo "❌ Le fichier index.php est manquant, installation échouée."
    exit 1
fi

# Supprimer le répertoire d'installation pour des raisons de sécurité
echo "🧹 Suppression du répertoire d'installation..."
sudo rm -rf $PS_DIR/install

# Redémarrer les services
echo "🔄 Redémarrage de Nginx et PHP-FPM..."
sudo systemctl restart nginx
sudo systemctl restart php7.4-fpm

# Test d'accès
echo "🌐 Test de connectivité à PrestaShop via HTTP..."
curl -I http://localhost | grep "HTTP"

# Instructions pare-feu
echo "🔓 Autorisation du trafic HTTP dans le pare-feu..."
sudo ufw allow 80
sudo ufw reload

echo "🎉 PrestaShop est prêt ! Accédez à votre site pour finaliser la configuration."

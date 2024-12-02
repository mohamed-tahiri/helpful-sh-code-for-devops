# PHP Script Directory

This directory contains shell scripts related to configuring and managing PHP environments for various platforms like WordPress, Drupal, PrestaShop, and Sylius.

## 📂 Contents

- **configure_php_server.sh**: A script to automate the setup of a PHP-based web server with Nginx, MariaDB, and PHP.

## 🚀 Usage

1. **Make the script executable:**
   ```bash
   chmod +x configure_php_server.sh

2. **Run the script:**
   ```bash
   ./configure_php_server.sh

3. **Follow the on-screen instructions to complete the server setup.**

## 🔧 Features

- Automatic installation of essential packages (Nginx, PHP, MariaDB, Composer, and Node.js).
- Configuration of PHP and Nginx for hosting PHP applications.
- Secure MariaDB setup with optional root password.
- Sample Nginx configuration file tailored for PHP frameworks.

## ⚙️  Requirements

- Operating System: Ubuntu or Debian-based distribution.
- Access: Root or sudo privileges.
- Dependencies: A network connection for downloading required packages.

## 🌐 Supported Platforms

These scripts are optimized for the following platforms:

- **WordPress:** Blogging and CMS platform.
- **Drupal:** CMS for building complex websites.
- **PrestaShop:** E-commerce platform.
- **Sylius:** Headless e-commerce framework.

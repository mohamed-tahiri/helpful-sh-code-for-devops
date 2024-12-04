# JavaScript Script Directory

This directory contains shell scripts to automate the setup and configuration of JavaScript environments for developing and deploying Node.js applications.

## 📂 Contents

- **configure_javascript_server.sh**: A script to set up a JavaScript development and deployment environment with Node.js, npm, Yarn, and PM2.

## 🚀 Usage

1. **Make the script executable:**
   ```bash
   chmod +x configure_javascript_server.sh
2. **Run the script with the desired Node.js version (e.g., 16):**
   ```bash
   ./configure_javascript_server.sh 16
3. **Follow the on-screen instructions to complete the setup.**

## 🔧 Features

1. Installs the specified version of Node.js and npm.
2. Installs Yarn for dependency management.
3. Installs PM2 for managing Node.js application processes.
4. Sets up a basic project structure with a sample app.js file.
5. Configures PM2 to start the application on system boot.

## ⚙️ Requirements

1. ***Operating System:*** Ubuntu or Debian-based distribution.
2. ***Access:*** Root or sudo privileges.
3. ***Network:*** Active internet connection for downloading packages.

## 🌐 Supported Environments

This script is designed for JavaScript developers and supports the following configurations:

1. ***Node.js:*** Versions 14, 16, 18, or newer.
2. ***npm:*** Included with Node.js.
3. ***Yarn:*** For faster and reliable dependency management.
4. ***PM2:*** For managing and monitoring Node.js applications.

## 📝 Notes

1. Ensure the system has enough resources for Node.js applications.
2. You can customize the script to include additional tools like webpack, eslint, or frameworks like Express.



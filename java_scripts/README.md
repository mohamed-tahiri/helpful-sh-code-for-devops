# Java Script Directory

This directory contains shell scripts to automate the setup and configuration of Java environments for developing and deploying Java applications.

## 📂 Contents

- **configure_java_server.sh**: A script to set up a Java development and deployment environment with OpenJDK, Maven, Gradle, and Tomcat.

## 🚀 Usage

1. **Make the script executable:**
   ```bash
   chmod +x configure_java_server.sh

2. **Run the script with the desired Java version (e.g., 17):**
   ```bash
   ./configure_java_server.sh 17

3. **Follow the on-screen instructions to complete the setup.**

## 🔧 Features

1. Installs the specified version of OpenJDK.
2. Configures Apache Tomcat as a service for deploying Java applications.
3. Installs Maven and Gradle for project and dependency management.
4. Optionally installs Node.js for modern Java project requirements.
5. Configures permissions and sets up systemd service for Tomcat.

## ⚙️ Requirements

1. ***Operating System:*** Ubuntu or Debian-based distribution.
2. ***Access:*** Root or sudo privileges.
3. ***Network:*** Active internet connection for downloading packages.

## 🌐 Supported Environments

This script is designed for Java developers and supports the following configurations:

1. ***Java Development Kit (JDK):*** OpenJDK 11, 17, or newer versions.
2. ***Tomcat Server:*** For hosting Java-based web applications.
3. ***Maven/Gradle:*** Tools for managing builds and dependencies.

## 📝 Notes

1. Ensure that the system has enough disk space and memory for Java server applications.
2. You can customize the script to include additional tools or settings specific to your project needs.




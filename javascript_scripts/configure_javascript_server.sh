#!/bin/bash

set -e  # Exit immediately on error

echo "🔧 Configuring JavaScript server environment..."

# Update system packages
echo "⏳ Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
echo "📦 Installing essentials..."
sudo apt install -y software-properties-common curl wget git build-essential libssl-dev

# Install NVM (Node Version Manager)
echo "🌐 Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.6/install.sh | bash

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install LTS Node.js version
echo "🌐 Installing Node.js using NVM..."
nvm install --lts
nvm use --lts
node -v
npm -v

# Install Yarn
echo "📦 Installing Yarn..."
npm install -g yarn

# Set up a basic project directory structure
echo "📂 Setting up development directories..."
mkdir -p ~/javascript-server
cd ~/javascript-server

# Initialize a new Node.js project
echo "🛠️ Initializing a new Node.js project..."
npm init -y

# Install common development dependencies
echo "📦 Installing development dependencies..."
npm install --save-dev eslint prettier lint-staged

# Set up lint-staged configuration
echo "🛡️ Setting up lint-staged config..."
cat <<EOL > package.json
{
  "lint-staged": {
    "*.{js,jsx}": [
      "eslint --fix",
      "prettier --write",
      "git add"
    ]
  }
}
EOL

echo "🎉 JavaScript server environment with Node.js version manager, Yarn, Lint-Staged configured successfully!"


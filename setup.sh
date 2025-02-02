#!/bin/bash

# Step 1: Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y

# Check if the update and upgrade were successful
if [ $? -eq 0 ]; then
  echo "System updated and upgraded successfully."
else
  echo "There was an issue updating/upgrading the system. Exiting..."
  exit 1
fi

# Step 2: Install Docker, Nginx, PHP-FPM, and Unzip

# Add Docker's official GPG key
echo "Adding Docker's official GPG key..."
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository to Apt sources
echo "Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker, Nginx, PHP-FPM, and Unzip
echo "Installing Docker, Nginx, PHP-FPM, and Unzip..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin nginx php-fpm unzip

# Check if installation was successful
if [ $? -eq 0 ]; then
  echo "Docker, Nginx, PHP-FPM, and Unzip installed successfully."
else
  echo "There was an issue installing packages. Exiting..."
  exit 1
fi

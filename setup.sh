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

# Step 3: Ask for input on the number of nodes
echo "Enter the total number of nodes to be hosted on this machine:"
read NUM_NODES

# Step 4: Create directories for nodes
echo "Creating directories for nodes..."

# Create directories for ~/node1, ~/node2, ..., ~/node[N]
for i in $(seq 1 $NUM_NODES); do
  mkdir -p ~/node$i
  mkdir -p /var/www/html$i
done

# Step 5: Download the required PHP files to /var/www/html
echo "Downloading necessary PHP files..."

cd /var/www/html
sudo wget https://raw.githubusercontent.com/storjdashboard/storjdashboard/main/public/index.php
sudo wget https://raw.githubusercontent.com/storjdashboard/storjdashboard/main/public/daily.php
sudo wget https://raw.githubusercontent.com/storjdashboard/storjdashboard/main/public/pay.php
sudo wget https://raw.githubusercontent.com/storjdashboard/storjdashboard/main/public/audit.php

# Step 6: Copy the files to each of the /var/www/html[N] directories
echo "Copying PHP files to each /var/www/html[N] directory..."
for i in $(seq 1 $NUM_NODES); do
  sudo cp /var/www/html/index.php /var/www/html$i/
  sudo cp /var/www/html/daily.php /var/www/html$i/
  sudo cp /var/www/html/pay.php /var/www/html$i/
  sudo cp /var/www/html/audit.php /var/www/html$i/
done

echo "Setup complete."

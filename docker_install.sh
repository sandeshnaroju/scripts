#!/bin/bash

set -e

# Update package index
sudo apt update

# Install required packages
sudo apt install ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the Docker repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index again after adding Docker repository
sudo apt update

# Install Docker
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Verify Docker installation
sudo docker --version
sudo docker run hello-world

# Create Docker group if it doesn't exist and add the current user to it
sudo groupadd docker || true
sudo usermod -aG docker $USER

# Inform the user that a system restart or logout is required for the group change to take effect
echo "You need to log out and log back in or restart your system for Docker to run without sudo."

echo "Docker installation completed."

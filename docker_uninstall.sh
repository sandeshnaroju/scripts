#!/bin/bash

#set -e

# Stop Docker and containerd services
sudo systemctl stop docker
sudo systemctl stop containerd

# Uninstall Docker and containerd packages
sudo apt purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin containerd

# Remove Docker and containerd dependencies and clean up
sudo apt autoremove -y
sudo apt clean

# Remove Docker and containerd directories and configuration files
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
sudo rm -rf /etc/containerd

# Optionally, remove Docker and containerd groups if they exist
sudo groupdel docker || true
sudo groupdel containerd || true

# Optionally, remove Docker GPG key and repository
sudo rm -f /etc/apt/keyrings/docker.asc
sudo rm -f /etc/apt/sources.list.d/docker.list

echo "Docker and containerd uninstallation completed."

#!/bin/bash

#set -e

# Stop Kubernetes services
echo "Stopping Kubernetes services..."
sudo systemctl stop kubelet
sudo systemctl stop kube-apiserver
sudo systemctl stop kube-controller-manager
sudo systemctl stop kube-scheduler

# Reset Kubernetes cluster
echo "Resetting Kubernetes cluster..."
sudo kubeadm reset -f

# Remove Kubernetes packages but do not remove Docker
echo "Removing Kubernetes packages..."
sudo apt purge --allow-change-held-packages -y kubeadm kubectl kubelet kubernetes-cni kube* containerd
sudo apt autoremove -y
sudo apt clean

# Remove Kubernetes configuration and data directories
echo "Removing Kubernetes configuration and data directories..."
sudo rm -f /usr/bin/kubeadm
sudo rm -f /usr/bin/kubectl
sudo rm -f /usr/bin/kubelet
sudo rm -rf /etc/systemd/system/kubelet.service.d
sudo rm -rf /etc/systemd/system/kubelet.service
sudo rm -rf /usr/local/bin/kubeadm
sudo rm -rf /usr/local/bin/kubectl
sudo rm -rf /usr/local/bin/kubelet
sudo rm -rf /etc/kubernetes/
sudo rm -rf /var/lib/kubelet
sudo rm -rf /var/lib/etcd
sudo rm -rf /var/log/containers
sudo rm -rf /var/log/pods
sudo rm -rf /var/run/kubernetes
sudo rm -rf ~/.kube
sudo rm -rf /var/lib/dockershim
sudo rm -rf /var/lib/containerd
sudo rm -f /etc/containerd/config.toml

echo "Removing residual CNI directories..."
sudo rm -rf /opt/cni/bin || true

sudo groupdel containerd || true

# Remove network configurations
echo "Removing network configurations..."
sudo ip link delete cni0 || true
sudo ip link delete flannel.1 || true

# Clean up iptables rules
echo "Cleaning up iptables rules..."
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -X

# Optionally, restart the server to clear any remaining network configurations
# echo "Restarting server..."
# sudo reboot

echo "Kubernetes uninstallation completed."

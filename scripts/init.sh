#!/bin/bash -e

# Disable swap - generally recommended for K8s, but otherwise enable it for other workloads
echo "Disabling Swap"
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# # Remove snap
# echo "Removing snapd"
# while fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do sleep 1; done
# systemctl stop snapd
# systemctl disable snapd
# rm -rf /var/cache/snapd/
# apt-get remove --purge -y snapd
# rm -rf ~/snap

# # Install docker
# echo "Installing Docker"
# while fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do sleep 1; done
# curl -fsSL https://get.docker.com -o get-docker.sh
# sudo sh get-docker.sh

# Apply updates and cleanup Apt cache
echo "Apt update & clean"
while fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock > /dev/null 2>&1; do sleep 1; done
apt-get update
apt-get -y dist-upgrade
apt-get -y autoremove
apt-get -y clean

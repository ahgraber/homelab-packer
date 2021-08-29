#!/bin/bash

# Wait until other apt processes complete
while fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do sleep 1; done

# Install docker
echo "Installing Docker"
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# add user to docker group
groupadd docker
usermod -a -G docker ${username}

# create/restart docker service
mkdir -p /etc/systemd/system/docker.service.d
systemctl daemon-reload
systemctl restart docker

#Allow IPv4/6 bridge traffic to traverse iptables (required by most CNIs)
sysctl net.bridge.bridge-nf-call-iptables=1
sysctl net.bridge.bridge-nf-call-ip6tables=1
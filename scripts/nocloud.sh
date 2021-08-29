#!/bin/bash -e

# Remove all cloudinit
echo "Removing cloudinit"
while fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock > /dev/null 2>&1; do sleep 1; done
apt-get remove --purge -y cloud-init
apt-get autoremove -y

echo "Disabling cloudinit customization"
rm -rf /etc/cloud/
rm -rf /var/lib/cloud/

echo "Removing existing Netplan config file(s)"
rm -f /etc/netplan/*.yaml

echo "Enable Netplan with DHCP"
cat >> /etc/netplan/01-network.cfg << EOF
network:
  ethernets:
    ens192:
      dhcp4: true
    #   addresses:
    #     - ${ip-address}
    #   gateway4: ${gateway}
    #   nameservers:
    #     search: [${domain}]
    #     addresses: [${dns-servers}]
  version: 2
EOF

#!/bin/bash -e

# # Prevent cloud-init from setting IP
# echo "Disabling cloud-init networking"
# bash -c "echo 'network: {config: disabled}' > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg"

echo "Removing existing Netplan config file(s)"
rm -f /etc/netplan/*.yaml

echo "Provide netplan template"
cat >> /etc/netplan/01-network.template << EOF
# network:
#   ethernets:
#     ens192:
#       dhcp4: false
#     #   addresses:
#     #     - ${ip-address}
#     #   gateway4: ${gateway}
#     #   nameservers:
#     #     search: [${domain}]
#     #     addresses: [${dns-servers}]
#   version: 2
EOF
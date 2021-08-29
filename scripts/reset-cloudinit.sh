#!/bin/bash -e

### Add cloud-init-vmware-guestinfo
### DEPRECATED; merged into cloud-init as DataSourceVMware (canonical/cloud-init#953)
echo "Install & configure cloud-init guestinfo"
curl -sSL https://raw.githubusercontent.com/vmware/cloud-init-vmware-guestinfo/master/install.sh | sh -

# Enable cloud-init customization
echo "Enable cloud-init customization for guest OS"
cat >> /etc/cloud/cloud.cfg << EOF

# This will enable guest customization with cloud-init
disable_vmware_customization: false
EOF

# Make sure all datasources are loaded, as rancher uses the NoCloud config
echo "Make sure all data sources will be loaded"
rm -f /etc/cloud/cloud.cfg.d/99-DataSourceVMwareGuestInfo.cfg
rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg
cat "datasource_list: [NoCloud, ConfigDrive, VMware, VMwareGuestInfo, None]" > /etc/cloud/cloud.cfg.d/90_datasource.cfg

# # Ensure cloud-init can configure network
# echo "Allow cloud-init to configure network"
# rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
# rm -f /etc/cloud/cloud.cfg.d/50-curtin-networking.cfg

# Reset Cloud-init state (https://stackoverflow.com/questions/57564641/openstack-packer-cloud-init)
echo "Reset Cloud-Init"
if [[ $(service --status-all | grep -E "^cloud-init$") ]]; then
  systemctl stop cloud-init
  cloud-init clean --logs
fi
# rm -rf /var/lib/cloud/
# rm -f /var/lib/cloud/instance
# rm -rf /var/lib/cloud/instances/*
rm -rf /var/lib/cloud/sem/*{defaults,runcmd,userdata,user-scripts}*
rm -rf /var/lib/cloud/data/cache/obj.pkl

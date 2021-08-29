#!/bin/bash

# Add fix for missing NIC connection
# Ref:
# [1](https://github.com/vmware/open-vm-tools/issues/240#issuecomment-413150508)
# [2](https://github.com/hashicorp/terraform-provider-vsphere/issues/388)
# [3](https://github.com/hashicorp/terraform-provider-vsphere/issues/951))
echo "Add fix for missing NIC"
sed -i '/^\n[Service]/i After=dbus.service/' /lib/systemd/system/open-vm-tools.service
sed -i 's/D \/tmp 1777 root root -/#D \/tmp 1777 root root -/g' /usr/lib/tmpfiles.d/tmp.conf
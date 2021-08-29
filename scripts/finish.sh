#!/bin/bash -e

# Remove installer netplan
rm -f /etc/netplan/00-installer-config.yaml

# Reset the machine-id value. This has known to cause issues with DHCP
# Netplan also uses this as DHCP Identifier, causing multiple VMs from the same Image to get the same IP Address
# This file shouldn't not be deleted but only truncated,
# see https://bugs.launchpad.net/ubuntu/+source/systemd/+bug/1508766
# see https://github.com/DanHam/packer-virt-sysprep/blob/master/sysprep-op-machine-id.sh
echo "Reset Machine-ID"
# Machine ID file locations
sysd_id="/etc/machine-id"
dbus_id="/var/lib/dbus/machine-id"

# Remove and recreate (and so empty) the machine-id file under /etc
if [ -e ${sysd_id} ]; then
  rm -f ${sysd_id} && touch ${sysd_id}
fi

# Remove the machine-id file under /var/lib/dbus if it is not a symlink
if [[ -e ${dbus_id} && ! -L ${dbus_id} ]]; then
  rm -f ${dbus_id}
fi

# touch /home/PACKER_PROVISION_COMPLETE
echo "Packer provision complete"
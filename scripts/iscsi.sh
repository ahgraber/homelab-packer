#!/bin/bash

apt-get install -y \
  lsscsi \
  multipath-tools \
  open-iscsi \
  scsitools \
  sg3-utils

# Enable multipathing
tee /etc/multipath.conf <<-'EOF'
defaults {
    user_friendly_names yes
    find_multipaths yes
}
EOF

systemctl enable multipath-tools.service
service multipath-tools enable
# service multipath-tools restart

# Ensure that open-iscsi and multipath-tools are enabled and running
systemctl status multipath-tools
systemctl enable open-iscsi.service
# service open-iscsi start
# systemctl status open-iscsi

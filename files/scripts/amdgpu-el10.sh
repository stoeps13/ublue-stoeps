#!/bin/sh

set -oue pipefail
echo 'This is the amdgpu firmware shell script'

# Downgrade amdgpu packages
sudo dnf -y downgrade amd-gpu-firmware-20251008-15.8.el10_0 amd-ucode-firmware-20251008-15.8.el10_0

# Clean up repos, everything is on the image so we don't need them
for i in $(ls /etc/yum.repos.d/ | grep -v '^fedora' | grep -v rpmfusion); do
  rm -f /etc/yum.repos.de/${i}
done

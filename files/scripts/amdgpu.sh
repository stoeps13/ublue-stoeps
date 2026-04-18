#!/usr/bin/bash

set -oue pipefail
echo 'This is the amdgpu firmware shell script'

# Downgrade amdgpu packages
cd /tmp
curl -OLk https://kojipkgs.fedoraproject.org//packages/linux-firmware/20250917/2.fc43/noarch/amd-gpu-firmware-20250917-2.fc43.noarch.rpm
curl -OLk https://kojipkgs.fedoraproject.org//packages/linux-firmware/20250917/2.fc43/noarch/amd-ucode-firmware-20250917-2.fc43.noarch.rpm
# curl -OLk https://kojipkgs.fedoraproject.org/packages/linux-firmware/20250509/1.fc43/noarch/amd-ucode-firmware-20250509-1.fc43.noarch.rpm
# curl -OLk https://kojipkgs.fedoraproject.org/packages/linux-firmware/20250509/1.fc43/noarch/amd-gpu-firmware-20250509-1.fc43.noarch.rpm
# sudo dnf -y downgrade amd-gpu-firmware-20250509-1.fc43 amd-ucode-firmware-20250509-1.fc43
# dnf downgrade -y /tmp/amd-ucode-firmware-20250509-1.fc43.noarch.rpm /tmp/amd-gpu-firmware-20250509-1.fc43.noarch.rpm
dnf downgrade -y /tmp/amd-ucode-firmware-20250917-2.fc43.noarch.rpm /tmp/amd-gpu-firmware-20250917-2.fc43.noarch.rpm

# Clean up repos, everything is on the image so we don't need them
for f in /etc/yum.repos.d/*; do
  [[ "$f" == *fedora* || "$f" == *rpmfusion* ]] && continue
  rm -f "$f"
done


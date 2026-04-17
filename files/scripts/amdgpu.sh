#!/usr/bin/bash

set -oue pipefail
echo 'This is the amdgpu firmware shell script'

# Downgrade amdgpu packages
sudo dnf -y downgrade amd-gpu-firmware-20250613-1.fc43 amd-ucode-firmware-20250613-1.fc43

# Clean up repos, everything is on the image so we don't need them
for f in /etc/yum.repos.d/*; do
  [[ "$f" == *fedora* || "$f" == *rpmfusion* ]] && continue
  rm -f "$f"
done


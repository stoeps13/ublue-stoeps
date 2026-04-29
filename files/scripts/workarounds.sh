#!/usr/bin/bash

set -oue pipefail
echo 'This is the workaround shell script'

# alternatives cannot create symlinks on its own during a container build
ln -sf /usr/bin/ld.bfd /etc/alternatives/ld && ln -sf /etc/alternatives/ld /usr/bin/ld

# Disable wayland on Lenovo T470 (prevents OBS crashes)
/usr/libexec/gdm-runtime-config set daemon WaylandEnable false

# Update kernel
echo "Starting Kernel Update"
cd /tmp
FC_VERSION=fc43
BUILD_VERSION=20250917
BUILD_NUM=2
# Downgrad firmware
curl -OLk https://kojipkgs.fedoraproject.org/packages/linux-firmware/${BUILD_VERSION}/${BUILD_NUM}.${FC_VERSION}/noarch/amd-gpu-firmware-${BUILD_VERSION}-${BUILD_NUM}.${FC_VERSION}.noarch.rpm
curl -OLk https://kojipkgs.fedoraproject.org/packages/linux-firmware/${BUILD_VERSION}/${BUILD_NUM}.${FC_VERSION}/noarch/amd-ucode-firmware-${BUILD_VERSION}-${BUILD_NUM}.${FC_VERSION}.noarch.rpm
curl -OLk https://kojipkgs.fedoraproject.org/packages/linux-firmware/${BUILD_VERSION}/${BUILD_NUM}.${FC_VERSION}/noarch/linux-firmware-whence-${BUILD_VERSION}-${BUILD_NUM}.${FC_VERSION}.noarch.rpm
dnf downgrade -y /tmp/amd-ucode-firmware-${BUILD_VERSION}-${BUILD_NUM}.${FC_VERSION}.noarch.rpm /tmp/amd-gpu-firmware-${BUILD_VERSION}-${BUILD_NUM}.${FC_VERSION}.noarch.rpm /tmp/linux-firmware-whence-${BUILD_VERSION}-${BUILD_NUM}.${FC_VERSION}.noarch.rpm

# export KERNELVERSION=6.19.12-200.fc43
export KERNELVERSION=6.17.8-300.fc43
koji download-build --quiet --arch=x86_64 kernel-${KERNELVERSION} \
  && rm ./*debug*.rpm \
  && rm ./*uki*.rpm \
  && dnf downgrade -y --best --allowerasing ./*${KERNELVERSION}.x86_64.rpm \
  && rm -rf ./*.rpm

# Clean up repos, everything is on the image so we don't need them
for f in /etc/yum.repos.d/*; do
  [[ "$f" == *fedora* || "$f" == *rpmfusion* ]] && continue
  rm -f "$f"
done

# Disable ZFS
rm -f /usr/lib/udev/rules.d/90-zfs.rules \
          /usr/lib/udev/rules.d/60-zvol.rules \
          /usr/lib/udev/rules.d/69-vdev.rules \
          /usr/lib/modules-load.d/zfs.conf
# Set bootscreen
# echo 'Set Plymouth default theme'
# plymouth-set-default-theme stoeps

# rm -rf /tmp/* /var/*

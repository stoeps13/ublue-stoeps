#!/bin/sh

set -oue pipefail
echo 'This is the workaround shell script'

# alternatives cannot create symlinks on its own during a container build
ln -sf /usr/bin/ld.bfd /etc/alternatives/ld && ln -sf /etc/alternatives/ld /usr/bin/ld

# Disable wayland on Lenovo T470 (prevents OBS crashes)
/usr/libexec/gdm-runtime-config set daemon WaylandEnable false

# Clean up repos, everything is on the image so we don't need them
for i in $(ls /etc/yum.repos.d/ | grep -v '^fedora' | grep -v rpmfusion); do
  rm -f /etc/yum.repos.de/${i}
done

# Set bootscreen
echo 'Set Plymouth default theme'
plymouth-set-default-theme stoeps

# rm -rf /tmp/* /var/*

#!/bin/sh

set -oue pipefail
echo 'This is the workaround shell script'

# alternatives cannot create symlinks on its own during a container build
ln -sf /usr/bin/ld.bfd /etc/alternatives/ld && ln -sf /etc/alternatives/ld /usr/bin/ld

# Disable wayland on Lenovo T470 (prevents OBS crashes)
/usr/libexec/gdm-runtime-config set daemon WaylandEnable false

# Edit vdirsyncer google.py to make it work with gmail
sed -i 's!urn:ietf:wg:oauth:2.0:oob!http://127.0.0.1:8088!g' $(fd  google.py /usr/lib | grep vdirsyncer)

# Set up services
systemctl enable docker.socket
systemctl enable podman.socket

# Clean up repos, everything is on the image so we don't need them
rm -f /etc/yum.repos.d/ublue-os-staging-fedora-"${FEDORA_MAJOR_VERSION}".repo 
rm -f /etc/yum.repos.d/ganto-lxc4-fedora-"${FEDORA_MAJOR_VERSION}".repo 
rm -f /etc/yum.repos.d/karmab-kcli-fedora-"${FEDORA_MAJOR_VERSION}".repo 
rm -f /etc/yum.repos.d/atim-ubuntu-fonts-fedora-"${FEDORA_MAJOR_VERSION}".repo 
rm -f /etc/yum.repos.d/vscode.repo 
rm -f /etc/yum.repos.d/docker-ce.repo 
rm -f /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:phracek:PyCharm.repo 
rm -f /etc/yum.repos.d/fedora-cisco-openh264.repo 
rm -rf /tmp/* /var/* 

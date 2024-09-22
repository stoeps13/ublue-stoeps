#!/bin/sh

set -oue pipefail
echo 'This is the workaround shell script'

# alternatives cannot create symlinks on its own during a container build
ln -sf /usr/bin/ld.bfd /etc/alternatives/ld && ln -sf /etc/alternatives/ld /usr/bin/ld

# Disable wayland on Lenovo T470 (prevents OBS crashes)
/usr/libexec/gdm-runtime-config set daemon WaylandEnable false

# Edit vdirsyncer google.py to make it work with gmail
sed -i 's!urn:ietf:wg:oauth:2.0:oob!http://127.0.0.1:8088!g' $(fd  google.py /usr/lib | grep vdirsyncer)


# Install atuin
RUN cd /tmp && curl -s https://api.github.com/repos/atuinsh/atuin/releases/latest | grep "browser_download_url" | grep "atuin-x86_64-unknown-linux-gnu.tar.gz" | cut -d : -f 2,3 | tr -d \" | grep -v 'sha256' | wget -q -i - -O atuin-x86_64-unknown-linux-gnu.tar.gz && mkdir atuin-extracted && tar xzf atuin-x86_64-unknown-linux-gnu.tar.gz -C atuin-extracted && mv atuin-extracted/atuin /usr/local/bin && rm -rf /tmp/atuin-extracted atuin-x86_64-unknown-linux-gnu.tar.gz || echo "atuin not installed"

# Set gdm background greeter
# dnf copr enable zirix/gdm-wallpaper
# dnf install gdm-wallpaper
# set-gdm-wallpaper /usr/share/backgrounds/iceland.png
# git clone --depth=1 https://github.com/realmazharhussain/gdm-tools.git /tmp/gdm-tools
# cd /tmp/gdm-tools
# cp /usr/share/gnome-shell/gnome-shell-theme.gresource /usr/share/gnome-shell/gnome-shell-theme.gresource.default
# bin/set-gdm-theme set -b /usr/share/backgrounds/iceland.png
# rm -rf /tmp/gdm-tools

# Clean up repos, everything is on the image so we don't need them
for i in $(ls /etc/yum.repos.d/ | grep -v '^fedora' | grep -v rpmfusion); do
  rm -f /etc/yum.repos.de/${i}
done
# rm -rf /tmp/* /var/*

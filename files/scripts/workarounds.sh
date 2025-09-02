#!/bin/sh

set -oue pipefail
echo 'This is the workaround shell script'

# alternatives cannot create symlinks on its own during a container build
ln -sf /usr/bin/ld.bfd /etc/alternatives/ld && ln -sf /etc/alternatives/ld /usr/bin/ld

# Disable wayland on Lenovo T470 (prevents OBS crashes)
/usr/libexec/gdm-runtime-config set daemon WaylandEnable false

# Edit vdirsyncer google.py to make it work with gmail
# sed -i 's!urn:ietf:wg:oauth:2.0:oob!http://127.0.0.1:8088!g' $(find /usr/lib -name google.py | grep vdirsyncer)

# Clone the Espanso repository
cd /usr/src
git clone https://github.com/espanso/espanso
cd espanso
# Compile espanso in release mode
# NOTE: this will take a while (~5/15 minutes)
cargo build -p espanso --release --no-default-features --features modulo,vendored-tls,wayland
mv target/release/espanso /usr/local/bin/espanso
cd /usr/src
rm -rf espanso

# Clean up repos, everything is on the image so we don't need them
for i in $(ls /etc/yum.repos.d/ | grep -v '^fedora' | grep -v rpmfusion); do
  rm -f /etc/yum.repos.de/${i}
done

# rm -rf /tmp/* /var/*

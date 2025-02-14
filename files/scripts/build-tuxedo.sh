#!/usr/bin/env bash

# Copied from https://github.com/BrickMan240/ublue-tuxedo-rs/blob/main/build.sh
# Licence Apache 2.0
# Copyright: https://github.com/BrickMan240

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
rpm-ostree install screen

rpm-ostree install rpm-build
rpm-ostree install rpmdevtools
rpm-ostree install kmodtool

export HOME=/tmp

rpmdev-setuptree

git clone https://github.com/BrickMan240/tuxedo-drivers-kmod

cd tuxedo-drivers-kmod/
./build.sh
cd ..

# Extract the Version value from the spec file
export TD_VERSION=$(cat tuxedo-drivers-kmod/tuxedo-drivers-kmod-common.spec | grep -E '^Version:' | awk '{print $2}')


rpm-ostree install ~/rpmbuild/RPMS/x86_64/akmod-tuxedo-drivers-$TD_VERSION-1.fc41.x86_64.rpm ~/rpmbuild/RPMS/x86_64/tuxedo-drivers-kmod-$TD_VERSION-1.fc41.x86_64.rpm ~/rpmbuild/RPMS/x86_64/tuxedo-drivers-kmod-common-$TD_VERSION-1.fc41.x86_64.rpm ~/rpmbuild/RPMS/x86_64/kmod-tuxedo-drivers-$TD_VERSION-1.fc41.x86_64.rpm

KERNEL_VERSION="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"

akmods --force --kernels "${KERNEL_VERSION}" --kmod "tuxedo-drivers-kmod"

rpm-ostree install cargo rust meson ninja-build libadwaita-devel gtk4-devel
git clone https://github.com/BrickMan240/tuxedo-rs
cd tuxedo-rs
cd tailord
meson setup --prefix=/usr _build
ninja -C _build
ninja -C _build install
systemctl enable tailord.service
cd ../tailor_gui
meson setup --prefix=/usr _build
ninja -C _build
ninja -C _build install
cd ../..


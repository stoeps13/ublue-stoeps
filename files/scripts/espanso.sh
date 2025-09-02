#!/usr/bin/env bash

set -oue pipefail

echo 'Build espanso'

# Clone the Espanso repository
cd /usr/src
git clone https://github.com/espanso/espanso
cd espanso
# Compile espanso in release mode
# NOTE: this will take a while (~5/15 minutes)
cargo build -p espanso --release --no-default-features --features modulo,vendored-tls,wayland
ls /usr/bin
mv target/release/espanso /usr/bin/espanso
cd /usr/src
rm -rf espanso


#!/bin/bash
set -e

echo "⏳ Updating packages list…"
apt-get update -qq
echo "⏳ Installing curl…"
apt-get install -qq -y curl
echo "⏳ Installing Node.js…"
curl -fsSL "https://deb.nodesource.com/setup_${NODE_VERSION}.x" | bash -
apt-get install -qq -y nodejs
echo "⏳ Installing Yarn…"
npm i -g yarn

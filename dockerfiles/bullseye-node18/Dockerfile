# Run `make build-11-18` to build this image

FROM rust:bullseye

# Node.js
RUN apt-get update -qq
RUN apt-get install -qq -y curl
RUN curl -fsSL "https://deb.nodesource.com/setup_18.x" | bash -
RUN apt-get install -y nodejs
RUN npm i -g yarn

# Install Tarpaulin
# https://github.com/xd009642/tarpaulin#usage
RUN cargo install cargo-tarpaulin

# Install Tauri dependencies
# https://tauri.app/v1/guides/getting-started/prerequisites#setting-up-linux
RUN apt-get install -y \
  libwebkit2gtk-4.0-dev \
  build-essential \
  curl \
  wget \
  libssl-dev \
  libgtk-3-dev \
  libayatana-appindicator3-dev \
  librsvg2-dev

# Install Tauri Driver
# https://tauri.app/v1/guides/testing/webdriver/ci
RUN apt-get install -y \
  libgtksourceview-3.0-dev \
  webkit2gtk-4.0-dev \
  webkit2gtk-driver \
  xvfb
RUN cargo install tauri-driver

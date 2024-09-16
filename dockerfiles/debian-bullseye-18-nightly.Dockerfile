# Run `make build-debian-bullseye-18-nightly` to build this image

FROM rust:bullseye

# Install base utils
RUN apt-get update
RUN apt-get install -y \
  curl \
  psmisc

# Intsall Rust nightly
RUN rustup default nightly

# Install Node.js
RUN apt-get update
RUN apt-get install -y curl
RUN curl -fsSL "https://deb.nodesource.com/setup_18.x" | bash -
RUN apt-get install -y nodejs

# Install Yarn
RUN corepack enable

# Install Tarpaulin
RUN cargo install cargo-tarpaulin

# Install Tauri v1 dependencies
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

# Tauri v2 dependencies
# => Impossible: https://github.com/tauri-apps/tauri/issues/9039

# Install tauri-driver dependencies
RUN apt-get install -y \
  dbus-x11 \
  webkit2gtk-4.0-dev \
  webkit2gtk-driver \
  xvfb

# Install tauri-driver
# https://tauri.app/v1/guides/testing/webdriver/introduction#system-dependencies
RUN cargo install tauri-driver

CMD ["/bin/bash"]

FROM rust:1-bookworm

# Install base utils
RUN apt-get update && apt-get install -y \
  curl \
  psmisc

# Install Rust nightly
RUN rustup default nightly

# Install Node.js
RUN curl -fsSL "https://deb.nodesource.com/setup_26.x" | bash - && apt-get install -y nodejs

# Install Yarn
RUN npm install -g corepack && corepack enable

# Install Tarpaulin
RUN cargo install cargo-tarpaulin

# Install Tauri v2 dependencies
# https://v2.tauri.app/start/prerequisites/#linux
RUN apt-get update && apt-get install -y \
  libwebkit2gtk-4.1-dev \
  build-essential \
  curl \
  wget \
  file \
  libxdo-dev \
  libssl-dev \
  libayatana-appindicator3-dev \
  librsvg2-dev

# Install Tauri v1 dependencies (minus those shared with Tauri v2)
# https://v1.tauri.app/v1/guides/getting-started/prerequisites/#setting-up-linux
RUN apt-get update && apt-get install -y \
  libwebkit2gtk-4.0-dev \
  libgtk-3-dev

# Install tauri-driver dependencies
# https://v2.tauri.app/develop/tests/webdriver/ci/
RUN apt-get update && apt-get install -y \
  dbus-x11 \
  webkit2gtk-driver \
  xvfb

# Install tauri-driver
# https://v2.tauri.app/develop/tests/webdriver/
RUN cargo install tauri-driver --locked

CMD ["/bin/bash"]

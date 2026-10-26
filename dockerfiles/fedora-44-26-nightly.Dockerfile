FROM fedora:44

# Install base utils
RUN dnf update -y
RUN dnf install -y \
  psmisc \
  which

# Install Rust dependencies
# https://www.pragmaticlinux.com/2022/05/how-to-install-build-essential-on-fedora/
RUN dnf group install -y c-development development-tools

# Rust
# https://forge.rust-lang.org/infra/other-installation-methods.html#other-ways-to-install-rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# TODO Find a cleaner solution to make rust/cargo binaries available everywhere.
RUN mv /root/.cargo/bin/* /usr/local/bin/
RUN rustup completions bash > /etc/bash_completion.d/rustup.bash-completion

# Install Rust nightly
RUN rustup default nightly

# Install Node.js
RUN curl -fsSL https://rpm.nodesource.com/setup_26.x | bash -
RUN dnf install -y nodejs

# Install Yarn
RUN npm install -g corepack
RUN corepack enable

# Install Tarpaulin dependencies
RUN dnf install -y openssl-devel

# Install Tarpaulin
RUN cargo install cargo-tarpaulin

# Install Tauri v2 dependencies
# https://v2.tauri.app/start/prerequisites/#linux
RUN dnf install -y \
  curl \
  file \
  libappindicator-gtk3-devel \
  librsvg2-devel \
  libxdo-devel \
  openssl-devel \
  webkit2gtk4.1-devel \
  wget

# Install tauri-driver dependencies
# https://v2.tauri.app/develop/tests/webdriver/
# On Fedora, `WebKitWebDriver` is only packaged in `webkitgtk6.0`.
RUN dnf install -y \
  dbus-x11 \
  webkitgtk6.0 \
  xorg-x11-server-Xvfb

# Install tauri-driver
# https://v2.tauri.app/develop/tests/webdriver/
RUN cargo install tauri-driver --locked
# TODO Find a cleaner solution to make rust/cargo binaries available everywhere.
RUN ln -s /root/.cargo/bin/tauri-driver /usr/local/bin/tauri-driver

# Fedora 42+ merged `sbin` into `bin`: drop the `sbin` symlinks from `PATH` so binaries resolve to their `bin` paths
ENV PATH="/usr/local/bin:/usr/bin"

CMD ["/bin/bash"]

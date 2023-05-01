# Run `make build-fedora-37-18` to build this image

FROM fedora:39

# Install base utils
RUN dnf update -y
RUN dnf install -y \
  psmisc \
  which

# Install Rust dependencies
# https://www.pragmaticlinux.com/2022/05/how-to-install-build-essential-on-fedora/
RUN dnf group install -y "C Development Tools and Libraries" "Development Tools"

# Rust
# https://forge.rust-lang.org/infra/other-installation-methods.html#other-ways-to-install-rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# TODO Find a cleaner solution to make rust/cargo binaries available everywhere.
RUN mv /root/.cargo/bin/* /usr/local/bin/
RUN rustup completions bash > /etc/bash_completion.d/rustup.bash-completion

# Install Node.js
RUN dnf module install -y nodejs:18/common

# Install Yarn
RUN curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo
RUN dnf install -y yarn

# Install Tarpaulin dependencies
RUN dnf group install -y "C Development Tools and Libraries" "Development Tools"
RUN dnf install -y openssl-devel

# Install Tarpaulin
RUN cargo install cargo-tarpaulin

# Install Tauri dependencies
# https://tauri.app/v1/guides/getting-started/prerequisites#setting-up-linux
RUN dnf install -y \
  curl \
  libappindicator-gtk3 \
  librsvg2-devel \
  # openssl-devel \
  webkit2gtk4.0-devel \
  wget

# Install tauri-driver
# https://tauri.app/v1/guides/testing/webdriver/introduction#system-dependencies
RUN cargo install tauri-driver
# TODO Find a cleaner solution to make rust/cargo binaries available everywhere.
RUN ln -s /root/.cargo/bin/tauri-driver /usr/local/bin/tauri-driver
RUN rustup completions bash > /etc/bash_completion.d/rustup.bash-completion

CMD ["/bin/bash"]

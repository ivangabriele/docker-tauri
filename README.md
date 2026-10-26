# Tauri Docker Image

[![img-docker]][link-docker]
[![img-github-actions]][link-github-actions]

Full-featured Tauri Docker Image based on the official non-slim [Rust][link-rust] images for Debian tags, and on the
official [Fedora][link-fedora] image with [rustup][link-rustup] for Fedora tags, including:

- [Tauri][link-tauri]
- [Node.js][link-nodejs] _with [Yarn][link-yarn]_
- [Tarpaulin][link-tarpaulin]
- [tauri-driver][link-tauri-driver] _with [WebDriver][link-webdriver]/[WebDriverIO][link-webdriverio]_
- [psmisc][link-psmisc] (which includes [fuser][link-fuser])

This image is a good base for CIs (builds, unit & e2e tests, etc.) as well as for local runs.

Images are automatically updated on a daily basis.

---

- [Supported tags and respective `Dockerfile` links](#supported-tags-and-respective-dockerfile-links)
  - [Debian v12 ("bookworm")](#debian-v12-bookworm)
  - [Fedora v40](#fedora-v40)
  - [Legacy tags](#legacy-tags)
- [E2E Testing](#e2e-testing)
  - [WebDriverIO](#webdriverio)
- [Continuous Integration](#continuous-integration)
  - [GitHub Actions](#github-actions)
- [Contribute](#contribute)
  - [Prerequisites](#prerequisites)
  - [Build](#build)
  - [Run](#run)
  - [Test](#test)

---

## Supported tags and respective `Dockerfile` links

### Debian v12 ("bookworm")

> [!NOTE]  
> These tags work with both **Tauri v1 and v2**.

- [`debian-bookworm-22`][link-dockerfile-debian-bookworm-22]
  - Base: [`rust:1-bookworm`][link-rust]
  - Debian v12 ("bookworm") + Rust v1 + Node v22
- [`debian-bookworm-22-nightly`][link-dockerfile-debian-bookworm-22-nightly]
  - Base: [`rust:1-bookworm`][link-rust]
  - Debian v12 ("bookworm") + Rust v1 (nightly) + Node v22
- [`debian-bookworm-20`][link-dockerfile-debian-bookworm-20]
  - Base: [`rust:1-bookworm`][link-rust]
  - Debian v12 ("bookworm") + Rust v1 + Node v20
- [`debian-bookworm-20-nightly`][link-dockerfile-debian-bookworm-20-nightly]
  - Base: [`rust:1-bookworm`][link-rust]
  - Debian v12 ("bookworm") + Rust v1 (nightly) + Node v20

### Fedora v40

> [!NOTE]  
> These tags only work with **Tauri v2**.

- [`fedora-40-22`][link-dockerfile-fedora-40-22]
  - Base: [`fedora:40`][link-fedora] + [rustup][link-rustup]
  - Fedora v40 + Rust v1 + Node v22
- [`fedora-40-22-nightly`][link-dockerfile-fedora-40-22-nightly]
  - Base: [`fedora:40`][link-fedora] + [rustup][link-rustup]
  - Fedora v40 + Rust v1 (nightly) + Node v22
- [`fedora-40-20`][link-dockerfile-fedora-40-20]
  - Base: [`fedora:40`][link-fedora] + [rustup][link-rustup]
  - Fedora v40 + Rust v1 + Node v20
- [`fedora-40-20-nightly`][link-dockerfile-fedora-40-20-nightly]
  - Base: [`fedora:40`][link-fedora] + [rustup][link-rustup]
  - Fedora v40 + Rust v1 (nightly) + Node v20

### Legacy tags

These tags still exist, but their images are no longer updated.

> [!IMPORTANT]  
> The `debian-bullseye-*` tags only work with **Tauri v1**. See [tauri-apps/tauri#9039][link-tauri-issue-9039].

- [`debian-bookworm-18`][link-dockerfile-debian-bookworm-18]
- [`debian-bookworm-18-nightly`][link-dockerfile-debian-bookworm-18-nightly]
- [`debian-bullseye-22`][link-dockerfile-debian-bullseye-22]
- [`debian-bullseye-22-nightly`][link-dockerfile-debian-bullseye-22-nightly]
- [`debian-bullseye-20`][link-dockerfile-debian-bullseye-20]
- [`debian-bullseye-20-nightly`][link-dockerfile-debian-bullseye-20-nightly]
- [`debian-bullseye-18`][link-dockerfile-debian-bullseye-18]
- [`debian-bullseye-18-nightly`][link-dockerfile-debian-bullseye-18-nightly]
- [`fedora-37-20`][link-dockerfile-fedora-37-20]
- [`fedora-37-20-nightly`][link-dockerfile-fedora-37-20-nightly]
- [`fedora-37-18`][link-dockerfile-fedora-37-18]
- [`fedora-37-18-nightly`][link-dockerfile-fedora-37-18-nightly]

## E2E Testing

### WebDriverIO

Since `tauri-driver` is available as a global command in this image, you can use it as is in `wdio.config.js`
([see documentation](https://v2.tauri.app/develop/tests/webdriver/example/webdriverio/#config)):

```js
// ...

const config = {
  // ...

  beforeSession: () => {
    // => No need for that: `path.resolve(os.homedir(), '.cargo', 'bin', 'tauri-driver')`
    tauriDriver = spawn("tauri-driver", [], {
      stdio: [null, process.stdout, process.stderr],
    });
  },

  // ...
};

// ...
```

## Continuous Integration

### GitHub Actions

Example:

```yml
jobs:
  core_unit_test:
    name: Core Unit Test
    runs-on: ubuntu-latest
    container:
      image: ivangabriele/tauri:debian-bookworm-22
      # This is REQUIRED if you use `tarpaulin`
      # https://github.com/xd009642/tarpaulin/issues/146
      # https://github.com/xd009642/tarpaulin#github-actions
      options: --security-opt seccomp=unconfined
    steps:
      - name: Checkout
        uses: actions/checkout@v7
      - name: Run
        run: cargo test
        working-directory: ./src-tauri
      # https://github.com/xd009642/tarpaulin#github-actions
      - name: Generate Coverage
        run: cargo tarpaulin --all-features --out Xml --timeout 120 --verbose
        working-directory: ./src-tauri
      # Add any other step here to upload your coverage somewhere

  e2e_test:
    name: E2E Test
    runs-on: ubuntu-latest
    container:
      image: ivangabriele/tauri:debian-bookworm-22
    steps:
      - name: Checkout
        uses: actions/checkout@v7
      - name: Install Node.js dependencies
        run: yarn --frozen-lockfile # or `npm ci`
      - name: Build
        # Add your core + webview build command(s)
        run: ...
      # I recommend using the `nick-fields/retry@v4` action here
      # with a `fuser -n tcp -k 4445` command to kill the process holding port 4445 (likely Selenium)
      # since WebdriverIO often hangs during the first run (unable to connect)
      - name: Run tests
        uses: nick-fields/retry@v4
        with:
          timeout_seconds: 600
          max_attempts: 3
          retry_on: error
          # https://v2.tauri.app/develop/tests/webdriver/ci/
          command: |
            fuser -n tcp -k 4445
            xvfb-run wdio run ./configs/wdio.config.js
```

## Contribute

`X` is the OS name + version (one of `debian-bookworm`, `fedora-40`).  
`y` is the Node.js tag (one of `20`, `22`).  
`Z` is the Rust variant (`-nightly` or nothing).

### Prerequisites

- Docker, Podman or any other Docker-compatible container engine.
- [mise][link-mise] + `mise install` _if you want to run the tests_.

### Build

```sh
DOCKER_IMAGE_TAG=[DOCKER_TAG] make build
```

Example: `DOCKER_IMAGE_TAG=debian-bookworm-22 make build`

### Run

```sh
DOCKER_IMAGE_TAG=[DOCKER_TAG] make run
```

Example: `DOCKER_IMAGE_TAG=debian-bookworm-22 make run`

### Test

You need to have [mise][link-mise] installed and run `mise install` in order to run the tests:

```sh
DOCKER_IMAGE_TAG=[DOCKER_TAG] make test
```

Example: `DOCKER_IMAGE_TAG=debian-bookworm-22 make test`.

---

[img-docker]: https://img.shields.io/docker/pulls/ivangabriele/tauri?style=for-the-badge
[img-github-actions]: https://img.shields.io/github/actions/workflow/status/ivangabriele/docker-tauri/main.yml?branch=main&label=Build%2BTest&style=for-the-badge
[link-docker]: https://hub.docker.com/r/ivangabriele/tauri
[link-dockerfile-debian-bookworm-18]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/legacy/debian-bookworm-18.Dockerfile
[link-dockerfile-debian-bookworm-18-nightly]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/legacy/debian-bookworm-18-nightly.Dockerfile
[link-dockerfile-debian-bookworm-20]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/debian-bookworm-20.Dockerfile
[link-dockerfile-debian-bookworm-20-nightly]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/debian-bookworm-20-nightly.Dockerfile
[link-dockerfile-debian-bookworm-22]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/debian-bookworm-22.Dockerfile
[link-dockerfile-debian-bookworm-22-nightly]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/debian-bookworm-22-nightly.Dockerfile
[link-dockerfile-debian-bullseye-18]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/legacy/debian-bullseye-18.Dockerfile
[link-dockerfile-debian-bullseye-18-nightly]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/legacy/debian-bullseye-18-nightly.Dockerfile
[link-dockerfile-debian-bullseye-20]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/legacy/debian-bullseye-20.Dockerfile
[link-dockerfile-debian-bullseye-20-nightly]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/legacy/debian-bullseye-20-nightly.Dockerfile
[link-dockerfile-debian-bullseye-22]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/legacy/debian-bullseye-22.Dockerfile
[link-dockerfile-debian-bullseye-22-nightly]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/legacy/debian-bullseye-22-nightly.Dockerfile
[link-dockerfile-fedora-37-18]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/legacy/fedora-37-18.Dockerfile
[link-dockerfile-fedora-37-18-nightly]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/legacy/fedora-37-18-nightly.Dockerfile
[link-dockerfile-fedora-37-20]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/legacy/fedora-37-20.Dockerfile
[link-dockerfile-fedora-37-20-nightly]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/legacy/fedora-37-20-nightly.Dockerfile
[link-dockerfile-fedora-40-20]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/fedora-40-20.Dockerfile
[link-dockerfile-fedora-40-20-nightly]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/fedora-40-20-nightly.Dockerfile
[link-dockerfile-fedora-40-22]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/fedora-40-22.Dockerfile
[link-dockerfile-fedora-40-22-nightly]: https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/fedora-40-22-nightly.Dockerfile
[link-fedora]: https://hub.docker.com/_/fedora
[link-fuser]: https://man7.org/linux/man-pages/man1/fuser.1.html
[link-github-actions]: https://github.com/ivangabriele/docker-tauri/actions/workflows/main.yml
[link-mise]: https://mise.jdx.dev
[link-nodejs]: https://nodejs.org
[link-psmisc]: https://packages.debian.org/bookworm/psmisc
[link-rust]: https://hub.docker.com/_/rust
[link-rustup]: https://rustup.rs
[link-tarpaulin]: https://github.com/xd009642/tarpaulin#readme
[link-tauri]: https://tauri.app
[link-tauri-driver]: https://crates.io/crates/tauri-driver
[link-tauri-issue-9039]: https://github.com/tauri-apps/tauri/issues/9039
[link-webdriver]: https://www.w3.org/TR/webdriver/
[link-webdriverio]: https://webdriver.io
[link-yarn]: https://yarnpkg.com

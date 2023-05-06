# Tauri Docker Image

[![img-docker]][link-docker]
[![img-github-actions]][link-github-actions]

Full-featured Tauri Docker Image based on [Rust][link-rust] non-slim Debian images including:

- [Tauri][link-tauri]
- [Node.js][link-nodejs] _with [Yarn][link-yarn]_
- [Tarpaulin][link-tarpaulin]
- [tauri-driver][link-tauri-driver] * _with [WebDriver][link-webdriver]/[WebDriverIO][link-webdriverio]_
- [psmisc][link-psmisc] (which includes [fuser][link-fuser])

> ⚠️ **(*) tauri-driver is currently in pre-alpha**  
> Check the [official documentation](https://tauri.app/v1/guides/testing/webdriver/introduction) for more information.

This image is a good base for CIs (builds, unit & e2e tests, etc) as well as for local runs.

Images are automatically updated on a daily basis.

---

- [Supported tags and respective `Dockerfile` links](#supported-tags-and-respective-dockerfile-links)
- [E2E Testing](#e2e-testing)
  - [WebDriverIO](#webdriverio)
- [Continuous Integration](#continuous-integration)
  - [Github Actions](#github-actions)
- [Roadmap](#roadmap)
- [Contribute](#contribute)
  - [Prerequisites](#prerequisites)
  - [Build](#build)
  - [Run](#run)
  - [Test](#test)

---

## Supported tags and respective `Dockerfile` links

- [`debian-bookworm-18`](https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/debian-bookworm-18.Dockerfile)
- [`debian-bookworm-18-nightly`](https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/debian-bookworm-18-nightly.Dockerfile)
- [`debian-bullseye-18`](https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/debian-bullseye-18.Dockerfile)
- [`debian-bullseye-18-nightly`](https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/debian-bullseye-18-nightly.Dockerfile)
- [`fedora-37-18`](https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/fedora-37-18.Dockerfile)
- [`fedora-37-18-nightly`](https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/fedora-37-18-nightly.Dockerfile)

## E2E Testing

### WebDriverIO

Since `tauri-driver` is available as a global command in this image, you can use it as is in `wdio.config.js`
([see documentation](https://tauri.app/v1/guides/testing/webdriver/example/webdriverio#config)):

```js
// Keep track of the `tauri-driver` child process
let tauriDriver;

const config = {
  // Ensure we are running `tauri-driver` before the session starts,
  // so that we can proxy the webdriver requests
  beforeSession: () => {
    // No need for that: `path.resolve(os.homedir(), '.cargo', 'bin', 'tauri-driver')`
    tauriDriver = spawn('tauri-driver', [], {
      stdio: [null, process.stdout, process.stderr],
    })
  },

  // Clean up the `tauri-driver` process we spawned at the start of the session
  afterSession: () => tauriDriver.kill(),

  // ...
}
```

## Continuous Integration

### Github Actions

Example:

```yml
jobs:
  core_unit_test:
    name: Core Unit Test
    runs-on: ubuntu-latest
    container:
      image: ivangabriele/tauri:debian-bullseye-18
      # This is REQUIRED if you use `tarpaulin`
      # https://github.com/xd009642/tarpaulin/issues/146
      # https://github.com/xd009642/tarpaulin#github-actions
      options: --security-opt seccomp=unconfined
    steps:
      - name: Checkout
        uses: actions/checkout@v3
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
      image: ivangabriele/tauri:debian-bullseye-18
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Install Node.js dependencies
        run: yarn --frozen-lockfile # or `npm ci`
      - name: Build
        # Add your core + webview build command(s)
        run: ...
      # I recommend using `nick-fields/retry@v2` action here
      # with a `fuser -n tcp -k 4445` command to kill the process using (likely Selenium)
      # since WebdriverIO often hangs out during the first run (unable to connect)
      - name: Run tests
        uses: nick-fields/retry@v2
        with:
          timeout_seconds: 600
          max_attempts: 3
          retry_on: error
          # https://tauri.app/v1/guides/testing/webdriver/ci
          command: |
            fuser -n tcp -k 4445
            xvfb-run wdio run ./configs/wdio.config.js
```

## Roadmap

Excepted Ubuntu, all those planned distributions are a maybe for now.

- Arch
- Fedora 38
- NixOS
- openSUSE
- Ubuntu 22

## Contribute

`X` is the OS name + version (one of `debian-bookworm`, `debian-bullseye`, `fedora-37`).  
`y` is the Node.js tag (`18`).  
`Z` is the Rust variant (`-nightly` or nothing).

### Prerequisites

- Docker ([Desktop](https://docs.docker.com/desktop/) or [Engine](https://docs.docker.com/engine/install/))
- [Node.js](https://nodejs.org) _if you want to run the tests_

### Build

```sh
make build-X-Y # with no variant
make build-X-Y-Z
```

Example: `make build-debian-bullseye-18` or `make build-debian-bullseye-18-nightly`.

### Run

```sh
make run-X-Y # with no variant
make run-X-Y-Z
```

Example: `make run-debian-bullseye-18` or `make run-debian-bullseye-18-nightly`.

### Test

You need to have [Node.js][link-nodejs] installed in order to run tests:
node
```sh
make test-X-Y # with no variant
make test-X-Y-Z
```

Example: `make test-debian-bullseye-18` or `make test-debian-bullseye-18-nightly`.

---

[img-docker]: https://img.shields.io/docker/pulls/ivangabriele/tauri?style=for-the-badge
[img-github-actions]:
  https://img.shields.io/github/actions/workflow/status/ivangabriele/docker-tauri/main.yml?branch=main&label=Build%2BTest&style=for-the-badge

[link-docker]: https://hub.docker.com/r/ivangabriele/tauri
[link-fuser]: https://man7.org/linux/man-pages/man1/fuser.1.html
[link-github-actions]: https://github.com/ivangabriele/docker-tauri/actions/workflows/main.yml
[link-nodejs]: https://nodejs.org
[link-psmisc]: https://packages.debian.org/bullseye/psmisc
[link-rust]: https://hub.docker.com/_/rust
[link-rust-nightly]: https://hub.docker.com/r/rustlang/rust
[link-tarpaulin]: https://github.com/xd009642/tarpaulin#readme
[link-tauri]: https://tauri.app
[link-tauri-driver]: https://crates.io/crates/tauri-driver
[link-webdriver]: https://www.w3.org/TR/webdriver/
[link-webdriverio]: https://webdriver.io
[link-yarn]: https://yarnpkg.com

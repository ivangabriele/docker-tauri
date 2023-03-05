# Tauri Docker Image

[![img-docker]][link-docker]
[![img-github-actions]][link-github-actions]

Full-featured Tauri Docker Image based on [Rust][link-rust] non-slim Debian images including:

- [Tauri][link-tauri]
- [Node.js][link-nodejs] with [Yarn][link-yarn]
- [Tarpaulin][link-tarpaulin]
- [tauri-driver](https://crates.io/crates/tauri-driver) *

> ⚠️ **(*) tauri-driver is currently in pre-alpha**  
> Check the [official documentation](https://tauri.app/v1/guides/testing/webdriver/introduction) for more information.

This image is a good base for CIs (builds, unit & e2e tests, etc) as well as for local runs.

Images are automatically updated on a daily basis.

`-nightly` variants are based on [rustlang/rust][link-rust-nightly] non-slim Debian images.

---

- [Supported tags and respective `Dockerfile` links](#supported-tags-and-respective-dockerfile-links)
- [E2E Testing](#e2e-testing)
  - [WebDriverIO](#webdriverio)
- [Continuous Integration](#continuous-integration)
  - [Github Actions](#github-actions)
- [Contribute](#contribute)
  - [Build](#build)
  - [Run](#run)
  - [Test](#test)

---

## Supported tags and respective `Dockerfile` links

- [`debian-bookworm-node18`](https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/debian-bookworm-node18.Dockerfile)
- [`debian-bookworm-node18-nightly`](https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/debian-bookworm-node18-nightly.Dockerfile)

- [`debian-bullseye-node18`](https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/debian-bullseye-node18.Dockerfile)
- [`debian-bullseye-node18-nightly`](https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/debian-bullseye-node18-nightly.Dockerfile)

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
      image: ivangabriele/tauri:bullseye-node18
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
      image: ivangabriele/tauri:bullseye-node18
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Install Node.js dependencies
        run: yarn --frozen-lockfile # or `npm ci`
      - name: Build
        # Add your core + webview build command(s)
        run: ...
      - name: Run
        # https://tauri.app/v1/guides/testing/webdriver/ci
        run: xvfb-run wdio --native-driver run ./configs/wdio.config.js
```

## Contribute

`X` is the OS name (`debian`).
`Y` is the OS codename (`bullseye`, `bookworm`).
`Z` is the Node.js version (`18`).
`V` is the Rust variant (`-nightly` or nothing).

### Build

```sh
make build-X-Y-Z # with no variant
make build-X-Y-Z-V
```

Example: `make build-debian-bookworm-18` or `make build-debian-bullseye-18-nightly`.

### Run

```sh
make run-X-Y-Z # with no variant
make run-X-Y-Z-V
```

Example: `make run-debian-bookworm-18` or `make run-debian-bullseye-18-nightly`.

### Test

You need to have [Bats][link-bats] (`bats-core`) installed in order to run tests:

```sh
make test-X-Y-Z # with no variant
make test-X-Y-Z-V
```

Example: `make test-debian-bookworm-18` or `make test-debian-bullseye-18-nightly`.

---

[img-docker]: https://img.shields.io/docker/pulls/ivangabriele/tauri?style=for-the-badge
[img-github-actions]:
  https://img.shields.io/github/actions/workflow/status/ivangabriele/docker-tauri/main.yml?branch=main&style=for-the-badge

[link-bats]: https://bats-core.readthedocs.io
[link-docker]: https://hub.docker.com/repository/docker/ivangabriele/tauri
[link-github-actions]: https://github.com/ivangabriele/docker-tauri/actions/workflows/main.yml
[link-nodejs]: https://nodejs.org
[link-rust]: https://hub.docker.com/_/rust
[link-rust-nightly]: https://hub.docker.com/r/rustlang/rust
[link-tarpaulin]: https://github.com/xd009642/tarpaulin#readme
[link-tauri]: https://tauri.app
[link-yarn]: https://yarnpkg.com

# Tauri Docker Image

[![img-docker]][link-docker]
[![img-github-actions]][link-github-actions]

Full-featured Tauri Docker Image based on [Rust][link-rust] non-slim debian images including:

- [Tauri][link-tauri]
- [Node.js][link-nodejs] with [Yarn][link-yarn]
- [Tarpaulin][link-tarpaulin]
- [tauri-driver](https://crates.io/crates/tauri-driver) *

> ⚠️ **(*) tauri-driver is currently in pre-alpha**  
> Check the [official documentation](https://tauri.app/v1/guides/testing/webdriver/introduction) for more information.

This image is a good base for CIs (builds, unit & e2e tests, etc) as well as for local runs.

Images are automatically updated on a daily basis.

## Supported tags and respective `Dockerfile` links

- [`bullseye-node18`](https://github.com/ivangabriele/docker-tauri/blob/main/dockerfiles/bullseye-node18/Dockerfile)

## Contribute

### Test

_This part needs more scripts and instructions to make it work outside of CI._

You need to have [Bats][link-bats] (`bats-core`) installed in order to run tests:

```shell
make test
```

---

[img-docker]: https://img.shields.io/docker/pulls/ivangabriele/tauri?style=for-the-badge
[img-github-actions]:
  https://img.shields.io/github/workflow/status/ivangabriele/docker-tauri/Main/main?label=Main&style=for-the-badge

[link-bats]: https://github.com/bats-core/bats-core#readme
[link-docker]: https://hub.docker.com/repository/docker/ivangabriele/tauri
[link-github-actions]: https://github.com/ivangabriele/docker-tauri/actions/workflows/main.yml
[link-nodejs]: https://nodejs.org
[link-rust]: https://hub.docker.com/_/rust
[link-tarpaulin]: https://github.com/xd009642/tarpaulin#readme
[link-tauri]: https://tauri.app
[link-yarn]: https://yarnpkg.com

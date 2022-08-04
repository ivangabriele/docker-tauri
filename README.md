# Clamav Desktop CI Docker Image

[![img-docker]][link-docker]
[![img-github-actions]][link-github-actions]

Images are automatically updated on a daily basis.

## Supported tags and respective `Dockerfile` links

By default, Node.js v14 is installed. You can add `-node16` to use Node.js v16 instead.

- [`bullseye-node18`](https://github.com/ivangabriele/clamav-desktop-ci/blob/main/dockerfiles/bullseye-node18/Dockerfile)

## Contribute

### Test

You need to have [Bats][link-bats] (`bats-core`) installed in order to run tests:

```shell
make test
```

---

[img-docker]: https://img.shields.io/docker/pulls/ivangabriele/clamav-desktop-ci?style=for-the-badge
[img-github-actions]:
  https://img.shields.io/github/workflow/status/ivangabriele/clamav-desktop-ci/Main/main?label=Main&style=for-the-badge

[link-bats]: https://github.com/bats-core/bats-core
[link-docker]: https://hub.docker.com/repository/docker/ivangabriele/clamav-desktop-ci
[link-github-actions]: https://github.com/ivangabriele/clamav-desktop-ci/actions/workflows/main.yml
[link-node]: https://nodejs.org
[link-postgres]: https://hub.docker.com/_/postgres
[link-yarn]: https://yarnpkg.com

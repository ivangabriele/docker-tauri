#!/usr/bin/env bats
# https://bats-core.readthedocs.io/en/latest/index.html
# https://github.com/tkuchiki/bats-travis-ci/blob/master/test.bats

_SUBJECT="clamav-desktop-ci:${DEBIAN_VERSION}-${NODE_VERSION}"

@test "${_SUBJECT} > Check Node.js path" {
  run docker exec "${DOCKER_CONTAINER_NAME}" which node

  [[ "${output}" == "/usr/bin/node" ]]
}

@test "${_SUBJECT} > Check Yarn path" {
  run docker exec "${DOCKER_CONTAINER_NAME}" which yarn

  [[ "${output}" == "/usr/bin/yarn" ]]
}

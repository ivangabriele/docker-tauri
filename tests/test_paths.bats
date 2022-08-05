#!/usr/bin/env bats
# https://bats-core.readthedocs.io/en/latest/index.html
# https://github.com/tkuchiki/bats-travis-ci/blob/master/test.bats

@test "${DOCKER_IMAGE_TAG} > Check Cargo path" {
  run docker exec "${DOCKER_CONTAINER_NAME}" which cargo

  [[ "${output}" == "/usr/local/cargo/bin/cargo" ]]
}

@test "${DOCKER_IMAGE_TAG} > Check Node.js path" {
  run docker exec "${DOCKER_CONTAINER_NAME}" which node

  [[ "${output}" == "/usr/bin/node" ]]
}

@test "${DOCKER_IMAGE_TAG} > Check Yarn path" {
  run docker exec "${DOCKER_CONTAINER_NAME}" which yarn

  [[ "${output}" == "/usr/bin/yarn" ]]
}

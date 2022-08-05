#!/usr/bin/env bats
# https://bats-core.readthedocs.io/en/latest/index.html
# https://github.com/tkuchiki/bats-travis-ci/blob/master/test.bats

@test "${DOCKER_IMAGE_TAG} > Check Node.js version" {
  run docker exec "${DOCKER_CONTAINER_NAME}" node --version

  [[ "${output}" == "v${NODE_VERSION}."* ]]
}

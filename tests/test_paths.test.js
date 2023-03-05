const { execDockerCommand } = require("./utils");

const { DOCKER_IMAGE_TAG } = process.env;

describe(DOCKER_IMAGE_TAG, () => {
  it("has expected Cargo path", async () => {
    const { stdout } = await execDockerCommand("which cargo");

    expect(stdout.trim()).toBe("/usr/local/cargo/bin/cargo");
  });

  it("has expected Node.js path", async () => {
    const { stdout } = await execDockerCommand("which node");

    expect(stdout.trim()).toBe("/usr/bin/node");
  });

  it("has expected tauri-driver path", async () => {
    const { stdout } = await execDockerCommand("which tauri-driver");

    expect(stdout.trim()).toBe("/usr/local/cargo/bin/tauri-driver");
  });

  it("has expected Yarn path", async () => {
    const { stdout } = await execDockerCommand("which yarn");

    expect(stdout.trim()).toBe("/usr/bin/yarn");
  });
});
// @test "${DOCKER_IMAGE_TAG} > Check Cargo path" {
//   run docker exec "${DOCKER_CONTAINER_NAME}" which cargo

//   [[ "${output}" == "/usr/local/cargo/bin/cargo" ]]
// }

// @test "${DOCKER_IMAGE_TAG} > Check Node.js path" {
//   run docker exec "${DOCKER_CONTAINER_NAME}" which node

//   [[ "${output}" == "/usr/bin/node" ]]
// }

// @test "${DOCKER_IMAGE_TAG} > Check tauri-driver path" {
//   run docker exec "${DOCKER_CONTAINER_NAME}" which tauri-driver

//   [[ "${output}" == "/usr/local/cargo/bin/tauri-driver" ]]
// }

// @test "${DOCKER_IMAGE_TAG} > Check Yarn path" {
//   run docker exec "${DOCKER_CONTAINER_NAME}" which yarn

//   [[ "${output}" == "/usr/bin/yarn" ]]
// }

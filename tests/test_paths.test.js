const { execDockerCommand } = require("./utils");

const { DOCKER_IMAGE_TAG } = process.env;

describe(DOCKER_IMAGE_TAG, () => {
  it("has expected Cargo path", async () => {
    const { stdout } = await execDockerCommand("which cargo");

    switch (true) {
      case DOCKER_IMAGE_TAG.startsWith("debian-"):
        expect(stdout.trim()).toBe("/usr/local/cargo/bin/cargo");

        return;

      case DOCKER_IMAGE_TAG.startsWith("fedora-"):
        expect(stdout.trim()).toBe("/usr/local/bin/cargo");

        return;

      default:
        throw new Error(`Missing test for "${DOCKER_IMAGE_TAG}".`);
    }
  });

  it("has expected Node.js path", async () => {
    const { stdout } = await execDockerCommand("which node");

    expect(stdout.trim()).toBe("/usr/bin/node");
  });

  it("has expected tauri-driver path", async () => {
    const { stdout } = await execDockerCommand("which tauri-driver");

    switch (true) {
      case DOCKER_IMAGE_TAG.startsWith("debian-"):
        expect(stdout.trim()).toBe("/usr/local/cargo/bin/tauri-driver");

        return;

      case DOCKER_IMAGE_TAG.startsWith("fedora-"):
        expect(stdout.trim()).toBe("/usr/local/bin/tauri-driver");

        return;

      default:
        throw new Error(`Missing test for "${DOCKER_IMAGE_TAG}".`);
    }
  });

  it("has expected Yarn path", async () => {
    const { stdout } = await execDockerCommand("which yarn");

    expect(stdout.trim()).toBe("/usr/bin/yarn");
  });
});

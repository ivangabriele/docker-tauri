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

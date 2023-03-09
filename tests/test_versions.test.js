const { execDockerCommand } = require("./utils");

const { DOCKER_IMAGE_TAG } = process.env;

const [OS_NAME, OS_CODENAME, NODE_TAG, RUST_VARIANT] = DOCKER_IMAGE_TAG.split("-");
const NODE_VERSION = NODE_TAG.slice(4);

describe(DOCKER_IMAGE_TAG, () => {
  it(`has expected OS name and codename (${OS_CODENAME})`, async () => {
    const { stdout } = await execDockerCommand("cat /etc/*release | grep PRETTY_NAME=*");

    switch (true) {
      case DOCKER_IMAGE_TAG.startsWith("debian-"):
        expect(stdout).toMatch("Debian");
        expect(stdout).toMatch(OS_CODENAME);

        return;
      case DOCKER_IMAGE_TAG.startsWith("fedora-"):
        expect(stdout).toMatch("Fedora");
        expect(stdout).toMatch(OS_CODENAME);

        return;

      default:
        throw new Error(`Missing test for "${DOCKER_IMAGE_TAG}".`);
    }
  });

  it(`has expected Rust variant (${RUST_VARIANT})`, async () => {
    const { stdout } = await execDockerCommand("rustc -V");

    if (RUST_VARIANT) {
      expect(stdout).toMatch(RUST_VARIANT);
    } else {
      expect(stdout).not.toMatch("-nightly");
    }
  });

  it(`has expected Node.js version (${NODE_VERSION})`, async () => {
    const { stdout } = await execDockerCommand("node --version");

    expect(stdout).toMatch(`v${NODE_VERSION}`);
  });
});

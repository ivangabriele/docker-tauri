const { execDockerCommand } = require("./utils");

const { DOCKER_IMAGE_TAG } = process.env;

// `debian-<codename>-<node>[-nightly]` or `fedora-<version>-<node>[-nightly]`
const DOCKER_IMAGE_TAG_MATCH = DOCKER_IMAGE_TAG.match(/^(debian|fedora)-([a-z0-9]+)-(\d+)(?:-(nightly))?$/);
if (!DOCKER_IMAGE_TAG_MATCH) {
  throw new Error(`Unexpected Docker image tag format: "${DOCKER_IMAGE_TAG}".`);
}
const [, OS_NAME, OS_RELEASE, NODE_MAJOR_VERSION, RUST_VARIANT] = DOCKER_IMAGE_TAG_MATCH;

describe(DOCKER_IMAGE_TAG, () => {
  it(`has expected OS name and release (${OS_NAME} ${OS_RELEASE})`, async () => {
    const { stdout } = await execDockerCommand("cat /etc/*release | grep PRETTY_NAME=*");

    switch (OS_NAME) {
      case "debian":
        expect(stdout).toMatch("Debian GNU/Linux");
        expect(stdout).toMatch(`(${OS_RELEASE})`);

        return;

      case "fedora":
        expect(stdout).toMatch(`Fedora Linux ${OS_RELEASE} `);

        return;

      default:
        throw new Error(`Missing test for "${DOCKER_IMAGE_TAG}".`);
    }
  });

  it(`has expected Rust variant (${RUST_VARIANT ?? "stable"})`, async () => {
    const { stdout } = await execDockerCommand("rustc -V");

    if (RUST_VARIANT) {
      expect(stdout).toMatch(`-${RUST_VARIANT}`);
    } else {
      expect(stdout).not.toMatch("-nightly");
    }
  });

  it(`has expected Node.js major version (${NODE_MAJOR_VERSION})`, async () => {
    const { stdout } = await execDockerCommand("node --version");

    expect(stdout.trim()).toMatch(new RegExp(`^v${NODE_MAJOR_VERSION}\\.`));
  });
});

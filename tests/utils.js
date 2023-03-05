const { exec } = require("child_process");
const { promisify } = require("util");

const execAsync = promisify(exec);

const { DOCKER_CONTAINER_NAME } = process.env;

module.exports.execDockerCommand = async function (dockerCommand) {
  const command = `docker exec ${DOCKER_CONTAINER_NAME} sh -c '${dockerCommand}'`;

  const { stderr, stdout } = await execAsync(command);

  return { stderr, stdout };
};

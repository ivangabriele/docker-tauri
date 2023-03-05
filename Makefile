_NAME = "ivangabriele_tauri"

build:
	docker build -f "./dockerfiles/$(_TAG).Dockerfile" -t "ivangabriele/tauri:$(_TAG)" .
build-debian-bullseye-node18:
	_TAG="debian-bullseye-node18" make build
build-debian-bullseye-node18-nightly:
	_TAG="debian-bullseye-node18-nightly" make build
build-debian-bookworm-node18:
	_TAG="debian-bookworm-node18" make build
build-debian-bookworm-node18-nightly:
	_TAG="debian-bookworm-node18-nightly" make build

run: --stop-and-remove
	make build
	docker run -dt --name "$(_NAME)" "ivangabriele/tauri:$(_TAG)"
run-debian-bullseye-node18:
	_TAG="debian-bullseye-node18" make run
run-debian-bullseye-node18-nightly:
	_TAG="debian-bullseye-node18-nightly" make run
run-debian-bookworm-node18:
	_TAG="debian-bookworm-node18" make run
run-debian-bookworm-node18-nightly:
	_TAG="debian-bookworm-node18-nightly" make run

test: run
	DOCKER_CONTAINER_NAME="$(_NAME)" DOCKER_IMAGE_TAG="$(_TAG)" npx -q jest
test-debian-bullseye-node18:
	_TAG="debian-bullseye-node18" make test
test-debian-bullseye-node18-nightly:
	_TAG="debian-bullseye-node18-nightly" make test
test-debian-bookworm-node18:
	_TAG="debian-bookworm-node18" make test
test-debian-bookworm-node18-nightly:
	_TAG="debian-bookworm-node18-nightly" make test

--stop-and-remove:
	docker stop "$(_NAME)" || true 2>/dev/null
	docker rm "$(_NAME)" || true 2>/dev/null

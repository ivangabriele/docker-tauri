_NAME = "ivangabriele_tauri"

build:
	docker build -t "ivangabriele/tauri:$(_TAG)" "./dockerfiles/$(_TAG)"
build-11-18:
	_TAG="bullseye-node18" make build
build-11-18-nightly:
	_TAG="bullseye-node18-nightly" make build

run: --stop-and-remove
	make build
	docker run -dt --name "$(_NAME)" "ivangabriele/tauri:$(_TAG)"
run-11-18:
	_TAG="bullseye-node18" make run
run-11-18-nightly:
	_TAG="bullseye-node18-nightly" make run

test: run
	DOCKER_CONTAINER_NAME="$(_NAME)" DOCKER_IMAGE_TAG="$(_TAG)" npx bats ./tests
test-11-18:
	NODE_VERSION="18" _TAG="bullseye-node18" make test
test-11-18-nightly:
	NODE_VERSION="18" _TAG="bullseye-node18-nightly" make test

--stop-and-remove:
	docker stop "$(_NAME)" || true 2>/dev/null
	docker rm "$(_NAME)" || true 2>/dev/null

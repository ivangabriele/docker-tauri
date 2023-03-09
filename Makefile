_NAME = "ivangabriele_tauri"

build:
	docker build -f "./dockerfiles/$(_TAG).Dockerfile" -t "ivangabriele/tauri:$(_TAG)" .
build-debian-bullseye-18:
	_TAG="debian-bullseye-18" make build
build-debian-bullseye-18-nightly:
	_TAG="debian-bullseye-18-nightly" make build
build-debian-bookworm-18:
	_TAG="debian-bookworm-18" make build
build-debian-bookworm-18-nightly:
	_TAG="debian-bookworm-18-nightly" make build
build-fedora-37-18:
	_TAG="fedora-37-18" make build
build-fedora-37-18-nightly:
	_TAG="fedora-37-18-nightly" make build

run: --stop-and-remove
	make build
	docker run -dt --name "$(_NAME)" "ivangabriele/tauri:$(_TAG)"
run-debian-bullseye-18:
	_TAG="debian-bullseye-18" make run
run-debian-bullseye-18-nightly:
	_TAG="debian-bullseye-18-nightly" make run
run-debian-bookworm-18:
	_TAG="debian-bookworm-18" make run
run-debian-bookworm-18-nightly:
	_TAG="debian-bookworm-18-nightly" make run
run-fedora-37-18:
	_TAG="fedora-37-18" make run
run-fedora-37-18-nightly:
	_TAG="fedora-37-18-nightly" make run

test: run
	DOCKER_CONTAINER_NAME="$(_NAME)" DOCKER_IMAGE_TAG="$(_TAG)" npx -q jest
test-debian-bullseye-18:
	_TAG="debian-bullseye-18" make test
test-debian-bullseye-18-nightly:
	_TAG="debian-bullseye-18-nightly" make test
test-debian-bookworm-18:
	_TAG="debian-bookworm-18" make test
test-debian-bookworm-18-nightly:
	_TAG="debian-bookworm-18-nightly" make test
test-fedora-37-18:
	_TAG="fedora-37-18" make test
test-fedora-37-18-nightly:
	_TAG="fedora-37-18-nightly" make test

--stop-and-remove:
	docker stop "$(_NAME)" || true 2>/dev/null
	docker rm "$(_NAME)" || true 2>/dev/null

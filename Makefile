_NAME = "ivangabriele_tauri"

build:
	docker build -f "./dockerfiles/${DOCKER_IMAGE_TAG}.Dockerfile" -t "ivangabriele/tauri:${DOCKER_IMAGE_TAG}" .

run: --stop-and-remove
	make build
	docker run -dt --name "$(_NAME)" "ivangabriele/tauri:${DOCKER_IMAGE_TAG}"

test: run
	DOCKER_CONTAINER_NAME="$(_NAME)" npx -q jest

--stop-and-remove:
	docker stop "$(_NAME)" || true 2>/dev/null
	docker rm "$(_NAME)" || true 2>/dev/null

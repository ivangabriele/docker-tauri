_NAME = "ivangabriele_tauri"

build:
	docker build -f "./dockerfiles/$(TAG).Dockerfile" -t "ivangabriele/tauri:$(TAG)" .

run: --stop-and-remove
	make build
	docker run -dt --name "$(_NAME)" "ivangabriele/tauri:$(TAG)"

test: run
	DOCKER_CONTAINER_NAME="$(_NAME)" DOCKER_IMAGETAG="$(TAG)" npx -q jest

--stop-and-remove:
	docker stop "$(_NAME)" || true 2>/dev/null
	docker rm "$(_NAME)" || true 2>/dev/null

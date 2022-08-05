test:
	DOCKER_CONTAINER_NAME=ivangabriele_tauri npx bats ./tests

build-11-18:
	docker build -t ivangabriele/tauri:bullseye-node18 ./dockerfiles/bullseye-node18

run-11-18: build-11-18
	docker stop ivangabriele_tauri || true
	docker rm ivangabriele_tauri || true
	docker run -dt --name ivangabriele_tauri ivangabriele/tauri:bullseye-node18

test-11-18: run-11-18
	NODE_VERSION=18 make test

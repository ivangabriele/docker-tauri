build-11-18:
	docker build -t ivangabriele/tauri:bullseye-node18 ./dockerfiles/bullseye-node18

test:
	npx bats ./tests

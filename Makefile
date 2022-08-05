build-11-18:
	docker build -t clamav-desktop-ci:bullseye-node18 ./dockerfiles/bullseye-node18

test:
	npx bats ./tests

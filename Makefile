build-11-18:
	docker build -t bulleyes-node18 ./dockerfiles/bulleyes-node18

test:
	bats ./tests

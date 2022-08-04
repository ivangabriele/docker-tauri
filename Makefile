build-11-18:
	docker build -t bulleye-node18 ./dockerfiles/bulleye-node18

test:
	bats ./tests

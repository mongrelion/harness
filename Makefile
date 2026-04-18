NAME = mongrelion/harness:latest

build:
	docker build -t $(NAME) .

run:
	docker run \
		--rm \
		-it $(NAME)

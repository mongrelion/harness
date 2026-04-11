NAME = mongrelion/harness:latest

build:
	docker build -t $(NAME) .

run:
	docker run \
		--rm \
		--user 1000:1000 \
		-it $(NAME)

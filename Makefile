NAME = mongrelion/oh-my-pi:latest

build:
	docker build -t $(NAME) .

run:
	docker run \
		--rm \
		-it $(NAME)

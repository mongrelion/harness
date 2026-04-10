VERSION = 14.0.4
NAME = mongrelion/oh-my-pi:$(VERSION)

build:
	docker build \
		--build-arg VERSION=$(VERSION) \
		-t $(NAME) .

run:
	docker run \
		--rm \
		-it $(NAME)

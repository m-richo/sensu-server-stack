PROJECT_NAME := $(shell basename `pwd`)
DATE_STAMP   := $(shell date +%Y%m%d-%H%M%S)

.PHONY: build
build:
	docker build -t $(PROJECT_NAME):$(DATE_STAMP) .
	docker tag $(PROJECT_NAME):$(DATE_STAMP) $(PROJECT_NAME):latest

.PHONY: run-bash
run-bash:
	docker run --rm -it -p 3000:3000 -p 5672:5672 $(PROJECT_NAME):latest /bin/bash

.PHONY: run
run:
	docker run --rm -it -p 3000:3000 -p 5672:5672 --name=$(PROJECT_NAME) $(PROJECT_NAME):latest

.PHONY: deploy
deploy:
	docker run --rm -d -p 3000:3000 -p 5672:5672 --name=$(PROJECT_NAME) $(PROJECT_NAME):latest


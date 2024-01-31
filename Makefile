BASH=bash -l -c
PROJECT=api

build:
	docker-compose build

up:
	docker-compose -p $(PROJECT) up

up-build:
	docker-compose -p $(PROJECT) up --build

stop:
	docker-compose -p $(PROJECT) stop

start:
	docker-compose -p $(PROJECT) start

ps:
	docker-compose -p $(PROJECT) ps

migrate:
	docker-compose -p $(PROJECT) exec $(PROJECT) ./manage.py migrate

makemigrations:
	docker-compose -p $(PROJECT) exec $(PROJECT) ./manage.py makemigrations

shell:
	docker-compose exec $(PROJECT) python

bash:
	docker-compose exec $(PROJECT) bash

clear_docker:
	docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) && docker rmi $(docker images -q)

.PHONY: up, shell, clear_docker

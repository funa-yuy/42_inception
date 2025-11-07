# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: miyuu <miyuu@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/11/05 15:32:04 by miyuu             #+#    #+#              #
#    Updated: 2025/11/07 15:49:56 by miyuu            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception

COMPOSE_FILE = srcs/docker-compose.yml

.PHONY: build up down stop clean fclean re

all: up

up:
	@if ! docker image inspect $(IMAGE_NAME) >/dev/null 2>&1; then \
		echo "🛠️  Image not found. Building..."; \
		docker compose -f ${COMPOSE_FILE} build; \
	fi
	docker compose -f ${COMPOSE_FILE} up -d

build:
	docker compose -f ${COMPOSE_FILE} build --no-cache

down:
	docker compose -f ${COMPOSE_FILE} down

stop:
	docker compose -f ${COMPOSE_FILE} stop

clean:
	docker compose -f ${COMPOSE_FILE} down
	docker system prune -f

fclean: clean
	docker volume prune -f
	docker network prune -f

re: down fclean build up

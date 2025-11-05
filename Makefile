# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: miyuu <miyuu@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/11/05 15:32:04 by miyuu             #+#    #+#              #
#    Updated: 2025/11/05 17:45:28 by miyuu            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception

COMPOSE_FILE = srcs/docker-compose.yml

.PHONY: build up down stop clean fclean re

all: up

build:
	docker-compose -f ${COMPOSE_FILE} build

up:
	docker-compose -f ${COMPOSE_FILE} up -d

down:
	docker-compose -f ${COMPOSE_FILE} down

stop:
	docker-compose -f ${COMPOSE_FILE} stop

clean:
	docker-compose -f ${COMPOSE_FILE} down
	docker system prune -f

fclean: clean
	docker volume prune -f
	docker network prune -f

re: down clean all

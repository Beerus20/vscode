DIR			:= ./srcs
FILENAME	:= docker-compose.yml
FILE		:= $(DIR)/$(FILENAME)

all			: build up

build		:
				docker compose -f $(FILE) build

up			:
				xhost +local:docker > /dev/null 2>&1
				docker compose -f $(FILE) up

down		:
				xhost -local:docker > /dev/null 2>&1
				docker compose -f $(FILE) down

fclean		: down
				docker compose -f $(FILE) down --rmi local

re			: fclean all

.PHONY		: all build up down fclean re
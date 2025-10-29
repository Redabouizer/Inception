COMPOSE_FILE = srcs/docker-compose.yml
DATA_PATH = /home/rbouizer/data

all: up

setup:
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb

up: setup
	@docker-compose -f $(COMPOSE_FILE) up -d

down:
	@docker-compose -f $(COMPOSE_FILE) down

clean: down
	@docker-compose -f $(COMPOSE_FILE) down -v

fclean: clean
	@docker system prune -af --volumes
	@sudo rm -rf $(DATA_PATH)/wordpress/* $(DATA_PATH)/wordpress/.[!.]*
	@sudo rm -rf $(DATA_PATH)/mariadb/* $(DATA_PATH)/mariadb/.[!.]*

re: fclean all

.PHONY: all setup up down clean fclean re

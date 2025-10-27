# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rbouizer <rbouizer@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/10/22 by rbouizer              #+#    #+#                  #
#    Updated: 2025/10/22 by rbouizer             ###   ########.fr            #
#                                                                              #
# **************************************************************************** #

NAME = inception
COMPOSE_FILE = srcs/docker-compose.yml
ENV_FILE = srcs/.env
DATA_PATH = /home/rbouizer/data

all: up

# Create necessary directories
setup:
	@echo "Creating data directories..."
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	@echo "Data directories created."

# Build Docker images
build: setup
	@echo "Building Docker images..."
	@docker-compose -f $(COMPOSE_FILE) build
	@echo "Build complete."

# Start containers
up: setup
	@echo "Starting containers..."
	@docker-compose -f $(COMPOSE_FILE) up -d
	@echo "Containers are running."

# Stop containers
down:
	@echo "Stopping containers..."
	@docker-compose -f $(COMPOSE_FILE) down
	@echo "Containers stopped."

# Stop and remove containers, networks, volumes
clean: down
	@echo "Cleaning containers, networks, and volumes..."
	@docker-compose -f $(COMPOSE_FILE) down -v
	@echo "Clean complete."

# Remove all Docker images, containers, volumes, and networks
fclean: clean
	@echo "Removing all Docker resources..."
	@docker system prune -af --volumes
	@sudo rm -rf $(DATA_PATH)/wordpress/*
	@sudo rm -rf $(DATA_PATH)/mariadb/*
	@echo "Full clean complete."

# Rebuild everything from scratch
re: fclean all

# Show container status
status:
	@docker-compose -f $(COMPOSE_FILE) ps

# Show container logs
logs:
	@docker-compose -f $(COMPOSE_FILE) logs -f

# Show NGINX logs
logs-nginx:
	@docker-compose -f $(COMPOSE_FILE) logs -f nginx

# Show WordPress logs
logs-wordpress:
	@docker-compose -f $(COMPOSE_FILE) logs -f wordpress

# Show MariaDB logs
logs-mariadb:
	@docker-compose -f $(COMPOSE_FILE) logs -f mariadb

.PHONY: all setup build up down clean fclean re status logs logs-nginx logs-wordpress logs-mariadb

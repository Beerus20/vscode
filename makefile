DIR			:= ./srcs
FILENAME	:= docker-compose.yml
FILE		:= $(DIR)/$(FILENAME)

all			: build up

build		:
				docker compose -f $(FILE) build

up			:
				xhost +local:docker > /dev/null 2>&1
				docker compose -f $(FILE) up -d

down		:
				xhost -local:docker > /dev/null 2>&1
				docker compose -f $(FILE) down

fclean		: down
				docker compose -f $(FILE) down --rmi local

re			: fclean all

run-repo	: down
				@echo "\033[1;36m╔════════════════════════════════════════════════════════╗\033[0m"
				@echo "\033[1;36m║        📦 Configuration du Repository GitHub         ║\033[0m"
				@echo "\033[1;36m╚════════════════════════════════════════════════════════╝\033[0m"
				@echo ""
				@echo "\033[1;33mFormat attendu:\033[0m username/repository.git"
				@echo "\033[1;33mExemple:\033[0m Beerus20/CPP.git"
				@echo ""
				@read -p "→ Repository name: " repo_name; \
				if [ -z "$$repo_name" ]; then \
					echo "\033[1;31m✗ Erreur: Le nom du repository ne peut pas être vide\033[0m"; \
					exit 1; \
				fi; \
				sed -i.bak "s|^PROJECT_REPO=.*|PROJECT_REPO=$$repo_name|g" $(DIR)/.env && \
				echo "" && \
				echo "\033[1;32m✓ Configuration mise à jour avec succès!\033[0m" && \
				echo "\033[1;32m✓ PROJECT_REPO = $$repo_name\033[0m" && \
				echo "" && \
				echo "\033[1;36m🚀 Lancement du container...\033[0m" && \
				echo ""
				@make all

.PHONY		: all build up down fclean re run-repo
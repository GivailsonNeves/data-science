image_postgres=postgres_container

.PHONY: up

up :
	@docker-compose up --build -d

.PHONY: down

down :
	@docker-compose down

.PHONY: prepare

prepare :
	@docker exec $(image_postgres) sh /scripts/db_scripts.sh
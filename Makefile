postgres=docker exec -i $(shell docker-compose ps -q postgres)
idempiere=docker exec -i $(shell docker-compose ps -q idempiere)

build:
	@docker-compose build

up:
	@docker-compose up -d && sleep 5

db-up:
	@docker-compose up -d postgres && sleep 5

show:
	@docker-compose ps
	@echo '\nVolumes: ' && docker volume inspect idempiere_postgres || true

down:
	@docker-compose stop

delete:
	@docker-compose rm -fsv
	@docker volume rm idempiere_postgres || true

download:
	@wget "https://razaoinfo.dl.sourceforge.net/project/idempiere/v5.1/daily-server/idempiereServer5.1Daily.gtk.linux.x86_64.zip" -O idempiere/resources/idempiere-server.zip

extract:
	@rm -rf idempiere/resources/idempiere.gtk.linux.x86_64
	@cd idempiere/resources && unzip -q -o idempiere-server.zip
	@cd idempiere/resources/idempiere.gtk.linux.x86_64/idempiere-server/data/seed/ && jar xvf Adempiere_pg.jar

import-db:
	@$(postgres) psql -q -U postgres -c "CREATE ROLE adempiere SUPERUSER LOGIN PASSWORD 'adempiere'"
	@$(postgres) createdb --template=template0 -E UNICODE -O adempiere -U adempiere idempiere
	@$(postgres) psql -q -d idempiere -U adempiere -c "ALTER ROLE adempiere SET search_path TO adempiere, pg_catalog"
	@$(postgres) psql -q -d idempiere -U adempiere -c 'CREATE EXTENSION "uuid-ossp"'
	@cat idempiere/resources/idempiere.gtk.linux.x86_64/idempiere-server/data/seed/Adempiere_pg.dmp | $(postgres) psql -q -d idempiere -U adempiere

config:
	@cd idempiere/resources/idempiere.gtk.linux.x86_64/idempiere-server && echo '\n\n\n\n\n\n\n\n\n0.0.0.0\n\n\n\n\n0.0.0.0\n\n\n\n\npostgres\n0.0.0.0\n\n\n\n\n' | ./console-setup-alt.sh

log:
	@$(idempiere) sh -c 'cd log && tail -f $$(ls -1 | tail -1)'

console:
	@docker-compose exec idempiere sh

init: delete extract db-up import-db config down build

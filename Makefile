-include .env
export

download:
	@ wget "https://ufpr.dl.sourceforge.net/project/idempiere/v$(IDEMPIERE_VERSION)/server/idempiereServer$(IDEMPIERE_VERSION).gtk.linux.x86_64.zip" -O idempiere-server.zip
	@ make unzip

unzip:
	@ rm -rf idempiere-server
	@ unzip -q -o idempiere-server.zip
	@ mv idempiere.gtk.linux.x86_64/idempiere-server idempiere-server
	@ rm -rf idempiere.gtk.linux.x86_64

build:
	@ docker build -t idempiere:$(IDEMPIERE_VERSION) .

bash:
	@ docker run -it --rm idempiere:$(IDEMPIERE_VERSION) bash

run:
	@ docker stack deploy -c idempiere.yml idempiere

stop:
	@ docker stack rm idempiere

log:
	@ docker service logs -f idempiere_idempiere

init:
	@ docker network create --driver overlay --scope swarm idempiere
	@ docker volume create idempiere


run-db:
	docker stack deploy -c postgres.yml postgres

stop-db:
	docker stack rm postgres

status-db:
	docker stack services postgres

import-db:
	@ cd $(shell pwd)/idempiere-server/data/seed/ && jar xvf Adempiere_pg.jar
	@ docker run --rm -it --network host -e PGPASSWORD=$(DB_ADMIN_PASS) postgres:9.6 psql -h localhost -q -U postgres -c "CREATE ROLE adempiere SUPERUSER LOGIN PASSWORD 'adempiere'"
	@ docker run --rm -it --network host -e PGPASSWORD=$(DB_PASS) postgres:9.6 createdb -h localhost --template=template0 -E UNICODE -O adempiere -U adempiere idempiere
	@ docker run --rm -it --network host -e PGPASSWORD=$(DB_PASS) postgres:9.6 psql -h localhost -d idempiere -U adempiere -c "ALTER ROLE adempiere SET search_path TO adempiere, pg_catalog"
	@ docker run --rm -it --network host -e PGPASSWORD=$(DB_PASS) postgres:9.6 psql -h localhost -d idempiere -U adempiere -c 'CREATE EXTENSION "uuid-ossp"'
	@ cat $(shell pwd)/idempiere-server/data/seed/Adempiere_pg.dmp | docker run --rm -i --network host -e PGPASSWORD=adempiere postgres:9.6 psql -h localhost -d idempiere -U adempiere

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
	@ docker stack deploy -c docker-stack.yml idempiere

stop:
	@ docker stack rm idempiere

log:
	@ docker service logs -f idempiere_idempiere

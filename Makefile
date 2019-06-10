download:
	@ wget "https://ufpr.dl.sourceforge.net/project/idempiere/v6.2/server/idempiereServer6.2.gtk.linux.x86_64.zip" -O idempiere-server.zip
	@ make unzip

unzip:
	@ rm -rf idempiere-server
	@ unzip -q -o idempiere-server.zip
	@ mv idempiere.gtk.linux.x86_64/idempiere-server idempiere-server
	@ rm -rf idempiere.gtk.linux.x86_64

build:
	@ docker build -t idempiere:6.2 -t idempiere:latest .

bash:
	@ docker run -it --rm idempiere:6.2 bash

run:
	@ docker stack deploy -c docker-stack.yml idempiere

stop:
	@ docker stack rm idempiere

log:
	@ docker service logs -f idempiere_idempiere

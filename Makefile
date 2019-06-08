-include .env
export

download:
	@ wget "https://ufpr.dl.sourceforge.net/project/idempiere/v$(IDEMPIERE_VERSION)/server/idempiereServer$(IDEMPIERE_VERSION).gtk.linux.x86_64.zip" -O resources/idempiere-server.zip
	@ make unzip

unzip:
	@ rm -rf resources/idempiere.gtk.linux.x86_64
	@ cd resources && unzip -q -o idempiere-server.zip
	@ cd resources/idempiere.gtk.linux.x86_64/idempiere-server/data/seed/ && jar xvf Adempiere_pg.jar

build:
	@ docker build -t idempiere:$(IDEMPIERE_VERSION) .

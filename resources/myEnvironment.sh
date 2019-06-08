#!/bin/sh
#
# myEnvironment defines the variables used for idempiere
# Do not edit directly - use RUN_setup
#
# $Id: myEnvironmentTemplate.sh,v 1.12 2005/02/21 03:17:21 jjanke Exp $

echo Setting myEnvironment ....
#	Clients only needs
#		IDEMPIERE_HOME
#		JAVA_HOME
#	Server install needs to change
#		ADEMPIERE_DB_NAME	(for Oracle)
#		passwords
#
#	For a HTML browser, idempiere will call "netscape <targetURL>"
#	If not in the path, provide a link called netscape to your browser

# 	Homes ...
IDEMPIERE_HOME=/idempiere-server
export IDEMPIERE_HOME
JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
export JAVA_HOME

#	Database ...
ADEMPIERE_DB_SERVER=postgres
export ADEMPIERE_DB_SERVER
ADEMPIERE_DB_USER=adempiere
export ADEMPIERE_DB_USER
ADEMPIERE_DB_PASSWORD=adempiere
export ADEMPIERE_DB_PASSWORD
ADEMPIERE_DB_URL=jdbc:postgresql://postgres:5432/idempiere
export ADEMPIERE_DB_URL
ADEMPIERE_DB_PORT=5432
export ADEMPIERE_DB_PORT

#	Oracle Specifics ...
ADEMPIERE_DB_PATH=postgresql
export ADEMPIERE_DB_PATH
ADEMPIERE_DB_NAME=idempiere
export ADEMPIERE_DB_NAME
ADEMPIERE_DB_SYSTEM=postgres
export ADEMPIERE_DB_SYSTEM

#	Homes(2)
ADEMPIERE_DB_HOME=$IDEMPIERE_HOME/utils/$ADEMPIERE_DB_PATH
export ADEMPIERE_DB_HOME

#	Apps Server
ADEMPIERE_APPS_SERVER=0.0.0.0
export ADEMPIERE_APPS_SERVER
ADEMPIERE_WEB_PORT=8080
export ADEMPIERE_WEB_PORT
ADEMPIERE_JNP_PORT=@ADEMPIERE_JNP_PORT@
export ADEMPIERE_JNP_PORT
#	SSL Settings - see jboss/server/adempiere/deploy/jbossweb.sar/META-INF/jboss-service.xml
ADEMPIERE_SSL_PORT=8443
export ADEMPIERE_SSL_PORT
ADEMPIERE_KEYSTORE=/idempiere-server/jettyhome/etc/keystore
export ADEMPIERE_KEYSTORE
ADEMPIERE_KEYSTOREPASS=myPassword
export ADEMPIERE_KEYSTOREPASS

#	Java
ADEMPIERE_JAVA=$JAVA_HOME/bin/java
export ADEMPIERE_JAVA
IDEMPIERE_JAVA_OPTIONS="-Xms64M -Xmx512M -DIDEMPIERE_HOME=$IDEMPIERE_HOME"
export IDEMPIERE_JAVA_OPTIONS

if [ $DOLLAR$# -eq 0 ]
  then
    cp $IDEMPIERE_HOME/utils/myEnvironment.sh $IDEMPIERE_HOME/utils/myEnvironment.sav
fi

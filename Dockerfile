FROM openjdk:11
COPY resources/idempiere.gtk.linux.x86_64/idempiere-server /idempiere-server
COPY resources/idempiereEnv.properties /idempiere-server/idempiereEnv.properties
COPY resources/myEnvironment.sh /idempiere-server/utils/myEnvironment.sh
COPY resources/idempiere.properties /idempiere-server/idempiere.properties
COPY resources/idempiere-server.sh /idempiere-server/idempiere-server.sh
WORKDIR /idempiere-server
EXPOSE 8080 8443 12612
ENTRYPOINT ["sh"]
CMD ["idempiere-server.sh"]

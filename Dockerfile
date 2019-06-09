FROM openjdk:11

RUN apt-get update ; apt-get install -y --no-install-recommends postgresql-client-9.6 ; rm -rf /var/lib/apt/lists/*
COPY /idempiere-server /idempiere-server
COPY docker-entrypoint.sh /idempiere-server/docker-entrypoint.sh
COPY idempiere-server.sh /idempiere-server/idempiere-server.sh
RUN ln -s /idempiere-server/idempiere-server.sh /usr/bin/idempiere
WORKDIR /idempiere-server

EXPOSE 8080 8443 12612
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["idempiere"]

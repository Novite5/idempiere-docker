FROM openjdk:11
COPY /idempiere-server /idempiere-server
COPY docker-entrypoint.sh /idempiere-server/docker-entrypoint.sh
RUN ln -s /idempiere-server/idempiere-server.sh /usr/bin/idempiere
WORKDIR /idempiere-server
EXPOSE 8080 8443 12612
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["idempiere"]

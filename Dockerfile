FROM alpine:latest
LABEL maintainer georgegeorgulas@gmail.com
RUN         apk update && apk upgrade && apk add --update bash curl dcron util-linux && rm -rf /var/cache/apk/*
COPY           crontab.txt /crontab.txt
COPY env_secrets_expand.sh /env_secrets_expand.sh
COPY              entry.sh /entry.sh
COPY          updatedns.sh /updatedns.sh
ENV DREAMHOST_API_KEY DOCKER-SECRET->DREAMHOST_API_KEY
ENV RECORD_TO_UPDATE DOCKER-SECRET->RECORD_TO_UPDATE
ENV RECORD_TYPE DOCKER-SECRET->RECORD_TYPE
RUN         chmod 755 /updatedns.sh && chmod 755 /entry.sh && chmod 755 /env_secrets_expand.sh && /usr/bin/crontab /crontab.txt
ENTRYPOINT ["/entry.sh"]

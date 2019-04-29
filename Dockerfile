FROM alpine:latest
LABEL maintainer georgegeorgulas@gmail.com

# Prepare apk
RUN         apk update && \
# Upgrade any underlying packages missed by our base image in the name of security best practices
            apk upgrade && \
# Install our required packages
            apk add --update bash curl dcron && \
# Clean up the chaff from apk for smaller final layer size
            rm -rf /var/cache/apk/*

# add files
COPY           crontab.txt /crontab.txt
COPY env_secrets_expand.sh /env_secrets_expand.sh
COPY              entry.sh /entry.sh
COPY          updatedns.sh /updatedns.sh

# Declare DreamHost API environment variables as secrets
ENV DREAMHOST_API_KEY DOCKER-SECRET->DREAMHOST_API_KEY
ENV RECORD_TO_UPDATE DOCKER-SECRET->RECORD_TO_UPDATE
ENV RECORD_TYPE DOCKER-SECRET->RECORD_TYPE
ENV DOMAIN DOCKER-SECRET->DOMAIN

# Make scripts executable
RUN         chmod 755 /updatedns.sh && \
            chmod 755 /entry.sh && \
            chmod 755 /env_secrets_expand.sh && \
# Load crontab file into crontab
            /usr/bin/crontab /crontab.txt

# Launch the container with our shell script to both update once and launch crontab
ENTRYPOINT ["/entry.sh"]

#!/bin/bash

CACHED_IP_ADDRESS=""
#DOMAIN=""
#DREAMHOST_API_KEY=""
#DREAMHOST_API_URL=""
#RECORD_TO_UPDATE=""
#RECORD_TYPE=""

source /env_secrets_expand.sh

IFS=$'\t'

DREAMHOST_API_URL="https://api.dreamhost.com/"


if [ ! -z "${DREAMHOST_API_KEY}" ]; then
    MY_IP_ADDRESS=$(curl -s "https://api.ipify.org")

    while IFS=$'\t' read -r line; do
        DH_RECORD=$(echo "${line}" | cut -d$'\t' -f3)
        if [ "${DH_RECORD}" == "${RECORD_TO_UPDATE}" ]; then
            CACHED_IP_ADDRESS=$(echo "${line}" | cut -d$'\t' -f5)
        fi
    curl -s "${DREAMHOST_API_URL}?key=${DREAMHOST_API_KEY}&cmd=dns-list_records"
    done

    if [ -z "${CACHED_IP_ADDRESS}" ]; then
        curl -s "${DREAMHOST_API_URL}?key=${DREAMHOST_API_KEY}&cmd=dns-add_record&record=${RECORD_TO_UPDATE}&type=A&value=${MY_IP_ADDRESS}"
    elif [ ! -z "${CACHED_IP_ADDRESS}" ] && [ "${MY_IP_ADDRESS}" != "${CACHED_IP_ADDRESS}" ]; then
        curl -s "${DREAMHOST_API_URL}?key=${DREAMHOST_API_KEY}&cmd=dns-remove_record&record=${RECORD_TO_UPDATE}&type=A&value=${CACHED_IP_ADDRESS}"
        curl -s "${DREAMHOST_API_URL}?key=${DREAMHOST_API_KEY}&cmd=dns-add_record&record=${RECORD_TO_UPDATE}&type=$A&value=${MY_IP_ADDRESS}"
    fi
else
    echo "DreamHost DNS not configured."
fi
#!/bin/bash
source /env_secrets_expand.sh
MY_IP_ADDRESS=`curl -s "https://api.ipify.org"`
DREAMHOST_API_URL="https://api.dreamhost.com/"
LIST='dns-list_records'
REMOVE='dns-remove_record'
ADD='dns-add_record'
DATE_AND_TIME=`date`
LIST_UUID=`uuidgen`
LIST_LINK="${DREAMHOST_API_URL}?key=${DREAMHOST_API_KEY}&unique_id=${LIST_UUID}&cmd=${LIST}"
LIST_RESPONSE=`curl -s -X GET ${LIST_LINK}`
echo "$LIST_REPSONSE"
STORED_IP=`echo "${LIST_RESPONSE}" | grep ${RECORD_TO_UPDATE} | awk '{ print $5 }' | grep '[0-9]'`
if [ "${MY_IP_ADDRESS}" == "${STORED_IP}" ]; then
  exit 0
fi
REMOVE_UUID=`uuidgen`
REMOVE_LINK="${DREAMHOST_API_URL}?key=${DREAMHOST_API_KEY}&unique_id=${REMOVE_UUID}&cmd=${REMOVE}&record=${RECORD_TO_UPDATE}&type=${RECORD_TYPE}&value=${STORED_IP}"
REMOVE_RESPONSE=`curl -s -X GET ${REMOVE_LINK}`
echo "${REMOVE_RESPONSE}"
ADD_UUID=`uuidgen`
ADD_LINK="${DREAMHOST_API_URL}?key=${DREAMHOST_API_KEY}&unique_id=${ADD_UUID}&cmd=${ADD}&record=${RECORD_TO_UPDATE}&type=${RECORD_TYPE}&value=${MY_IP_ADDRESS}&comment=${DATE_AND_TIME}"
ADD_RESPONSE=`curl -s -X GET ${ADD_LINK}`
echo "${ADD_RESPONSE}"

#!/bin/bash

source /env_secrets_expand.sh

# gets current WAN IP address
MY_IP_ADDRESS=`curl -s "https://api.ipify.org"`

# URL of Dreamhost DNS API
DREAMHOST_API_URL="https://api.dreamhost.com/"

# API commands
LIST='dns-list_records'
REMOVE='dns-remove_record'
ADD='dns-add_record'

DATE_AND_TIME=`date`
echo "NEW IP: ${MY_IP_ADDRESS}"


# List records
LIST_UUID=`uuidgen`
LIST_LINK="${DREAMHOST_API_URL}?key=${DREAMHOST_API_KEY}&unique_id=${LIST_UUID}&cmd=${LIST}"
LIST_RESPONSE=`curl -s -X GET ${LIST_LINK}`
echo "getting contents of DreamHost DNS entries with $LIST_LINK"
echo "$LIST_REPSONSE"

# Check IP of existing record
echo "comparing DreamHost IP to my current IP"
STORED_IP=`echo "${LIST_RESPONSE}" | grep ${RECORD_TO_UPDATE} | awk '{ print $5 }' | grep '[0-9]'`
echo "IP of ${RECORD_TO_UPDATE} on DreamHost: ${STORED_IP}"

# Check if NEW/OLD IPs match
if [ "${MY_IP_ADDRESS}" == "${STORED_IP}" ]; then
  echo "IP address has not been changed since last update.  No update necessary."
  exit 0
fi

echo "IP addresses do not match, beginning update"

# Different IP remove/update

# Remove record 
REMOVE_UUID=`uuidgen`
echo "remove entry UUID: ${REMOVE_UUID}"
REMOVE_LINK="${DREAMHOST_API_URL}?key=${DREAMHOST_API_KEY}&unique_id=${REMOVE_UUID}&cmd=${REMOVE}&record=${RECORD_TO_UPDATE}&type=${RECORD_TYPE}&value=${STORED_IP}"
REMOVE_RESPONSE=`curl -s -X GET ${REMOVE_LINK}`
echo "removing old entry with URL ${REMOVE_LINK}"
echo "${REMOVE_RESPONSE}"

# Add record
ADD_UUID=`uuidgen`
echo "add entry UUID: ${ADD_UUID}"
ADD_LINK="${DREAMHOST_API_URL}?key=${DREAMHOST_API_KEY}&unique_id=${ADD_UUID}&cmd=${ADD}&record=${RECORD_TO_UPDATE}&type=${RECORD_TYPE}&value=${MY_IP_ADDRESS}&comment=${DATE_AND_TIME}"
ADD_RESPONSE=`curl -s -X GET ${ADD_LINK}`
echo "adding new entry with ${ADD_LINK}"
echo "${ADD_RESPONSE}"

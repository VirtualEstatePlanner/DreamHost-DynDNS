#!/bin/sh

# check current IP and correct if necessary
/updatedns.sh

# start cron
/usr/sbin/crond -f -l 8
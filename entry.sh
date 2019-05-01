#!/bin/sh
/updatedns.sh
/usr/sbin/crond -f -l 8

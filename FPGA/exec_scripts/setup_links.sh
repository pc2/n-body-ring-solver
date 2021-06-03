#!/bin/bash

source modules.sh
HOSTNAME=$(< /etc/hostname)
HOSTNAME=${HOSTNAME#*-}
SLEEP_TIME=$(echo $HOSTNAME | sed 's/^0*//')
SLEEP_TIME=$(( 120*SLEEP_TIME ))
echo "fpga-$HOSTNAME sleeping for $SLEEP_TIME"
sleep $SLEEP_TIME
echo "Diagnosing fpga-$HOSTNAME"
aocl diagnose

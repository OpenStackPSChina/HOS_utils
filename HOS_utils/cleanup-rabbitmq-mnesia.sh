#!/bin/bash
# clean rabbitmq mnesia database

HOSTNAME=$(hostname)
MNESIA_DIR="/var/lib/rabbitmq/mnesia/rabbit@${HOSTNAME}"

P_DIR="${MNESIA_DIR}/msg_store_persistent"
T_DIR="${MNESIA_DIR}/msg_store_transient"
Q_DIR="${MNESIA_DIR}/queues"
Q_SUB_DIR=${Q_DIR}/$(ls ${Q_DIR})

function cleanup() {
	DIR=$1
	cd $DIR
	echo "PS - cleaning up \"$DIR\" ... "
	find ./ -ctime +0 | xargs rm -f
	}

# stop rabbitmq before cleanup
# rabbitmqctl stop_app
#
cleanup $P_DIR
cleanup $T_DIR

#Cause there is sub dir under $Q_DIR, so cleanup may not working
#cleanup $Q_DIR
cleanup $Q_SUB_DIR

# stop rabbitmq
rabbitmqctl stop_app
# start rabbitmq after cleanup
rabbitmqctl start_app
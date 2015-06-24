#!/bin/bash
# vim: set sw=4 ts=4 et:

function setup-iptables() {
	RETRY_CNT=$1
    RETRY_INTERVAL=$2
	
	EXT_IP=$(ip addr show eth0 | awk '/inet / {ip = substr($2,1,index($2,"/")-1); printf "%s",ip;}')

	IPTABLES_RULE=$(iptables -t nat -S | awk '/-A POSTROUTING -s 192.168.130.0\/24 -d 15.210.68.0\/24 -j SNAT --to-source /')
	IPTABLES_IP=$(iptables -t nat -S | awk '/-A POSTROUTING -s 192.168.130.0\/24 -d 15.210.68.0\/24 -j SNAT --to-source / { print $10 }')

	if [[ -n ${IPTABLES_RULE} && ${IPTABLES_IP} = ${EXT_IP} ]]; then
		echo "PS - SNAT is OK for UC & OC nodes"
	else
	    for ((CNT=1; CNT<=${RETRY_CNT}; CNT++ )); do
			IPTABLES_IP_NEW=$(iptables -t nat -S | awk '/-A POSTROUTING -s 192.168.130.0\/24 -d 15.210.68.0\/24 -j SNAT --to-source / { print $10 }')
            if [[ ${IPTABLES_IP_NEW} != ${EXT_IP}  ]]; then
				echo "PS - Deleting old rules"
				iptables -t nat -D POSTROUTING -s 192.168.130.0\/24 -d 15.210.68.0\/24 -j SNAT --to-source ${IPTABLES_IP}
				echo "PS - Adding new rules"
				iptables -t nat -A POSTROUTING -s 192.168.130.0\/24 -d 15.210.68.0\/24 -j SNAT --to-source ${EXT_IP}
				# extend interval
                #((RETRY_INTERVAL=RETRY_INTERVAL+2))
				# sleep
				sleep $RETRY_INTERVAL
            fi
        done
	fi
	}

setup-iptables 5 3
#!/bin/bash
function source_stackrc()
{
    RC_FILE=$1
	if [[ -f ${RC_FILE} ]]; then
	    source ${RC_FILE}
	else
		echo "ERROR: ${RC_FILE} is not found!"
		echo "       Script terminated!"
		exit 1
	fi
}

function print_result()
{
    printf "%-56s \t %-16s \t %-16s \t %-16s \t %-16s\n" $1 $2 $3 $4 $5
}

function print_nodes_info()
{
	for NODE in $(nova list | awk '/ACTIVE/ {print $4}'); do
		NODE_NAME=$NODE
		IRONIC_ID=$(nova show $NODE | awk '/hypervisor_hostname/ {print $4}')
		NODE_IP=$(nova show $NODE | awk '/ctlplane network/ {print $5}')
		NODE_IPMI_IP=$(ironic node-show $IRONIC_ID | awk -F \' '/ipmi_address/ {print $4}')
		NODE_IPMI_USER=$(ironic node-show $IRONIC_ID | awk -F \' '/ipmi_username/ {print $8}')
		NODE_IPMI_PASS=$(ironic node-show $IRONIC_ID | awk -F \' '/ipmi_password/ {print $4}')
		print_result $NODE_NAME $NODE_IP $NODE_IPMI_IP $NODE_IPMI_USER $NODE_IPMI_PASS
	done
}
# For undercloud
print_result "HOSTNAME" "IP_ADDR" "IPMI_IP" "IPMI_USERNAME" "IPMI_PASSWORD"

source_stackrc "/root/stackrc"
print_nodes_info

# For overcloud
source_stackrc "/root/undercloudrc"
print_nodes_info
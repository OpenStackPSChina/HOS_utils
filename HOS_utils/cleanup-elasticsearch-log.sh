#!/bin/bash
#
# Run this script daily to remove elasticsearch history data one week ago

CLEAN_DATE=$(date +%Y.%m.%d --date 'last week')
LOGSTASH_DIR="logstash-${CLEAN_DATE}"
ELASTIC_DIR="/mnt/state/var/lib/elasticsearch/elasticsearch/nodes/0/indices"
CLEAN_TARGET="${ELASTIC_DIR}/${LOGSTASH_DIR}"

if [[ -e "${CLEAN_TARGET}" ]]; then
    rm -rf ${CLEAN_TARGET}
    echo "PS -- History data of \"${CLEAN_DATE}\" is found, and removed."
else
    echo "PS -- History data of \"${CLEAN_DATE}\" is not found. Did nothing."
fi

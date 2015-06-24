#!/bin/bash
# set logrotate to specific time
MAXSIZE='50M'
ROTATE='5'

cd /etc/logrotate.d
# generate ironic conf
IRONIC_CFG='/etc/logrotate.d/ironic'
echo "# Note maxsize ${MAXSIZE}, rotate ${ROTATE}"  > ${IRONIC_CFG}
echo "/var/log/ironic/ironic-api.log {"            >> ${IRONIC_CFG}
echo "    daily"                                   >> ${IRONIC_CFG}
echo "    compress"                                >> ${IRONIC_CFG}
echo "    delaycompress"                           >> ${IRONIC_CFG}
echo "    missingok"                               >> ${IRONIC_CFG}
echo "    copytruncate"                            >> ${IRONIC_CFG}
echo "    maxsize ${MAXSIZE}"                      >> ${IRONIC_CFG}
echo "    rotate ${ROTATE}"                        >> ${IRONIC_CFG}
echo "    create 640 ironic ironic"                >> ${IRONIC_CFG}
echo "}"                                           >> ${IRONIC_CFG}
echo "/var/log/ironic/ironic-conductor.log {"      >> ${IRONIC_CFG}
echo "    daily"                                   >> ${IRONIC_CFG}
echo "    compress"                                >> ${IRONIC_CFG}
echo "    delaycompress"                           >> ${IRONIC_CFG}
echo "    missingok"                               >> ${IRONIC_CFG}
echo "    copytruncate"                            >> ${IRONIC_CFG}
echo "    maxsize ${MAXSIZE}"                      >> ${IRONIC_CFG}
echo "    rotate ${ROTATE}"                        >> ${IRONIC_CFG}
echo "    create 640 ironic ironic"                >> ${IRONIC_CFG}
echo "}"                                           >> ${IRONIC_CFG}  

# set all logrotate conf to maxsize ${MAXSIZE}, rotate ${ROTATE}
cd /etc/logrotate.d
for LG_CFG in `ls`; do
    sed "s/maxsize.*/maxsize ${MAXSIZE}/g"  -i ${LG_CFG}
	sed "s/rotate.*/rotate ${ROTATE}/g"     -i ${LG_CFG}
done

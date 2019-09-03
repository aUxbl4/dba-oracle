#!/bin/bash

if [ $# != 3 ]; then
        echo "----------------"
        echo "Usage:   ./rman_create_offline_restore_point.sh <ORA_ENV> <RP_NAME_PREFIX> <SM_REQUEST>"
        echo "Example: ./rman_create_offline_restore_point.sh .profile.11204.testdb RP ZNO12345678"
        echo "----------------"
        exit;
else

ORA_ENV=$1
RP_NAME_PREFIX=$2
SM_REQUEST=$3

. ${HOME}/${ORA_ENV}

rman target / log=$HOME/dba/${ORACLE_SID}/rman_create_offline_restore_point_${SM_REQUEST}.log << EOF
shutdown immediate;
startup mount;
create restore point ${RP_NAME_PREFIX}_OFFLINE_${SM_REQUEST} guarantee flashback database;
list restore point all;
alter database open;
exit;
EOF
fi

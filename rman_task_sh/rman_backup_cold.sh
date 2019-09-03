#!/bin/sh

if [ $# != 3 ]; then
        echo "----------------"
        echo "Usage:   ./rman_backup_cold.sh <ORA_ENV> <BACKUP_LOCATION> <SM_REQUEST>"
        echo "Example: ./rman_backup_cold.sh .profile.121024.apexxd01 /u01 IM26677589"
        echo "----------------"
        exit;
else

ORA_ENV=$1
BACKUP_LOCATION=$2
SM_REQUEST=$3

. ${HOME}/${ORA_ENV}
BACKUP_DIR=${BACKUP_LOCATION}/backup/${ORACLE_SID}/${SM_REQUEST}
mkdir -p $HOME/dba/${ORACLE_SID}
mkdir -p ${BACKUP_DIR}
 
rman target / log=$HOME/dba/${ORACLE_SID}/rman_backup_cold_${SM_REQUEST}.log << EOF
shutdown immediate;
startup mount;
run {
crosscheck backup;
delete noprompt expired backup;
allocate channel xc01 device type disk format '${BACKUP_DIR}/xc01_cold_%d%T%U';
allocate channel xc02 device type disk format '${BACKUP_DIR}/xc02_cold_%d%T%U';
allocate channel xc03 device type disk format '${BACKUP_DIR}/xc03_cold_%d%T%U';
allocate channel xc04 device type disk format '${BACKUP_DIR}/xc04_cold_%d%T%U';
backup as compressed backupset filesperset 2 database tag=${SM_REQUEST};
backup current controlfile format '${BACKUP_DIR}/curr_ctrl_%d%T%U' tag=${SM_REQUEST};
}

shutdown immediate;
startup;
exit;
EOF
fi

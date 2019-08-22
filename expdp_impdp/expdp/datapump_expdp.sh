#!/bin/sh


# "DATAPUMP EXPDP"
# "Create by: Korolkov A.S."
# "Date: 16.08.2019"
# "Version: 1.00"
# "Usage:   ./datapump_expdp_schemas.sh <ORACLE_ENV_FILE> <DATAPUMP_PATH> <DATAPUMP_UNIQUE_ID> <DATAPUMP_PARALLEL> <DATAPUMP_SCHEMAS>
# "Example: ./datapump_expdp_schemas.sh .profile.12201.testdb /xnfsdata/datapump D_00_000_00_001 2 TEST1,TEST2"
 
 
 
if [ $# -lt 5 ]; then
echo "############################################################################################################################################"
echo "#                                                                                                                                          #"
echo "#    Usage:   ./datapump_expdp_schemas.sh <ORACLE_ENV_FILE> <DATAPUMP_PATH> <DATAPUMP_UNIQUE_ID> <DATAPUMP_PARALLEL> <DATAPUMP_SCHEMAS>    #"
echo "#    Example: ./datapump_expdp_schemas.sh .profile.12201.testdb /xnfsdata/datapump D_00_000_00_001 2 TEST1,TEST2                           #"
echo "#                                                                                                                                          #"
echo "############################################################################################################################################"
exit;
else

DATAPUMP_DIR="JOB_DATAPUMP_DIR"
ORACLE_ENV_FILE=$1
DATAPUMP_PATH=$2
DATAPUMP_UNIQUE_ID=$3
DATAPUMP_PARALLEL="parallel="$4
DATAPUMP_SCHEMAS="schemas="$5

. ${HOME}/${ORACLE_ENV_FILE}

sqlplus / as sysdba << EOF
create or replace directory ${DATAPUMP_DIR} as '${DATAPUMP_PATH}';
EOF

expdp \'/ as sysdba\' directory=${DATAPUMP_DIR} dumpfile=${DATAPUMP_UNIQUE_ID}_%U.dmp logfile=${DATAPUMP_UNIQUE_ID}.expdp.log ${DATAPUMP_PARALLEL} ${DATAPUMP_SCHEMAS} compression=all flashback_time=sysdate
 
sqlplus / as sysdba << EOF
drop directory ${DATAPUMP_DIR};
EOF

fi

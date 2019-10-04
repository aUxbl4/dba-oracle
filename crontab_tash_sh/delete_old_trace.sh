#!/usr/bin/sh
 
if [ $# -lt 2 ]; then
   echo "#################################################################################"
   echo "#                                                                               #"
   echo "#    Usage:   ./delete_old_traces.sh <RDBMS_DIR> <DEPTH>                        #"
   echo "#    Example: ./delete_old_traces.sh /oracle/app/oracle/product/base11204 14    #"
   echo "#                                                                               #"
   echo "#################################################################################"
   exit 1;
else

RDBMS_DIR=$1
DEPTH=$2

find ${RDBMS_DIR} -name *.aud -mtime +${DEPTH} | xargs rm > /dev/null 2>&1
find ${RDBMS_DIR} -name *.trc -mtime +${DEPTH} | xargs rm > /dev/null 2>&1
find ${RDBMS_DIR} -name *.trm -mtime +${DEPTH} | xargs rm > /dev/null 2>&1
find ${RDBMS_DIR} -name core_* -type d -mtime +${DEPTH} | xargs rm -rf > /dev/null 2>&1
find ${RDBMS_DIR} -name log_*.xml -mtime +${DEPTH} | xargs rm > /dev/null 2>&1
find ${RDBMS_DIR} -name log_*.xml -mtime +${DEPTH} | grep "diag/tnslsnr" | xargs rm > /dev/null 2>&1

fi

#!/usr/bin/sh 

if [ $# -lt 3 ]; then
   echo "############################################################################################################################"
   echo "#                                                                                                                          #"
   echo "#    Usage:   ./rotate_logs.sh <WORK_DIR> <LOGFILE_NAME> <DEPTH>                                                           #"
   echo "#    Example: ./rotate_logs.sh /xoracle/app/oracle/product/base11204/diag/tnslsnr/testdb/listener/trace listener.log 14    #"
   echo "#                                                                                                                          #"
   echo "############################################################################################################################"
   exit 1;
else
 
WORK_DIR_DIR=$1
LOGFILE_NAME=$2
DEPTH=$3
DATE=`date +%Y%m%d%M%S`

cp ${WORK_DIR_DIR}/${LOGFILE_NAME} ${WORK_DIR_DIR}/${DATE}_${LOGFILE_NAME}
> ${WORK_DIR_DIR}/${LOGFILE_NAME}

echo "############################################################################################################################" >> ${WORK_DIR_DIR}/${LOGFILE_NAME}
echo "" >> ${WORK_DIR_DIR}/${LOGFILE_NAME}
echo "Rotated at ${DATE} by rotate_logs.sh" >> ${WORK_DIR_DIR}/${LOGFILE_NAME}
echo "" >> ${WORK_DIR_DIR}/${LOGFILE_NAME}
echo "############################################################################################################################" >> ${WORK_DIR_DIR}/${LOGFILE_NAME}

gzip ${WORK_DIR_DIR}/${DATE}_${LOGFILE_NAME}
find ${WORK_DIR_DIR} -name "*_${LOGFILE_NAME}.gz" -mtime +${DEPTH} | xargs rm
fi

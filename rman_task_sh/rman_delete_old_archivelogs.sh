#!/bin/sh
 
while getopts "e:d:f" opt
  do
case $opt in
      e) ORA_ENV=$OPTARG
         echo Oracle environment is ${ORA_ENV}
         ;;
      d) DEPTH=$OPTARG
         echo RMAN archivelog keep depth is ${DEPTH}
         ;;
      f) FORCE_OPTION=force
         echo RMAN deletion option is ${FORCE_OPTION}
         ;;
    esac
done
 
if [ -z ${ORA_ENV} ]; then
echo "Usage: rman_delete_old_archivelogs.sh -e <ORA_ENV> -d <DEPTH> -f <FORCE_OPTION> (optional)"
exit 1;
else
if [ -z ${DEPTH} ]; then
echo "Usage: rman_delete_old_archivelogs.sh -e <ORA_ENV> -d <DEPTH> -f <FORCE_OPTION> (optional)"
exit 1;
else
 
. ${HOME}/${ORA_ENV}
 
rman target / log=${HOME}/dba/${ORACLE_SID}/rman_delete_old_archivelogs.log << EOF
crosscheck archivelog all;
delete noprompt expired archivelog all;
delete noprompt ${FORCE_OPTION} archivelog all completed before 'sysdate-${DEPTH}';
exit;
EOF
fi
fi

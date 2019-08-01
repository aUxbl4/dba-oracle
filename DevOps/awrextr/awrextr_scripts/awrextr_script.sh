#!/bin/bash
 
# -- Create tmp dir for dump files
mkdir $2/awrextr_tmp
 
# -- Set start parameters
# AWREXTR_PROF=.profile.11204.test 
# AWREXTR_DIR=/home/oracle/awrextr_tmp
# AWREXTR_BSNAP=100100 or ''
# AWREXTR_ESNAP=100101 or ''

AWREXTR_PROF=$1  
AWREXTR_DIR=$2/awrextr_tmp
AWREXTR_BSNAP=$3
AWREXTR_ESNAP=$4
AWREXTR_DATE=`date '+%Y-%m-%d'`
 
echo "use profile" $AWREXTR_PROF
echo "begin_snap" $AWREXTR_BSNAP
echo "end_snap" $AWREXTR_ESNAP
echo "directory_name AWREXRT" $AWREXTR_DIR  

# -- Set env profile
. ./$AWREXTR_PROF
 
# -- AwrExtract start sql
sqlplus / as sysdba << END_SQL >> $AWREXTR_DIR/awrextr_$ORACLE_SID"_"$AWREXTR_DATE.log       
                -- Use local dbid
                define dbid         = '';
                -- List all snapshots
                define num_days = '';
                -- Optionally, set the snapshots to export.  If you do not set them,
                -- you will be prompted for the values.
                define begin_snap = ${AWREXTR_BSNAP};
                define end_snap   = ${AWREXTR_ESNAP};
                -- Search begin/end_snap by date. If snap_id is specified, 
                -- the select failed
                column begin_snap new_value begin_snap
                column end_snap new_value end_snap
                SELECT MIN(SNAP_ID) AS begin_snap, MAX(SNAP_ID) AS end_snap 
                FROM DBA_HIST_SNAPSHOT
                               WHERE END_INTERVAL_TIME BETWEEN TO_DATE('$AWREXTR_BSNAP','DDMMYYYYHH24MISS')
                               AND TO_DATE('$AWREXTR_ESNAP','DDMMYYYYHH24MISS');

                -- Create temp directory
                CREATE OR REPLACE DIRECTORY AWREXRT_TMPDIR AS '$AWREXTR_DIR';
                -- Use the directory name and file name
                define directory_name = 'AWREXRT_TMPDIR';
                define file_name      = ''
                -- Start script /rdbms/admin/awrextr.sql
                @$ORACLE_HOME/rdbms/admin/awrextr.sql
                -- Drop temp directories
                DROP DIRECTORY AWREXRT_TMPDIR;
                EXIT;
END_SQL

# -- Drop script
rm awrextr_script.sh

# -- ZIP dump files
cd $AWREXTR_DIR

zip -9mr $2/"awrextr_"$AWREXTR_DATE"_"$ORACLE_SID".zip" "awr"* 

# -- delete directory
cd ~
rm -r $AWREXTR_DIR/

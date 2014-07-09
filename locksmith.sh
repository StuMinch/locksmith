#!/bin/bash
#
# Author: Stuart Minchington
# Contact: stuart@haxtable.com
# License: GNU GPL v3
# View the file named LICENSE for more details.

# Creating log directory
LOG=/var/www/locksmith/locksmith.log

# New log entry
START_DATE=$(date)
echo "Script started: $START_DATE" >> $LOG

# Old lock mechanism
#if mkdir /var/www/lock; then 
#
#  echo "Locking succeeded" >> $LOG 
#else 
#  echo "Lock failed - exit" >> $LOG 
#  exit 1 
#fi 

# New lock mechanism
process_id=`ps -ef | grep "lock.py" | grep -v "grep" | awk '{print $2}'`
if [ -n "$process_id" ]; then
  echo "Process ID $process_id found. Script is currently locked." >> $LOG
else
  echo "No Process ID was found. Proceeding to run the lock script." >> $LOG
  exit 1
fi

python /var/www/locksmith/lock.py

# Run rsync job
rsync -aHyP --bwlimit=2000 --log-file=$LOG --exclude='some_dir'  rsync://192.168.0.10/foo/remote_dir/. /foo/local_dir

# Remove lock
#rm -rf /var/www/lock
kill -9 $process_id

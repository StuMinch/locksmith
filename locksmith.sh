#!/bin/bash
#
# Author: Stuart Minchington
# Contact: stuarttm@me.com
# License: GNU GPL v3
# View the file named LICENSE for more details.

# Creating log directory
log=/var/www/locksmith/locksmith.log

# Write new log entry
start_date=$(date)
echo "Script started: $start_date" >> $log

# Verify if a lock already exists
process_id=`ps -ef | grep "lock.py" | grep -v "grep" | awk '{print $2}'`
if [ -n "$process_id" ]; then
  echo "Process ID $process_id found. Script is currently locked." >> $log
else
  echo "No Process ID was found. Proceeding to run the lock script." >> $log
  exit 1
fi

# Apply lock
python /var/www/locksmith/lock.py

# Run rsync job
rsync -aHyP --bwlimit=2000 --log-file=$log --exclude='some_dir'  rsync://192.168.0.10/foo/remote_dir/. /foo/local_dir

# Remove lock
kill -9 $process_id

# Close out log entry
end_date=$(date)
echo "Script completed: $end_date" >> $log

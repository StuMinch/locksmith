#!/bin/bash
#
# Author: Stuart Minchington
# Contact: stuart@haxtable.com
# License: GNU GPL v3
# View the file named LICENSE for more details.

# Create log file
LOG=/var/www/locksmith/locksmith.log

# New log entry
START_DATE=$(date)
echo "Script started: $START_DATE" >> $LOG

# Lock creation/verification
if mkdir /var/www/lock; then

  echo "Locking succeeded" >> $LOG
else
  echo "Lock failed - exit" >> $LOG
  exit 1
fi

# Rsync job
rsync -aHyP --bwlimit=2000 --log-file=$LOG --exclude='some_dir' rsync://x.x.x.x/some/remote_dir/. /some/local_dir

# Remove lock
rm -rf /var/www/lock

# Close out log entry
END_DATE=$(date)
echo "Script completed: $END_DATE" >> $LOG

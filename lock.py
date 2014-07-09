# This script creates a python process that is used to lock the rsync jobs in locksmith.sh.
# By leaving the Python script waiting for user input the process ID will remain active and
# future attempts to run the locksmith.sh will not be possible.

raw_input("All rsync jobs have been locked.")

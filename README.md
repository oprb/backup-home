# Backup Solution

The script provides a simple backup solution for the user's home directory wrapping rdiff-backup.
It expects a file *~/rdiff_backup_list*, all items in there will be excluded from the backup.
For example, to exclude /home/user/file1 and /home/user/directory1 from the backup, insert the
following two lines in /home/user/rdiff_backup_list:

* `- /home/user/file1`
* `- /home/user/directory1`

Prepending the '-' is optional.
Before the backup is started, a notification will be shown reminding you that a backup is about to
happen. If your backup device is not yet connected, connect it now. The script will check for a
connected backup device after a while and then start the backup immediately.
If the backup was successful, another notification will be shown.

## Usage

The script can either be directly started from the shell by simply typing or be used in a cronjob.
No arguments are expected. It will simply backup the currents user's home directory.
To log the script's messages and output in case of errors, use the following command entry in your
cronjob:

`/path/to/backup_home.sh 2>&1 | ts >> /path/to/backup_home.log`

Both normal messages and error messages will be written to the logfile. `ts` is used to add timestamps
to the messages before writing them to the log. `ts` may have to be installed with
`sudo apt-get install moreutils` on Ubuntu.

# Backup Solution

The script provides a simple backup solution for the user's home directory wrapping *rdiff-backup*.
It expects a file *~/rdiff_backup_list*, all items in there will be excluded from the backup.
For example, to exclude /home/user/file1 and /home/user/directory1 from the backup, insert the
following two lines in /home/user/rdiff_backup_list:

* `- /home/you/file1`
* `- /home/you/directory1`

Prepending the '-' is optional. For more details, see the
[rdiff-backup documentation](https://rdiff-backup.net/).
Before the backup is started, a notification will be shown reminding you that a backup is about to
happen. If your backup device is not yet connected, connect it now. The script will check for a
connected backup device after a while and then start the backup immediately.
If the backup was successful, another notification will be shown.

## Usage

The script can either be directly started from the shell by simply typing or be used in a cronjob.
No arguments are expected. It will simply backup the currents user's home directory.
If you want to get reminded by cron to perform a daily backup at 4:30 pm each day, you could do
the following, assuming the script is in `/home/you/bin`:

`crontab -e  # open your user's crontab to edit`

Then insert the following as one (!) line to add your daily backup job:

`30 16 * * * XDG_RUNTIME_DIR=/run/user/$(id -u) /home/nano/bin/backup_home.sh 2>&1
 | ts >> /home/you/backup_home.log`

Explanation:

* The XDG_RUNTIME_DIR for your user has to be specified, otherwise no GUI notifications will be shown.
  Specifying the XDG_RUNTIME_DIR this way fix the problem, at least with Ubuntu 18.04 LTS.
* With `2>&1`, normal messages but also error messages will be available in the logfile.
* *ts* adds a timestamp to each line written to the logfile. It is available in Ubuntu's °moreutils°
  package.

For more details on cron, see for example
[Ubuntu's help page on cron](https://help.ubuntu.com/community/CronHowto).

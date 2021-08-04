#!/bin/bash

USER=$(whoami)
BACKUP_DEVICE="/dev/sda1"
MOUNTPOINT="/media/ole/backup"
BACKUP_SOURCE="/home/${USER}"
BACKUP_DESTINATION="${MOUNTPOINT}/rdiff_backups/${USER}_home"

RDIFF_EXCLUDE_LIST="/home/${USER}/rdiff_backup_list"

SLEEP_DURATION="2m"

# show a reminder that a backup will happen soon
notify-send --urgency=critical --expire-time=5000 \
            "Backup" "Backup will start soon. Make sure the backup device is connected."

sleep $SLEEP_DURATION

# check if the backup device is mounted by checking the findmnt output
if [ "$(findmnt --raw --noheadings $BACKUP_DEVICE $MOUNTPOINT | cut --delimiter=' ' --fields=1,2)" \
     = "$MOUNTPOINT $BACKUP_DEVICE" ]
then
  echo "Backing up $BACKUP_SOURCE to $BACKUP_DESTINATION"
  echo "The following items will be excluded from the backup:"
  cat $RDIFF_EXCLUDE_LIST

  if [ ! -d $BACKUP_DESTINATION ]
  then
    echo "Backup destination was not found. $BACKUP_DESTINATION will be created."
    mkdir -p $BACKUP_DESTINATION
  fi

  echo "Backup will start now."
  rdiff-backup --exclude-filelist $RDIFF_EXCLUDE_LIST $BACKUP_SOURCE $BACKUP_DESTINATION

  # test for the return code of rdiff-backup
  if [ "$?" = "0" ]
  then
    echo "$BACKUP_SOURCE has been backed up successfully."
    notify-send --urgency=normal --expire-time=5000 \
                "Backup" "$BACKUP_SOURCE has been backed up successfully."
  else
    echo "Error(s) occured while backing up!" >&2
    notify-send --urgency=critical --expire-time=5000 \
                "Backup" "Error(s) occured while backing up!"
    exit 1
  fi
else
  echo "No backup is performed since the backup device is not mounted." >&2
  notify-send --urgency=critical --expire-time=5000 \
              "Backup" "Backup device is not connected. Could not backup!"
  exit 1
fi

exit 0

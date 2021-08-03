#!/bin/bash

BACKUP_DEVICE="/dev/sda1"
MOUNTPOINT="/media/ole/backup"
BACKUP_SOURCE="/home/ole"
BACKUP_DESTINATION="${MOUNTPOINT}/rdiff_backups/ole_home"

RDIFF_INCLUDE_LIST="/home/ole/rdiff_backup_list"

SLEEP_DURATION="2s"

# show a reminder that a backup will soon happen
notify-send --urgency=critical --expire-time=5000 \
            "Backup" "Backup will start soon. Make sure the backup device is connected."

sleep $SLEEP_DURATION

# check if the backup device is mounted checking the findmnt output
if [ "$(findmnt --raw --noheadings $BACKUP_DEVICE $MOUNTPOINT | cut --delimiter=' ' --fields=1,2)" \
     = "$MOUNTPOINT $BACKUP_DEVICE" ]
then
  echo "Backing up $BACKUP_SOURCE to $BACKUP_DESTINATION"

  if [ ! -d $BACKUP_DESTINATION ]
  then
    echo "Backup destination was not found. $BACKUP_DESTINATION will be created."
    mkdir -p $BACKUP_DESTINATION
  fi

  rdiff-backup --include-globbing-filelist $RDIFF_INCLUDE_LIST $BACKUP_SOURCE $BACKUP_DESTINATION
  echo -e "Items backuped:\n" $RDIFF_INCLUDE_LIST
else
  echo "No backup is performed since the backup device is not mounted."
  notify-send --urgency=critical --expire-time=5000 \
              "Backup" "Backup device is not connected. Could not backup!"
  exit 1
fi

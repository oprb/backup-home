#!/bin/bash

BACKUP_DEVICE="/dev/sda1"
MOUNTPOINT="/media/ole/backup"
BACKUP_SOURCE="/home/ole"
BACKUP_DESTINATION="${MOUNTPOINT}/rdiff_backups/ole_home"

RDIFF_INCLUDE_LIST="/home/ole/rdiff_backup_list"

SLEEP_DURATION="10s"

function is_backup_device_mounted () {
  test "$(findmnt --raw --noheadings $BACKUP_DEVICE $MOUNTPOINT | cut --delimiter=' ' --fields=1,2)" \
       = "$MOUNTPOINT $BACKUP_DEVICE"
}

function show_backup_reminder () {
  notify-send --urgency=critical --expire-time=5000 \
             "Backup" "Backup will start soon. Make sure the backup device is connected."
}

function perform_backup () {
  echo "Backing up $BACKUP_SOURCE to $BACKUP_DESTINATION"
  echo "Items backuped:"
  cat $RDIFF_INCLUDE_LIST
  rdiff-backup --include-globbing-filelist $RDIFF_INCLUDE_LIST $BACKUP_SOURCE $BACKUP_DESTINATION >&1
}

function backup () {
  show_backup_reminder

  sleep $SLEEP_DURATION

  if is_backup_device_mounted
  then
    perform_backup
    return
  fi

  echo "No backup is performed since the backup device is not mounted." 
  notify-send --urgency=critical --expire-time=5000 \
              "Backup" "Backup device is not connected. Could not backup!"
  exit 1
}

#!/bin/bash -eu


source /root/.teslaCamRcloneConfig

log "Checking saved folder count..."

DIRCOUNT=$(find "$CAM_MOUNT"/TeslaCam/SavedClips/* -maxdepth 0 -type d | wc -l)

log "There are $DIRCOUNT folders to move."

if [ $DIRCOUNT -gt 0 ]
then
  log "Moving clips to rclone archive..."
  /root/bin/send-push-message "TeslaUSB:" "Beginning to move $DIRCOUNT folder(s) at $(date)."

  rclone --config /root/.config/rclone/rclone.conf move "$CAM_MOUNT"/TeslaCam/SavedClips "$drive:$path" --create-empty-src-dirs --delete-empty-src-dirs >> "$LOG_FILE" 2>&1 || echo ""
  REMAINING=$(find "$CAM_MOUNT"/TeslaCam/SavedClips/* -maxdepth 0 -type d | wc -l)
  MOVED=$((DIRCOUNT-REMAINING))

  log "Moved $MOVED folder(s)."

  /root/bin/send-push-message "TeslaUSB:" "Moved $MOVED dashcam folder(s)."

fi
log "Finished moving clips to rclone archive"

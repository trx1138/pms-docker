#!/bin/bash

# settings
LOCAL_DIR=/media
CLOUD_DIR=/plexdrive
UNION_DIR=/unionfs

# default
MOUNT_UID=${PLEX_UID:-1000}
MOUNT_GID=${PLEX_GID:-1000}

# unionfs
DIRS=$LOCAL_DIR=RW:$CLOUD_DIR=RO
UNIONFS_OPTS=cow,auto_cache,direct_io,umask=000,allow_other,sync_read,nonempty,uid=$MOUNT_UID,gid=$MOUNT_GID

echo "unionfs-fuse"
echo " -o ${UNIONFS_OPTS}"
echo " -o dirs=${DIRS}"
echo " $UNION_DIR"
umount -l $UNION_DIR >/dev/null 2>&1
umount -f $UNION_DIR >/dev/null 2>&1
unionfs-fuse -o ${UNIONFS_OPTS} -o dirs=${DIRS} ${UNION_DIR}
#ls $ACD_UNION

RESULT=`ls -l $UNION_DIR | grep -v '^total' | wc -l`
echo "Mount Result Folder: $RESULT"
if [ $RESULT -eq 0 ]; then
  exit 1
fi

#!/usr/bin/env bash
#
# format and mount drives

# set umask
umask 0022

# check command line
if [ $# != 1 ]; then
    echo usage: $0 FUNCTION
    exit 1
fi

# unload the command line
functions=$1

# source functions
. $functions

# format volume
if [ $(file -s ${device_name} | cut -d ' ' -f 2) = 'data' ]; then
    mkfs.xfs ${device_name} || error "mkfs.xfs failed"
fi

# create the mount point
if [ ! -d ${mount_point} ]; then
    mkdir -p ${mount_point} || error "mkdir failed"
fi

# mount the volume
if ! grep ${device_name} /etc/mtab > /dev/null; then
    mount -t xfs ${device_name} ${mount_point} || error "mount failed"
fi

# update fstab
if ! grep ${mount_point} /etc/fstab > /dev/null; then
    echo "${device_name} ${mount_point} xfs defaults 0 0" >> /etc/fstab
fi

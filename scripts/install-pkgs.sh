#!/usr/bin/env bash
#
# Script to prep hosts by installing requisite software.

function install_pkg {
    if has_prog yum; then
        yum install -y $1 || return 1
    elif has_prog apt-get; then
        apt-get install -y $1 || return 1
    elif has_prog zypper; then
        count=0
        until [ $count -eq 10 ]; do
            zypper install -y $1 && break
            count=$[$count+1]
            sleep 60
        done
        if [ $count -eq 10 ]; then
            return 1
        fi
    else
        echo unknown linux distribution
        return 1
    fi
}

# set umask
umask 0022

# check command line
if [ $# != 2 ]; then
    echo usage: $0 FUNCTIONS BACKUP
    exit 1
fi

# unload command line args
functions=$1
backup=$2

# source functions
. $functions

# ubuntu/debian
if has_prog apt-get; then
    apt-get update
fi

# XFS
install_pkg xfsprogs || error "install_pkg xfsprogs failed"


# check backup flag
if [ $backup = 'true' ]; then

    # install git
    install_pkg git || error "install_pkg git failed"

    # install python
    install_pkg python || error "install_pkg python failed"

fi
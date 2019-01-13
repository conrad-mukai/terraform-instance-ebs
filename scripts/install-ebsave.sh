#!/usr/bin/env bash
#
# install ebsave script

# set umask
umask 0022

# check command line
if [ $# != 3 ]; then
    echo usage: $0 FUNCTIONS SCHEDULE DEVICES
    exit 1
fi

# unload command line args
functions=$1
schedule=$2
devices=$3

# source functions
. $functions

# change working directory
cd /tmp

# install pip
if ! has_prog pip; then
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
        || error "get-pip.py download failed"
    python get-pip.py || error "get-pip.py failed"
    rm get-pip.py
fi

# upgrade setuptools
pip install --upgrade setuptools || error "setuptools upgrade failed"

# upgrade awscli
if has_prog aws; then
    pip install --upgrade awscli || error "awscli upgrade failed"
fi

# distutils clean up (ubuntu 14)
for package in urllib3 chardet requests; do
    if [ -d /usr/lib/python2.7/dist-packages/$package ]; then
        rm -rf /usr/lib/python2.7/dist-packages/${package}*
    fi
    if [ -d /usr/local/lib/python2.7/dist-packages/$package ]; then
        rm -rf /usr/local/lib/python2.7/dist-packages/${package}*
    fi
done

# install ebsave
pip install git+https://github.com/conrad-mukai/python-ebsave.git \
    || error "ebsave install failed"

# determine where ebsave is installed
ebsave_path=$(find / -name ebsave -executable -type f)

# create user
if ! id -u ebsave 2> /dev/null; then
    useradd ebsave
fi

# create directory for logs
if [ ! -d /var/log/ebsave ]; then
    mkdir -p /var/log/ebsave
    chown ebsave /var/log/ebsave
fi

# create crontab entry
current=$(crontab -u ebsave -l 2> /dev/null)
command="$schedule $ebsave_path -l /var/log/ebsave/ebsave.log -d $devices"
if [ "$current" != "$command" ]; then
    echo "$command" > /tmp/crontab
    crontab -u ebsave /tmp/crontab
    rm /tmp/crontab
fi

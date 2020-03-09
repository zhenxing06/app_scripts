#!/bin/bash
##################################
# Date: 03/09/2020
# Auth: rzx 
# Email: zhenxing_06@163.com
# Desc:  init centos 6.X system
# version: 1.0
#################################

source /etc/profile
source /etc/init.d/functions

if [ -f "/var/log/system.lock" ];then
  echo "#######################################################"
  echo "Lock File Is Exist,Can't Executable. "
  echo "#######################################################"
  exit 2
else
  echo "#######################################################"
  echo "Lock Files Does Not Exist, start initialization ......"
  echo "#######################################################"
fi

# only support
if [ ! -e '/etc/redhat-release' ]; then
    echo " redhat-release files exist"
    exit 2
fi
 
if  [ -n "$(grep ' 7\.' /etc/redhat-release)" ] ;then
    echo " Only Support Centos 6.X System "
    exit 2
fi

configservice() {
	service_start=(network sshd crond rsyslog)
	for serv in `chkconfig --list | grep 3:on | awk '{print $1}'`;do chkconfig $serv off ;done
	for serz in ${service_start[*]};do chkconfig $serz on;done
}

/bin/touch /var/log/system.lock
configservice

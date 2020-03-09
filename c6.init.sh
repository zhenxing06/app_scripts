#!/bin/bash
##################################
# Date: 03/09/2020
# Auth: rzx 
# Email: zhenxing_06@163.com
# Desc:  init centos 6.X system
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

ConfigSource(){
        yum install wget curl epel* -y
        cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
        wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo

        cp /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.bak
        wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
        yum clean all
}

SoftInstall() {
        yum install htop screen iftop iotop nload vim nethogs lrzsz tree lsof sysstat net-tools ntp -y
        yum groupinstall  "Development Tools"
}

OffSelinux() {
        setenforce 0
        sed -i 's#enforcing$#disabled#g' /etc/selinux/config
        sed -i 's#\#UseDNS yes#UseDNS no#g' /etc/ssh/sshd_config
        sed -i 's#GSSAPIAuthentication yes#GSSAPIAuthentication no#g' /etc/ssh/sshd_config
        echo "00 00 * * *  ntpdate ntp1.aliyun.com" >> /var/spool/cron/root
        cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime -R
}


openlimit() {
cat > /etc/security/limits.conf<< EOF
*      soft    nofile  100000
*      hard    nofile  100000
*      soft    nproc   65535
*      hard    nproc   65535
EOF
}

ChangeKernel(){
 /usr/bin/cp -f /etc/sysctl.conf /etc/sysctl.conf.bak
cat >> /etc/sysctl.conf<<EOF
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000
EOF
/sbin/sysctl -p
}

/bin/touch /var/log/system.lock

configservice
SoftInstall
OffSelinux
openlimit
ChangeKernel


 yum install rsyslog epel-release network-scripts -y
 dnf install htop nload screen tree iftop -y




configserver(){
yum install network-scripts -y
for x in `systemctl list-unit-files | grep enable | awk '{print $1}'`; do systemctl disable $x ;done

lis=(sshd crond network rsyslog)
for s in ${lis[*]};do systemctl enable $s;done
chkconfig network on
}

configserver
#################################
# Date: 04/14/2022
# Auth: rzx 
# Email: zhenxing_06@163.com
# Desc:  init centos 8.X system
# version: 1.0
#################################

source /etc/profile
source /etc/init.d/functions

#判断系统是否可以运行初始化:
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

#适用于 rocky linux 8
if [ ! -e '/etc/redhat-release' ]; then
echo "仅支持 rocky linux 8"
exit 2
fi
if  [ -n "$(grep ' 6\.' /etc/redhat-release)" ] ;then
echo "仅支持rocky linux 8"
exit 2
fi
if  [ -n "$(grep ' 7\.' /etc/redhat-release)" ] ;then
echo "仅支持rocky linux 8"
exit 2
fi

ServerEnable() {
        yum install rsyslog network-scripts -y
	List=(sshd network rsyslog crond)
	for x in `chkconfig --list | grep 3:on | awk '{print $1}'`;do chkconfig $x off;done
	for i in `systemctl list-unit-files | grep enabled | awk '{print $1}'`;do systemctl disable $i;done 
        systemctl disable NetworkManager
	for z in ${List[*]};do chkconfig $z on; systemctl enable $z;done
        chkconfig network on
}

ConfigSource(){
        dnf install wget curl epel-release  -y
        #cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
	#curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo

        #wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

        #cp /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.bak
        #wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
        #yum clean all
}

SoftInstall() { 
	dnf install git htop screen iftop iotop nload vim nethogs lrzsz tree lsof sysstat net-tools -y
        dnf groupinstall  "Development Tools" -y
	#yum groupinstall development* -y
}

OffSelinux() {
        
        setenforce 0
        sed -i 's#enforcing$#disabled#g' /etc/selinux/config 
        sed -i 's#\#UseDNS yes#UseDNS no#g' /etc/ssh/sshd_config 
        sed -i 's#GSSAPIAuthentication yes#GSSAPIAuthentication no#g' /etc/ssh/sshd_config 
        echo "00 00 * * *  ntpdate asia.pool.ntp.org" >> /var/spool/cron/root
        echo "00 00 * * *  ntpdate ntp1.aliyun.com" >> /var/spool/cron/root
        test -d /etc/localtime && mv /etc/localtime /etc/localtime_bak
        cp -R /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
}

InstallWall() {
       
systemctl stop firewalld.service 
systemctl disable firewalld.service 

yum install iptables-services
service iptables save

systemctl start iptables.service 
systemctl enable iptables.service

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
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
EOF
/sbin/sysctl -p
}


/usr/bin/touch /var/log/system.lock

ServerEnable
#ConfigSource
SoftInstall
OffSelinux
openlimit
ChangeKernel

#!/bin/bash



yum_git(){
  curl https://setup.ius.io | sh
  yum remove -y git | yum -y install git2u
  git --version
}

tar_git(){
   yum remove git
   yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel -y
   yum install gcc perl-ExtUtils-MakeMaker -y
   cd /tmp
   wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.22.0.tar.gz --no-check-certificate
   tar xzf git-2.22.0.tar.gz
   cd git-2.22.0
   make prefix=/usr/local/git all
   make prefix=/usr/local/git install
   echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
   source /etc/bashrc
   git --version
}

#yum_git
tar_git

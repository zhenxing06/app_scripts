### docker 安装
```bash
# step 1: 安装必要的一些系统工具
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# Step 2: 添加软件源信息
sudo yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# Step 3
sudo sed -i 's+download.docker.com+mirrors.aliyun.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo

# Step 4: 更新并安装Docker-CE
sudo yum makecache fast
sudo yum -y install docker-ce

# Step 4: 开启Docker服务
sudo service docker start

# Step 5: 开机启动Docker服务
systemctl enable docker

```

### docker 配置文件
```bash
vim /etc/docker/daemon.json
{
    "data-root": "/data/docker",
    "debug": true,
    "experimental": true,
    "insecure-registries": [
        "docker.mirrors.ustc.edu.cn"
    ],
    "log-driver": "json-file",
    "log-opts": {
        "max-file": "3",
        "max-size": "50m"
    },
    "registry-mirrors": [
        "http://docker.mirrors.ustc.edu.cn",
        "http://hub-mirror.c.163.com"
    ]
}

mkdir -p /data/docker
systemctl restart docker
```

###  安装docker-compose
```bash
sudo curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

docker-compose --version
```

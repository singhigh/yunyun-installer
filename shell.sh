#!/bin/bash


#取操作系统的名称
Get_Dist_Name()
{
    if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'		
	else
        DISTRO='unknow'
    fi
    Get_OS_Bit
}

#安装相应的软件
if [ "$DISTRO" == "CentOS" ];then
	yum install -y wget dmidecode net-tools psmisc curl
elif [ "$DISTRO" == "Debian" ];then
	apt-get update
	apt-get install -y dmidecode net-tools psmisc curl
elif [ "$DISTRO" == "Ubuntu" ];then
	apt-get update
	apt-get install -y dmidecode net-tools psmisc curl
else
	echo "Your system is not supported"
	exit 1
fi

STORAGE=http://ovhstorage.hudie.su/cloudtalkers
echo INPUT FILENAME
echo You may get filename list on $STORAGE/filelist.txt
read FILENAME

echo "92.222.211.148 license.cloudtalkers.com" >> /etc/hosts
echo "92.222.211.148 45.63.59.243" >> /etc/hosts
wget -O ./flash_tcp.tar.gz $STORAGE/FILENAME
rm -rf /flash_tcp
tar xf flash_tcp.tar.gz  -C  /
/flash_tcp/install.sh
cd /flash_tcp/
wget $STORAGE/tm_config
cd
/flash_tcp/restart.sh
/flash_tcp/status.sh

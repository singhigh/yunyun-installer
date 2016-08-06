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
}

Get_Dist_Name
#安装相应的软件
if [ "$DISTRO" == "CentOS" ];then
	yum install -y wget dmidecode net-tools psmisc
elif [ "$DISTRO" == "Debian" ];then
	apt-get update
	apt-get install -y  dmidecode psmisc
elif [ "$DISTRO" == "Ubuntu" ];then
	apt-get update
	apt-get install -y  dmidecode psmisc
else
	echo "Your system is not supported"
	exit 1
fi

STORAGE=http://ovhstorage.hudie.su/cloudtalkers
echo INPUT FILENAME 请输入安装包文件名 可以在$STORAGE/list.txt获得文件名列表，你只要匹配内核即可，你的内核是
uname -r
read FILENAME

cat » /etc/hosts « EOF
92.222.211.148 45.63.59.243
EOF
cat » /etc/hosts « EOF
92.222.211.148 license.cloudtalkers.com
EOF
wget -O ./flash_tcp.tar.gz $STORAGE/$FILENAME
rm -rf /flash_tcp
tar xf flash_tcp.tar.gz  -C  /
/flash_tcp/install.sh
cd /flash_tcp/
wget $STORAGE/tm_config
cd
/flash_tcp/restart.sh
/flash_tcp/status.sh

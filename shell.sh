#!/bin/bash

# credit to linrong, Dimen Ekloss

echo 目前只支持CentOS，Debian 和 Ubuntu系统，不是这些系统请不要继续。

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
	yum install -y wget dmidecode net-tools psmisc vim
elif [ "$DISTRO" == "Debian" ];then
	apt-get update
	apt-get install -y  dmidecode psmisc vim
elif [ "$DISTRO" == "Ubuntu" ];then
	apt-get update
	apt-get install -y  dmidecode psmisc vim
else
	echo "Your system is not supported"
	exit 1
fi

#获得安装包参数
STORAGE=http://ovhstorage.hudie.su/cloudtalkers
KENERAL=uname -r
echo INPUT FILENAME 请输入安装包文件名 可以在$STORAGE/list.txt获得文件名列表，你只要匹配内核即可，你的内核是$KENERAL，请对照是否有你支持的内核，如没有请按Ctrl+退出。
read FILENAME

#安装云语，感谢Dimen Ekloss提供部分支持
iptables -t nat -A OUTPUT -p all -d 45.63.59.243 -j DNAT —to-destination 92.222.211.148
iptables-save
cat >> /etc/hosts << EOF
92.222.211.148 45.63.59.243
92.222.211.148 license.cloudtalkers.com
EOF
echo 按任意键进入/etc/host文件，确认有下面两行单独成行的记录，确认后输入:wq回车退出。
echo 92.222.211.148 45.63.59.243
echo 92.222.211.148 license.cloudtalkers.com
pause
vim /etc/host
wget -O ./flash_tcp.tar.gz $STORAGE/$FILENAME
rm -rf /flash_tcp
tar xf flash_tcp.tar.gz  -C  /
/flash_tcp/install.sh
cd /flash_tcp/
wget $STORAGE/tm_config
cd
/flash_tcp/restart.sh
/flash_tcp/status.sh

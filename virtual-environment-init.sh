#!/bin/sh

red="\033[1;31m"
c1="\033[47m\033[34m"
HOSTIP="172.16.254.2"
GWIP="172.16.254.1"

make_copy_or_restore() 
{
	name="$1"
	copyname="$1.gl-virt-copy"
	if [ -e "$copyname" ]; then
		echo "${red}previously copy of $name found in $copyname, restored${c1}"
		cp -f $copyname $name
	else
		echo "${red}making backup copy of $name in $copyname${c1}"
		cp $name $copyname
	fi
}

if_exist_remove()
{
	if [ -e $1 ] || [ -d $1 ]; then
		echo "${red}odd ? previously installation detected: $1 removed${c1}"
		rm -rf $1
	fi
}

check_required_file() 
{
	if [ ! -e "$1" ]; then
		echo "${red}File $1 not exist! $2 ${c1}"
		exit
	fi
}

boxname=`hostname`

echo "This script will setup this box $boxname, install GlobaLeaks, potentially damage data"
echo "This script has been tester only in the Ubuntu Server 11.10 VirtualBox"
echo "If you're starting this script in a different environment, effects are unpredictable"
echo "This script modify your network settings, and expect that in the host box, where VirtualBox run"
echo "You're following the configuration here explain: https://github.com/vecna/GL-virtual"
echo "\n"
echo "maybe you don't want run this shell script, you can download the VirtualBox image already setup"
echo "^c to Quit, ENTER to continue..."
read x

echo "Checking privileges: am I root ? (user = $USER) "
if [ $USER != "root" ]; then
	echo "${red}I'm not root, use sudo -s (default password: reverse)${c1}"
	exit
else
	echo "${red}Ok, I'm root, installation possible ${c1}"
fi

IFACEFILE="/etc/network/interfaces"
echo "${red}writing network defaults in $IFACEFILE${c1}"
make_copy_or_restore $IFACEFILE 
echo "auto lo" > $IFACEFILE
echo "iface lo inet loopback" >> $IFACEFILE
echo "auto eth0" >> $IFACEFILE
echo "iface eth0 inet static" >> $IFACEFILE
echo "address $HOSTIP" >> $IFACEFILE
echo "network 172.16.254.0" >> $IFACEFILE
echo "netmask 255.255.255.0" >> $IFACEFILE
echo "broadcast $HOSTIP" >> $IFACEFILE
echo "gateway $GWIP" >> $IFACEFILE

echo "${red}writing network defaults in $IFACEFILE and restart eth0 interface ${c1}"
ifdown eth0
ifup eth0

echo "${red}Modify /etc/hosts (hostbox and globalx-vm) ${c1}"
make_copy_or_restore "/etc/hosts"
echo "$GWIP hostbox " >> /etc/hosts
echo "$HOSTIP globalx-vm " >> /etc/hosts

RESOLVCFG="/etc/resolv.conf"
make_copy_or_restore $RESOLVCFG
echo "${red}Configuring $RESOLVCFG ${c1}"
echo "nameserver 194.20.8.4" > $RESOLVCFG
echo "nameserver 213.92.5.54" >> $RESOLVCFG

echo "${red}Checking network connection, using http://www.globaleaks.org as test${c1}"
echo "\tYou can bypass this test using the option \"netisfine\""
if [ -z "$1" -o "$1" != "netisfine" ]; then
		ping -c 1 $GWIP
		cd /tmp
		rm -rf index.html
		wget --timeout=2 http://www.globaleaks.org
		check_required_file "/tmp/index.html" "network not connected: is your hostbox a gateway (checks routing, forwarding, nat) ?"
fi

cd /root
echo "${red}Installing python-pip, Tor, unzip${c1}"
aptitude -y install python-pip tor zip

echo "${red}Installing web2py${c1}"
pip install web2py

echo "${red}adding globaleaks user and group, and /home/globaleaks base directory for installation${c1}"
groupadd globaleaks
adduser --ingroup globaleaks --disabled-login --disabled-password --quiet --system globaleaks

echo "${red}cloning GlobaLeaks repository${c1}"
GL01="/home/globaleaks/GL-01/"
cd /home/globaleaks
if_exist_remove "$GL01"
if_exist_remove "/home/globaleaks/master"
wget https://github.com/globaleaks/GlobaLeaks/zipball/virtual
unzip -q virtual
mv globaleaks-GlobaLeaks-*/ GL-01

echo "${red}Creating Tor hidden service..${c1}"
if_exist_remove "/home/globaleaks/HS"
mkdir /home/globaleaks/HS
chown debian-tor.debian-tor /home/globaleaks/HS

TORRC="/etc/tor/torrc"
make_copy_or_restore $TORRC
echo "HiddenServiceDir /home/globaleaks/HS" >> $TORRC
echo "HiddenServicePort 10000 172.16.254.2:8000" >> $TORRC
echo "${red}Configured Tor to start with an hidden service: the first start would happen only when GlobaLeaks node is configured${c1}"
/etc/init.d/tor stop
echo "${red}Disabling autostart for Tor service (would be started by GlobaLeaks init script)${c1}"
update-rc.d -f tor remove

cd $GL01
INIS="/etc/init.d/globaleaks"
SOURCE="$GL01/globaleaks/scripts/init.globaleaks.sh"
if_exist_remove $INIS
check_required_file $SOURCE "not found in repository the required script!"
cp $SOURCE $INIS
chmod +x $INIS
chmod +x "$GL01/globaleaks/scripts/globaleaks_os_setup.sh"

echo "${red}Enabling GlobaLeaks service autostart${c1}"
update-rc.d globaleaks defaults

touch globaleaks/globaleaks.log
cp globaleaks/defaults/original.globaleaks.conf globaleaks/globaleaks.conf

echo "${red}fixing privileges in $GL01 files${c1}"
chown -R globaleaks.globaleaks .

echo "${red}GlobaLeaks service need to do not start now (because otherwise hidden service is initialized)${c1}"
echo "${red}Reboot, and from your Host box, connect to http://$HOSTIP:8000${c1}"
echo "${red}You shall continue the setup from the web interface${c1}"

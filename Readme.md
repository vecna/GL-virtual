GlobaLeaks - Virtual Edition - Install Script ONLY
==================================================

GlobaLeaks is the first Open Source Whistleblowing Framework. It is focused in flexibility and security, and this 0.1 release in an advanced prototype (read: *not yet a complete release*).

## If you're looking for download the GlobaLeaks Virtual Image: you're in the wrong section :)

download the image from:

	THE VIRTUAL IMAGE IS UNDER CREATION - SOON SHALL BE READY

### Vbox image text description:

This VirtualBox image has been saved for easily permit the GlobaLeaks testing. 

This VirtualBox has been produced downloading: [Ubuntu Server 11.10 - 7zip](http://downloads.sourceforge.net/project/virtualboximage/UbuntuServer/11.10/ubuntu-server-11.10-x86.7z)

Apply the script "virtual-environment-init.sh" from: https://github.com/globaleaks/GlobaLeaks.git **branch virtual**

default login/password: "ubuntu"/"reverse" (part of sudoers users)

# What's GlobaLeaks

It empowers anyone to easily setup and maintain their own Whistleblowing platform. It is also a collection of what are the best practices for people receiveiving and submitting material. GlobaLeaks works in various environments: media, activism, corporations, public agencies. 

At the moment, 0.1 release is a feature weak release, and we're working on the 0.2, [project plan](http://wiki.globaleaks.org)

## DISCLAIMER
GlobaLeaks is under Development

In this repository, there are only the script used to correctly generated GlobaLeaks01-UbuntuServer-11.00-VirtualBox
If you're not interested in development or security check, maybe you need simply download the generated image here:

	THE VIRTUAL IMAGE IS UNDER CREATION - SOON SHALL BE READY

## Setup GlobaLeaks in your desktop, using the Virtual Image

You need to download Oracle VirtualBox Manager from:
http://www.oracle.com/technetwork/server-storage/virtualbox/downloads/index.html

The following steps are required only if you want install GL environment in your virtual box. If you're using the image provided by GlobaLeaks, jump to the next step "Basic Setup"

You need setup the Host-only networking (File -> Preferences -> Network -> + Host-only Networks) the IP address expected is 172.16.254.1, (the virtualbox is setupped to use 172.16.254.2/255.255.255.0)

You need to give routing from the VirtualBox to the outside (Linux):

	vim /etc/sysctl.conf
	# uncomment this line:
	net.ipv4.ip_forward=1

and the masquerade rule:

	iptables -t nat -A POSTROUTING -s 172.16.254.0/24 -o $YOURDEFAULTGWINTERFACE -j MASQUERADE

the netmask 172.16.254.0/255.255.255.0 is hardcoded in this release, and the VirtuaBox need this configuration supports. You can't change this (this is one of the bad thing in a 0.1-advanced-prototype release)

in VirtualBox: add appiance, select "GlobaLeaks 0.1 Ubuntu 11.10.vbox"

Oracle HowTo about setup the Host-only networking is here: http://www.virtualbox.org/manual/ch06.html#network_hostonly

## GlobaLeaks Basic Setup - mandatory configuration

Download GL-Virtual-Image (THE VIRTUAL IMAGE IS NOT YET READY)

having a vboxnet0 interface with the address 172.16.254.1 (this value is hardcoded in the virtualbox
and expected as default gateway IP addr), the address assigned in the virtualbox is 172.16.254.2

When you open the first time http://172.16.254.2:8000, some information are requested for setup GlobaLeaks:

*  service name: the short name of your initiative, this value shall be present in the email notification sent by your GL node.
*  title: your GlobaLeaks name, headline.
*  subtitle: appears in every page, below the title.
*  email server: host:port of an SMTP or SMTPs services awiting mail to send. 
*  email SSL: enable SSL if supported by your email server (Gmail or GMX supports that)
*  email sender: (name and address) make the notification email appears from: "Sender Name <sender@address.tld>"
*  email login: with the format "username_or_email_auth:password", the ':' character inside the password is not usable
*  description: HTML meta description, text useful for the search engine 
*  baseurl: http://yourweb.net/yoursubdir used for compose the URL in the mail notification

After those information setup, you need to reboot the GL virtual box. After the reboot, the Tor hidden service shall be initialized, and connecting to http://172.16.254.2:8000 you can set the administrative password, modify the previously configured settings.

*  administrastive password: required for login as GL node administrator (add receiver, checks status, etc)

## Create your own Virtual Box Image (optional)

Is indifferent if you're installing GlobaLeaks Virtual in a desktop environment or in a server, so get the best VirtualBox manager for your needs

prerequisite: 7zip, Oracle VirtualBox (http://www.oracle.com/technetwork/server-storage/virtualbox/downloads/index.html) or:

	aptitude install virtualbox-qt

Download Ubuntu Server image for VirtualBox

	wget "http://downloads.sourceforge.net/project/virtualboximage/UbuntuServer/11.10/ubuntu-server-11.10-x86.7z"
	7zr x ubuntu-server-11.10-x86.7z

VirtualBox: add appiance, select "Ubuntu server 11.10.vbox", open prefecenes:
    disable USB
    disable Floppy and CD in boot order
    networking, enable HOST only

boot, the first boot would be slow, because networking try to get IP address from the network.
Login password: ubuntu/reverse, user "ubuntu" its sudoers

    sudo -s
    ifconfig eth0 inet 172.16.254.2
    route add default gw 172.16.254.1
    echo "nameserver 194.20.8.4" > /etc/resolv.conf

**you need to have setup routing in yout host box, as explained in the previous section**

    aptitude install git
	git clone http://github.com/vecna/GL-virtual.git
	cd GL-virtual
	./virtual-environment-init.sh

And then reboot!

For download the 'virtual' branch installed in the box, not required if you're using virtual-environment-init.sh

    git clone -b virtual http://github.com/globaleaks/GlobaLeaks.git

Then you will find running as a web service the following:

*  whistleblowing interface binds to http://172.16.254.2:8000
*  node administrator receiver & node configuratation http://172.16.254.2:8000/globaleaks/admin/

those interface shall be present but only in debug mode (not enabled by default, edit globaleaks.conf by hand)

*  debug only global view interface: http://172.16.254.2:8000/globalview
*  web2py developer access: http://172.16.254.2:8000/admin is enable only if you set a password in globaleaks.conf (admin_password isthe field, and this access permit also to checks error)

# What's missing ? 

Every other thing. Seriously, neither the http access stats are easily available. GlobaLeaks 0.1 is a working protoptype of a secure submission system, soon we shall restart the development of a more flexible release.

GlobaLeaks - Virtual Edition - Install Script ONLY
==================================================

GlobaLeaks is the first Open Source Whistleblowing Framework.

It empowers anyone to easily setup and maintain their own Whistleblowing platform. It is also a collection of what are the best practices for people receiveiving and submitting material. GlobaLeaks works in various environments: media, activism, corporations, public agencies. 

In the GlobaLeaks main repository, the 'master' release has a CSS/Template put by a GL-adopters, which we has been focused as first use case. Anyway, for the Virtual Machine distribution, the release without this CSS has been used.

This repository commit: https://github.com/globaleaks/GlobaLeaks/zipball/ee09eae54694c662d299824a199f377a59dccd3c is become the master ahead of 
http://github.com/vecna/GlobaLeaks.git (fork from GlobaLeaks repository) and some bugfix/customization studied for VM complete and easy usage.

## DISCLAIMER
GlobaLeaks is under Development
In this repository, there are only the script used to correctly generated GlobaLeaks01-UbuntuServer-11.00-VirtualBox
If you're not interested in development or security check, maybe you need simply download the generated image here:

	wget "http://downloads.sourceforge.net/project/virtualboximage/UbuntuServer/11.10/ubuntu-server-11.10-x86.7z?r=http%3A%2F%2Fvirtualboxes.org%2Fimages%2Fubuntu-server%2F&ts=1332109332&use_mirror=netcologne"

Installation
============

You need to download Oracle VirtualBox Manager from:
http://www.oracle.com/technetwork/server-storage/virtualbox/downloads/index.html

The following steps are required only if you want install GL environment in your virtual box. If you're using the image provided by GlobaLeaks, jump to the next step "Basic Setup"

You need setup the Host-only networking (File -> Preferences -> Network -> + Host-only Networks) the IP address expected is 172.16.254.1, (the virtualbox is setupped to use 172.16.254.2/255.255.255.0)

You need to give routing from the VirtualBox to the outside:

	vim /etc/sysctl.conf
	# uncomment this line:
	net.ipv4.ip_forward=1

and the masquerade rule:

	iptables -t nat -A POSTROUTING -s 172.16.254.0/24 -o $YOURDEFAULTGWINTERFACE -j MASQUERADE

Oracle HowTo about setup the Host-only networking is here: http://www.virtualbox.org/manual/ch06.html#network_hostonly

(Is indifferent if you're installing GlobaLeaks Virtual in a desktop environment or in a server, so get the best VirtualBox manager for your needs)

and Ubuntu Server image for VirtualBox
http://downloads.sourceforge.net/project/virtualboximage/UbuntuServer/11.10/ubuntu-server-11.10-x86.7z?r=http%3A%2F%2Fvirtualboxes.org%2Fimages%2Fubuntu-server%2F&ts=1332109332&use_mirror=netcologne

login password: ubuntu/reverse (and "su" on it)

	git clone http://github.com/vecna/GL-virtual.git
	cd GL-virtual
	./virtual-environment-init.sh

then you will find running as a web service the following:

*  whistleblowing interface binds to http://172.16.254.2:8000
*  node administrator targets configuratation http://172.16.254.2:8000/globaleaks/admin/

those interface shall be present but only in debug mode (not enabled by default, edit globaleaks.conf by hand)

*  debug only global view interface: http://172.16.254.2:8000/globalview
*  web2py developer access: http://172.16.254.2:8000/admin password "globaleaks"

Basic Setup - mandatory configuration
-------------------------------------

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

*  administrastive password: required for login as GL node administrator


GlobaLeaks - Virtual Edition - Install Script ONLY
==================================================

GlobaLeaks is the first Open Source Whistleblowing Framework.

It empowers anyone to easily setup and maintain their own Whistleblowing platform. It is also a collection of what are the best practices for people receiveiving and submitting material. GlobaLeaks works in various environments: media, activism, corporations, public agencies.

## DISCLAIMER
## GlobaLeaks is under Development
## In this repository, there are only the script used to correctly generated GlobaLeaks01-UbuntuServer-11.00-VirtualBox
## If you're not interested in development or security check, maybe you need simply download the generated image here:

http://TODO

Installation
============

You need to download Oracle VirtualBox Manager from:
http://www.oracle.com/technetwork/server-storage/virtualbox/downloads/index.html

The following steps are required only if you want install GL environment in your virtual box. If you're using the image provided by GlobaLeaks, jump to the next step "Basic Setup"

You need setup the Host-only networking (File -> Preferences -> Network -> + Host-only Networks) the IP address expected is 172.16.254.1, and provide DHCP service in lower/upper both 172.16.254.2

You need to give routing from the VirtualBox to the outside:

	iptables -t nat -A POSTROUTING -s 172.16.254.0/24 -o $YOURDEFAULTGWINTERFACE -j MASQUERADE
	echo 1 > /proc/sys/net/ipv4/ip_forward

Oracle HowTo about setup the Host-only networking is here: http://www.virtualbox.org/manual/ch06.html#network_hostonly

(Is indifferent if you're installing GlobaLeaks Virtual in a desktop environment or in a server, so get the best VirtualBox manager for your needs)

and Ubuntu Server image for VirtualBox
http://downloads.sourceforge.net/project/virtualboximage/UbuntuServer/11.10/ubuntu-server-11.10-x86.7z?r=http%3A%2F%2Fvirtualboxes.org%2Fimages%2Fubuntu-server%2F&ts=1332109332&use_mirror=netcologne

login password: ubuntu/reverse (and "su" on it)

	git clone http://github.com/vecna/GL-virtual.git
	cd GL-virtual
	./virtual-environment-init.sh

then you will find running as a web service the following:

TODO

*  whistleblowing interface binds to http://127.0.0.1:8000
*  node administrator targets configuratation http://127.0.0.1:8000/globaleaks/admin/
*  debug only global view interface: http://127.0.0.1:8000/globalview
*  web2py developer access: http://127.0.0.1:8000/admin password "globaleaks"

Basic Setup - mandatory configuration
-------------------------------------

TODO

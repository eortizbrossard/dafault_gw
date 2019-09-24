#!/bin/bash -       
#title           :default_gw.sh
#description     : Add a static route as default gateway in the .1 address of the network segment configured in the interface. 
#author		     : eob
#date            :20190923
#version         :0.1
#usage		     :bash defautl_gw.sh
#notes           :Modify interface if necessary
#bash_version    :
#==============================================================================

change_gw () {

    # Stores the interface ip in variable 
    eth_ip=$(ifdata -pa $iface)

    # Separates the first three octets from the IP address and the address .1 is stored in its variable.
    ip_range=$(echo $eth_ip | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.')
    gw_ip=$(echo $ip_range'1')

    # Checks if there is a correct static route as default gateway for the interface. If it doesn't exist, configure the address stored in the variable gw_ip
    fail=$(route -n | grep -q $gw_ip; echo $?)
    if [ "$fail" -ne 0 ]; then
    	route add default gw $gw_ip wlan0
    fi
}

iface="$1"
if [ ! -n "$1" ]
then
    echo "$0 no interface parameter, setting eth0 as default"
	iface=$(echo 'eth0')
	change_gw
else
	echo "interface $1 set and now starting $0 shell script..."
	change_gw
fi
    

#!/bin/bash -       
#title           : default_gw.sh
#description     : Add a static route as default gateway in the .1 address of the network segment configured in the interface. 
#author		       : eob
#date            : 20190923
#version         : 0.1
#usage		       : bash defautl_gw.sh
#notes           : Modify interface if necessary
#bash_version    :
#==============================================================================
# Stores the interface ip in variable 
eth_ip=$(ifdata -pa eth0)

# Separates the first three octets from the IP address and the address .1 is stored in its variable.
ip_range=$(echo $eth_ip | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.')
gw_ip=$(echo $ip_range'1')

# Checks if there is a correct static path for the interface. If it doesn't exist, configure the address stored in the variable gw_ip
fail=$(route -n | grep -q $gw_ip; echo $?)
if [ "$fail" -ne 0 ]; then
	route add default gw $gw_ip wlan0
fi

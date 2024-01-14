#!/bin/bash

interface_name=$(ip route get 8.8.8.8 | awk '/dev/ {print $5; exit}')
local_ip=$(ip addr show $interface_name | awk '/inet / {split($2, a, "/"); print a[1]}' | grep -v '127.0.0.1')
ip=$((RANDOM % 99 + 101))

static_ip="${local_ip%.*}.${ip}"
netmask="255.255.255.0"
gateway=$(ip route show dev $interface_name | awk '/default via/ {print $3}')

# Backup the existing ifcfg file
cp /etc/sysconfig/network-scripts/ifcfg-$interface_name /etc/sysconfig/network-scripts/ifcfg-$interface_name.bak

# Update the ifcfg file
echo "TYPE=\"Ethernet\"" > /etc/sysconfig/network-scripts/ifcfg-$interface_name
echo "BOOTPROTO=\"static\"" >> /etc/sysconfig/network-scripts/ifcfg-$interface_name
echo "DEFROUTE=\"yes\"" >> /etc/sysconfig/network-scripts/ifcfg-$interface_name
echo "IPADDR=\"$static_ip\"" >> /etc/sysconfig/network-scripts/ifcfg-$interface_name
echo "NETMASK=\"$netmask\"" >> /etc/sysconfig/network-scripts/ifcfg-$interface_name
echo "GATEWAY=\"$gateway\"" >> /etc/sysconfig/network-scripts/ifcfg-$interface_name
echo "DNS1=\"8.8.8.8\"" >> /etc/sysconfig/network-scripts/ifcfg-$interface_name
echo "DNS2=\"8.8.4.4\"" >> /etc/sysconfig/network-scripts/ifcfg-$interface_name
echo "DEVICE=\"$interface_name\"" >> /etc/sysconfig/network-scripts/ifcfg-$interface_name
echo "ONBOOT=\"yes\"" >> /etc/sysconfig/network-scripts/ifcfg-$interface_name

# Restart the network service
systemctl restart network

# Optional: Display the updated configuration
cat /etc/sysconfig/network-scripts/ifcfg-$interface_name

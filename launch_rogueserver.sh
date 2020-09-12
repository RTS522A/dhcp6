#!/bin/bash

# interface to use
interface='h3-eth0'

# server ip configs
server_id=`ifconfig $interface | grep 'inet[^6]' | awk '{print $2}'`
netmask=`ifconfig $interface | grep 'netmask' | awk '{print $4}'`
gateway=$server_id
#route -n | grep $interface | grep UG | awk '{ print $2}'`
broadcast=`ifconfig $interface | grep 'broadcast' | awk '{print $6}'`

# address pool
first='10.1.1.21'
last='10.1.1.30'

# DHCP options (timers, in seconds)
pending_time=30
lease_time=3600
renewal_time=1800
rebinding_time=3000

# other DHCP options
dns_server=$server_id
domain='mynet.org'

./dhcpserver                                    \
    -o ROUTER,$gateway                          \
    -o SUBNET_MASK,$netmask                     \
    -o IP_ADDRESS_LEASE_TIME,$lease_time        \
    -o RENEWAL_T1_TIME_VALUE,$renewal_time      \
    -o REBINDING_T2_TIME_VALUE,$rebinding_time  \
    -o BROADCAST_ADDRESS,$broadcast             \
    -o DOMAIN_NAME,$domain                      \
    -o DOMAIN_NAME_SERVER,$dns_server           \
    -a $first,$last                             \
    -p $pending_time                            \
    -d $interface                               \
    $server_id

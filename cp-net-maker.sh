#!/bin/bash
_input="$1"
# set IFS (internal field separator) to |
# read file using while loop
while IFS=' ' read -r objname ip netmask
do
printf "create network $objname\n";
printf "modify network_objects $objname ipaddr $ip\n";
printf "modify network_objects $objname netmask $netmask\n";
done < "$_input"

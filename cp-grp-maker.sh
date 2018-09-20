#!/bin/bash
_input="$1"
# set IFS (internal field separator) to <space>
# read file using while loop
while IFS=' ' read -r objname ip netmask 
do
printf "addelement network_objects azure-$1 '' network_objects:$objname\n";
done < "$_input"

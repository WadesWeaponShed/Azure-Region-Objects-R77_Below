#!/bin/bash
echo Removing Old Public List Files
rm -- *.txt
rm PublicIPs_*
echo Downloading latest IP list
FIRSTLONGPART="https://download.microsoft.com/download/0/1/8/018E208D-54F8-44CD-AA26-CD7BC9524A8C/PublicIPs_"
INITIALURL="http://www.microsoft.com/EN-US/DOWNLOAD/confirmation.aspx?id=41653"
OUT="$(curl -s $INITIALURL | grep -o -E '('$FIRSTLONGPART').*(.xml)'|tail -1)"
wget -nv $OUT
region_count="$(xmlstarlet sel -t -c "count(//Region)" PublicIPs_*)" 
echo "There are $region_count regions"
for i in $(seq 1 $region_count)
do 
region_name="$(xmlstarlet sel -t -v "//Region[$i]/@Name" PublicIPs_*)"
echo Making Individual Files for Regions
xmlstarlet sel -t -v "//Region[$i]/IpRange/@Subnet" PublicIPs_*|awk '{gsub("/32"," 255.255.255.255");gsub("/31"," 255.255.255.254");gsub("/30"," 255.255.255.252");gsub("/29"," 255.255.255.248");gsub("/28"," 255.255.255.240");gsub("/27"," 255.255.255.224");gsub("/26"," 255.255.255.192");gsub("/25"," 255.255.255.128");gsub("/24"," 255.255.255.0");gsub("/23"," 255.255.254.0");gsub("/22"," 255.255.252.0");gsub("/21"," 255.255.248.0");gsub("/20"," 255.255.240.0");gsub("/19"," 255.255.224.0");gsub("/18"," 255.255.192.0");gsub("/17"," 255.255.128.0");gsub("/16"," 255.255.0.0");gsub("/15"," 255.254.0.0");gsub("/14"," 255.252.0.0");gsub("/13"," 255.248.0.0");gsub("/12"," 255.240.0.0");gsub("/11"," 255.224.0.0");gsub("/10"," 255.192.0.0");gsub("/9"," 255.128.0.0");gsub("/8"," 255.0.0.0");print}'|awk '{print "azure-'$region_name-'"$1, $1, $2}' > $region_name.txt;./cp-net-maker.sh $region_name.txt > ${region_name}-net-import.txt;echo "quit -update_all" >> ${region_name}-net-import.txt; ./cp-grp-maker.sh $region_name.txt > ${region_name}-group.txt;sed -e 's/\.txt//' ${region_name}-group.txt > ${region_name}-group-import.txt;sed -e 's/\.txt//' ${region_name}-group.txt > ${region_name}-group-import-update.txt;echo "update network_objects azure-$region_name" >> ${region_name}-group-import.txt;echo "create network_object_group azure-$region_name" | cat - ${region_name}-group-import.txt > temp && mv temp ${region_name}-group-import.txt;echo "quit -update_all" >> ${region_name}-group-import-update.txt;rm -- *group.txt
done
echo "Enjoy Your Files!"

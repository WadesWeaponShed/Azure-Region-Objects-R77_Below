##Overview##
The purpose of this code is to generate objects based on the Azure Public IP; Download Microsoft Azure Datacenter IP Ranges from Official Microsoft Download Center

The scripts were made for users of the R77 code that have to maintain Azure objects for rules.



##Description##
The code is to be used on systems 77.30 and below. For the R80 and above code please go here; Create objects for Azure Data-Center IP ranges - Python script

There are 3 scripts contained in the attached ZIP file. They are all Bash scripts;

Azure-get-public.sh – This is the main script you will execute. It will automatically download the latest Public_IP list from Microsoft and output the files needed for import.
Cp-grp-maker.sh – is called by the main script. This puts all the network objects into the dbedit format for a Simple Group
Cp-net-maker.sh – is called by the main script. Puts all subnets into the dbedit format for network objects.
Requires curl, wget, awk, cat, sed, and XMLSTARLET (this is used to parse Azure’s XML format)
The script will generate 3 dbedit files per Azure region;

Regionname-net-import.txt - Will create all the network objects for that region
Regionname-group-import.txt - Will create a simple group for that region and put all network objects for that region into the group.
Regionname-group-import-update.txt - This file is to be used to update groups that have already been built using the Regionname-net-import.txt script previously.


##Instructions##
Download the attached zip file.

Unzip the contents into a folder.

The script requires; curl, wget, awk, cat, sed, and XMLSTARLET (this is used to parse Azure’s XML format)

Ubuntu - apt-get install xmlstarlet
Mac - Use Homebrew - 'brew install xmlstarlet'
Exectute the script (make sure you have internet access) - ./azure-get-public.sh

The script will clean up any previous files from previous imports.
The script will call out to Microsoft to download the latest Public_IPs* list. Parses the XML for regions/subnets and puts them into a named file for each subnet and translates the Mask-length into a dotted format. Lastly, it runs those region files through the other scripts to create the dbedit outputs.
Default naming convention; NETWORK objects are named azure-regionname-x.x.x.x. GROUP objects are named azure-regionname.
The output is 3 dbedit files per Azure region;

Regionname-net-import.txt - Will create all the network objects for that region
Regionname-group-import.txt - Will create a simple group for that region and put all network objects for that region into the group.
Regionname-group-import-update.txt - This file is to be used to update groups that have already been built using the Regionname-net-import.txt script previously.


Move the files for each region you wish to create over to your Managment server. Follow the instructions in sk30383; Using a dbedit script to create new network objects and network object groups

##NOTE: You must always import the NETWORK file before importing the GROUP file.##



You can run this  NETWORK script multiple times for updates. Each time the script is run dbedit will skip over objects that are already made. The Regionname-group-import-update.txt file will be used to update group objects that are already created.

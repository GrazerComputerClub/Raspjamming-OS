#!/bin/bash -e
echo "This action will change the firmware of ESP-01(S) module to nodemcu with 13 modules."
echo "This script comes with ABSOLUTELY no warranty. Continue only if you know what you are doing."

while true; do
	read -p "Do you wish to continue? (yes/no): " yn
	case $yn in
		yes | Yes ) break;;
		no | No ) exit;;
		* ) echo "Please type yes or no.";;
	esac
done

shopt -s expand_aliases
source ~/.bash_aliases
source ~/.bash_aliases_GC2xHAT
espflashingon 
pushd /opt/nodemcu/ 
sudo esptool.py -p /dev/ttyAMA0 erase_flash
sudo esptool.py -p /dev/ttyAMA0 write_flash 0x00000 nodemcu-13m-int.bin
espflashingoff
popd

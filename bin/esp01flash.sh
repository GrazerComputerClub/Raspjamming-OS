#!/bin/bash -e
echo "This action will change the firmware of ESP-01(S) module (512+512 memory)."
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
pushd /opt/ESP8266_NONOS_SDK-2.2.1/bin/ 
sudo esptool.py -p /dev/ttyAMA0 write_flash 0x00000 boot_v1.7.bin 0x01000 at/512+512/user1.1024.new.2.bin 0xFB000 blank.bin 0xFC000 esp_init_data_default_v08.bin 0x7E000 blank.bin 0xFE000 blank.bin 
espflashingoff
popd

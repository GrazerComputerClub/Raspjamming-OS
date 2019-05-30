#!/bin/bash

dd if=/dev/zero bs=8k count=1 of=/dev/shm/8kblank.eep
eepmake /usr/local/bin/GC2-xHAT_eeprom_settings.txt /dev/shm/GC2-xHAT.eep
sudo eepflash.sh -d=0 -t=24c64 -w -f=/dev/shm/8kblank.eep
sudo eepflash.sh -d=0 -t=24c64 -w -f=/dev/shm/GC2-xHAT.eep
rm /dev/shm/8kblank.eep /dev/shm/GC2-xHAT.eep

#!/bin/bash

echo "searching for raspberrypi.local... " 
echo -n "Status: " 
ping -c 1 raspberrypi.local > /dev/null 2>&1  
if [ $? -eq 0 ]; then
  echo "Raspberry Pi found"
else
  echo "Raspberry Pi not found, please connect board"
  exit 1
fi
echo

echo Detecting connected network devices...
for connection in $(nmcli d | egrep "  connected|  verbunden" | awk '{print $1;}') 
do
  echo -n Probing connection ${connection}...
  if [ $(ifconfig ${connection} | egrep "01:02:03:04:|enp0s20u|192.168.138." | wc -l) -gt 0 ]; then
    RPiConnection=$connection
    #LocalRPiIp=$(ifconfig $connection | grep "inet " | cut -d ':' -f 2 | cut -d ' ' -f 1)
    LocalRPiIp=$(ifconfig $connection | awk '/inet / {print $2}')
    echo "found Raspberry Pi connected to local IP: $LocalRPiIp"  
  else
    # Hopefully there is just another connected device
    # Otherwise we asume that all connected devices except
    # the RPi connection has access to the internet
    InetDevice=$connection
    echo found inet Device
  fi
done

if [ -z $RPiConnection ] ; then
  echo Raspberry Pi network device not found
  exit
fi

echo
echo Activate Internet forward on host \(executed as root\)...
echo -n "sudo sysctl -w net.ipv4.ip_forward=1 > "
sudo sysctl -w net.ipv4.ip_forward=1
echo sudo iptables -t nat -A POSTROUTING -o $InetDevice -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o $InetDevice -j MASQUERADE
echo

echo "Connecting to Raspberry Pi and set gateway to host (${LocalRPiIp})"
echo --------------------------------------------------------------
echo Please enter password of Raspberry Pi user \'pi\' :
echo --------------------------------------------------------------

ssh -X  pi@raspberrypi.local -t "sudo route add default gw ${LocalRPiIp} ; bash -login"


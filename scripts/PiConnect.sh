#!/bin/bash

CONNECT_NAME="raspberrypi.local"
BOARD_NAME="Raspberry Pi"
echo "searching for ${BOARD_NAME} (${CONNECT_NAME})... " 
echo -n "Status: " 
ping -c 1 ${CONNECT_NAME} > /dev/null 2>&1  
if [ $? -eq 0 ]; then
  echo "Raspberry Pi found"
else
  echo "Raspberry Pi not found"
  CONNECT_NAME="bananapi.local"
  BOARD_NAME="Banana Pi"
  echo "searching for ${BOARD_NAME} (${CONNECT_NAME})... " 
  echo -n "Status: " 
  ping -c 1 ${CONNECT_NAME} > /dev/null 2>&1  
  if [ $? -eq 0 ]; then
    echo "Banana Pi found"
  else
    echo -e "\nRaspberry/Banana Pi not found, please connect board"
    exit 1
  fi
fi
echo

echo Detecting connected network devices...
for connection in $(nmcli d | egrep "  connected|  verbunden" | awk '{print $1;}') 
do
  echo -n Probing connection ${connection}...
  if [ $(ifconfig ${connection} | egrep "01:02:03:04:|enp0s20u|192.168.138." | wc -l) -gt 0 ]; then
    RPiConnection=$connection
    #LocalRPiIp=$(ifconfig $connection | grep "inet " | cut -d ':' -f 2 | cut -d ' ' -f 1)
    LocalRPiIp=$(ifconfig $connection | awk '/inet / {print $2}' | sed 's/.*://g')
    echo "found ${BOARD_NAME} connected to local IP: $LocalRPiIp"  
  else
    # Hopefully there is just another connected device
    # Otherwise we asume that all connected devices except
    # the RPi connection has access to the internet
    InetDevice=$connection
    echo found inet Device
  fi
done

echo
if [ -z $RPiConnection ] ; then
  echo ${BOARD_NAME} network device not found, no internet forward to host
  
  echo
  echo "Connecting to ${BOARD_NAME}"
  echo --------------------------------------------------------------
  echo Please enter password of ${BOARD_NAME} user \'pi\' :
  echo --------------------------------------------------------------

  ssh -X  pi@${CONNECT_NAME}
else
  echo Activate Internet forward on host \(executed as root\)...
  echo -n "sudo sysctl -w net.ipv4.ip_forward=1 > "
  sudo sysctl -w net.ipv4.ip_forward=1
  echo sudo iptables -t nat -A POSTROUTING -o $InetDevice -j MASQUERADE
  sudo iptables -t nat -A POSTROUTING -o $InetDevice -j MASQUERADE

  echo
  echo "Connecting to ${BOARD_NAME} and will set gateway to host (${LocalRPiIp})"
  echo --------------------------------------------------------------
  echo Please enter password of ${BOARD_NAME} user \'pi\' :
  echo --------------------------------------------------------------

  ssh -X  pi@${CONNECT_NAME} -t "sudo route add default gw ${LocalRPiIp} ; bash -login"
fi



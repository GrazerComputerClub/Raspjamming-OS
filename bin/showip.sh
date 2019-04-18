#!/bin/bash
gpio mode 4 in
gpio mode 5 in
GPIO23=`gpio read 4`
GPIO24=`gpio read 5`
if [ ${GPIO23} -eq 1 ] && [ ${GPIO24} -eq 1 ]; then
  # Both pins DATA, CLK are pull up by TM1637 board
  echo looks like TM1637 is connected, starting service ipshow
  service showip start
else
  echo looks like TM1637 is not connected
fi


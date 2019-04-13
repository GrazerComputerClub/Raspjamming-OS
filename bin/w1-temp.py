#!/usr/bin/python
# -*- coding: utf-8 -*-

# read slave list from master 1
file = open('/sys/devices/w1_bus_master1/w1_master_slaves')
w1_slaves = file.readlines()
file.close()

# for each slave
for line in w1_slaves:
  # get slave id
  w1_slave = line.split("\n")[0]
  # read temp from slave id
  file = open('/sys/bus/w1/devices/' + str(w1_slave) + '/w1_slave')
  filecontent = file.read()
  file.close()
  # calc and show temp
  stringvalue = filecontent.split("\n")[1].split(" ")[9]
  temperature = float(stringvalue[2:]) / 1000

  print('%4.1f °C' % temperature)


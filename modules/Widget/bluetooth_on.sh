#!/bin/bash
check=$(bluetoothctl show | awk '/Powered/ {print $2}')
if [ "$check" == "yes" ];then 
    bluetoothctl power off
else
    bluetoothctl power on
fi
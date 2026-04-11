#!/bin/bash
check=$(nmcli radio wifi)
if [ "$check" == "enabled" ];then 
    nmcli radio wifi off
else
    nmcli radio wifi on
fi
#!/bin/bash
check=$(nmcli networking)
if [ "$check" == "enabled" ];then 
    nmcli networking off
else
    nmcli networking on
fi
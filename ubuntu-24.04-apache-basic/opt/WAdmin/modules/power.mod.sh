#!/bin/bash
#Samba Module File
#Don't edit it!
echo "Executing actions on Power module"
ModDo="$(cat $WorkingDir/$Do)"
Action=$(echo $ModDo | cut -d '|' -f 1)
Param=$(echo $ModDo | cut -d '|' -f 2)
[ -n "Action" ] && [ "$Action" == "restart" ] && ./scripts/samba-umount.sh && echo 'restart' > /tmp/.WAR/power.do
[ -n "Action" ] && [ "$Action" == "shutdown" ] && ./scripts/samba-umount.sh && echo 'shutdown' > /tmp/.WAR/power.do
#echo "Action -> $Action"
#echo "Parameter -> $Param"
rm $WorkingDir/$Do

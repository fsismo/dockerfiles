#!/bin/bash
#OpenVPN Module File
#Don't edit it!
echo "Executing actions on OpenVPN module"

#Get data from file
ModDo="$(cat $WorkingDir/$Do)"
Action=$(echo $ModDo | cut -d '|' -f 1)
User=$(echo $ModDo | cut -d '|' -f 2)
Mail=$(echo $ModDo | cut -d '|' -f 3)

#Check what to do
[ -n "Action" ] && [ "$Action" == "AddUser" ] && [ -n "$User" ]  && [ -n "$Mail" ] && ./scripts/openvpn-tools.sh -a -u $User -m $Mail -e 3650
[ -n "Action" ] && [ "$Action" == "RevokeUser" ] && [ -n "$User" ] && ./scripts/openvpn-tools.sh -r -u $User 

#echo "Action -> $Action"
#echo "Parameter -> $Param"
rm $WorkingDir/$Do

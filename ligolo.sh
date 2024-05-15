#!/bin/bash

echo "██╗     ██╗ ██████╗  ██████╗ ██╗      ██████╗      ██████╗ ██████╗ ███╗   ██╗███╗   ██╗███████╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗"
echo "██║     ██║██╔════╝ ██╔═══██╗██║     ██╔═══██╗    ██╔════╝██╔═══██╗████╗  ██║████╗  ██║██╔════╝██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║"
echo "██║     ██║██║  ███╗██║   ██║██║     ██║   ██║    ██║     ██║   ██║██╔██╗ ██║██╔██╗ ██║█████╗  ██║        ██║   ██║██║   ██║██╔██╗ ██║"
echo "██║     ██║██║   ██║██║   ██║██║     ██║   ██║    ██║     ██║   ██║██║╚██╗██║██║╚██╗██║██╔══╝  ██║        ██║   ██║██║   ██║██║╚██╗██║"
echo "███████╗██║╚██████╔╝╚██████╔╝███████╗╚██████╔╝    ╚██████╗╚██████╔╝██║ ╚████║██║ ╚████║███████╗╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║"
echo "╚══════╝╚═╝ ╚═════╝  ╚═════╝ ╚══════╝ ╚═════╝      ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝"

echo "Developed by ezio (KR45) and R0ttCyph3r "
        
 
 user=$(ls -l /home | grep '^d' | awk '{print $NF}')                                                                                                                            

if ifconfig | grep -q "ligolo"; then
    echo "ligolo interface already exists"
    echo "$user"
else
    # Run the command to add ligolo if it doesn't exist
   
   echo "$user"
   sudo ip tuntap add user $user mode tun ligolo
   sudo ip link set ligolo up
    
    # Check if the ip route command was successful
    if [ $? -ne 0 ]; then
        echo "Device exists"
        exit 1
    fi
fi




read -p "Enter Subnet : "  sub

if ip route show | grep -q "$sub"; then
    echo "Subnet $sub already exists in the routing table"

else
    # Add route for the subnet
    sudo ip route add "$sub" dev ligolo
    
    # Check if the ip route command was successful
    if [ $? -ne 0 ]; then
        echo "Failed to add route for subnet: $sub"
        exit 1
    fi
fi


read -p "Enter Port : ?"  port
/usr/bin/proxy -selfcert -laddr 0.0.0.0:$port


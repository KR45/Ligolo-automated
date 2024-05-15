#!/bin/bash

echo
echo -e "\e[32m██╗     ██╗ ██████╗  ██████╗ ██╗      ██████╗      █████╗ ██╗   ██╗████████╗ ██████╗ ███╗   ███╗ █████╗ ████████╗███████╗██████╗ \e[0m"
echo -e "\e[32m██║     ██║██╔════╝ ██╔═══██╗██║     ██╔═══██╗    ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗████╗ ████║██╔══██╗╚══██╔══╝██╔════╝██╔══██╗\e[0m"
echo -e "\e[32m██║     ██║██║  ███╗██║   ██║██║     ██║   ██║    ███████║██║   ██║   ██║   ██║   ██║██╔████╔██║███████║   ██║   █████╗  ██║  ██║\e[0m"
echo -e "\e[32m██║     ██║██║   ██║██║   ██║██║     ██║   ██║    ██╔══██║██║   ██║   ██║   ██║   ██║██║╚██╔╝██║██╔══██║   ██║   ██╔══╝  ██║  ██║\e[0m"
echo -e "\e[32m███████╗██║╚██████╔╝╚██████╔╝███████╗╚██████╔╝    ██║  ██║╚██████╔╝   ██║   ╚██████╔╝██║ ╚═╝ ██║██║  ██║   ██║   ███████╗██████╔╝\e[0m"
echo -e "\e[32m╚══════╝╚═╝ ╚═════╝  ╚═════╝ ╚══════╝ ╚═════╝     ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═════╝ \e[0m"

echo
echo -e "\e[1;35mDeveloped by ezio (KR45) and R0ttCyph3r\e[0m"
echo
user=$(ls -l /home | grep '^d' | awk '{print $NF}')                                                                                                                            

if ifconfig | grep -q "ligolo"; then
    echo -e "\e[34mligolo interface already exists\e[0m"
    echo -e "\e[34m$user\e[0m"
else
    echo -e "\e[34m$user\e[0m"
    sudo ip tuntap add user $user mode tun ligolo
    sudo ip link set ligolo up
    
    if [ $? -ne 0 ]; then
        echo -e "\e[34mDevice exists\e[0m"
        exit 1
    fi
fi

echo
read -p $'\e[32mEnter Subnet (leave empty to skip): \e[0m'  sub

if [ -n "$sub" ]; then
    if ip route show | grep -q "$sub"; then
        echo -e "\e[34mSubnet $sub already exists in the routing table\e[0m"
    else
        sudo ip route add "$sub" dev ligolo
        
        if [ $? -ne 0 ]; then
            echo -e "\e[41mFailed to add route for subnet: $sub\e[41m"
            exit 1
        fi
    fi
fi

echo
read -p $'\e[32mEnter Port : \e[0m'  port
echo

read -p $'\e[32mEnter IP for agent (eg: 10.10.x.x OR tun0) : \e[0m' ip

if [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "\e[34mUsing provided IP address: $ip\e[0m"
elif ip addr show $ip &> /dev/null; then
    ip=$(ip addr show $ip | awk '/inet / {print $2}' | cut -d "/" -f 1)
    echo -e "\e[34mUsing IP address of interface $ip\e[0m"
else
    echo -e "\e[41mInvalid input. Please enter either an IP address or an interface name.\e[41m"
    exit 1
fi

echo
echo -e "\e[1;31mLinux: ./agent -connect $ip:$port -ignore-cert\e[0m"
echo -e "\e[1;31mWindows: .\\\agent.exe -connect $ip:$port -ignore-cert\e[0m"
echo

/usr/bin/ligolo-proxy -selfcert -laddr 0.0.0.0:$port 

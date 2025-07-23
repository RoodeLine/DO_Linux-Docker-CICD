#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

clear
echo "Installing ipcalc..."
{
    sudo apt-get install ipcalc -Y
} &> /dev/null

echo -e "${GREEN}Installing complit\n${NC}"

IP=$(ip a | grep "inet.*enp0s3\|inet.*eth0" | awk '{printf("%s", $2)}' | sed 's/...$//')

echo "HOSTNAME        = $(hostname)"
echo "TIMEZONE        = $(timedatectl | awk ' /Time zone/ {print $3, "UTC", $5}' | sed 's/...$//')"
echo "USER            = $(whoami)"
echo "OS              = $(lsb_release -ds)"
echo "DATE            = $(date +"%d %b %Y %H:%M:%S")"
echo "UPTIME          = $(uptime -p)"
echo "UPTIME_SEC      = $(awk '{printf("%s", $1)}' /proc/uptime)"
echo "IP              = $IP"
echo "MASK            = $(ipcalc $IP | awk 'NR==2{printf("%s", $2)}')"
echo "GATEWAY         = $(ip rout | awk '/default/ {printf("%s", $3)}')"
echo "RAM_TOTAL       = $(free | awk '/Mem:/ { printf "%.3f", $2 / 1024 / 1024}') GB"
echo "RAM_USED        = $(free | awk '/Mem:/ { printf "%.3f", $3 / 1024 / 1024}') GB"
echo "RAM_FREE        = $(free | awk '/Mem:/ { printf "%.3f", $4 / 1024 / 1024}') GB"
echo "SPACE_ROOT      = $(df / | awk 'NR==2{printf("%.2f", $2 / 1024)}') MB"
echo "SPACE_ROOT_USED = $(df / | awk 'NR==2{printf("%.2f", $3 / 1024)}') MB"
echo "SPACE_ROOT_FREE = $(df / | awk 'NR==2{printf("%.2f", $4 / 1024)}') MB"
echo ""
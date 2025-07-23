#!/bin/bash

white_b="\033[107m"
red_b="\033[41m"
green_b="\033[42m"
blue_b="\033[44m"
purple_b="\033[45m"
black_b="\033[40m"

white_f="\033[37m"
red_f="\033[31m"
green_f="\033[32m"
blue_f="\033[34m"
purple_f="\033[35m"
black_f="\033[30m"

reset="\e[0m"

arr1[0]=$1           #background_name
arr1[1]=$2           #font_name
arr1[2]=$3           #background_value
arr1[3]=$4           #font_value

# Установка цвета фона
for i in 0 2
do
if [[ ${arr1[$i]} == 1 ]]
    then
    arr2[$i]=$white_b
elif [[ ${arr1[$i]} == 2 ]]
    then
    arr2[$i]=$red_b
elif [[ ${arr1[$i]} == 3 ]]
    then
    arr2[$i]=$green_b
elif [[ ${arr1[$i]} == 4 ]]
    then
    arr2[$i]=$blue_b
elif [[ ${arr1[$i]} == 5 ]]
    then
    arr2[$i]=$purple_b
elif [[ ${arr1[$i]} == 6 ]]
    then
    arr2[$i]=$black_b
fi
done

# Установка цвета шрифта
for i in 1 3
do
if [[ ${arr1[$i]} == 1 ]]
    then
    arr2[$i]=$white_f
elif [[ ${arr1[$i]} == 2 ]]
    then
    arr2[$i]=$red_f
elif [[ ${arr1[$i]} == 3 ]]
    then
    arr2[$i]=$green_f
elif [[ ${arr1[$i]} == 4 ]]
    then
    arr2[$i]=$blue_f
elif [[ ${arr1[$i]} == 5 ]]
    then
    arr2[$i]=$purple_f
elif [[ ${arr1[$i]} == 6 ]]
    then
    arr2[$i]=$black_f
fi
done

clear
echo "Installing ipcalc..."
{
    sudo apt-get install ipcalc -Y
} &> /dev/null

echo -e "${green_f}Installing complit\n $reset"

IP=$(ip a | grep "inet.*enp0s3\|inet.*eth0" | awk '{printf("%s", $2)}' | sed 's/...$//')

echo -e "${arr2[0]}${arr2[1]}HOSTNAME        = ${arr2[2]}${arr2[3]} $(hostname)$reset"
echo -e "${arr2[0]}${arr2[1]}TIMEZONE        = ${arr2[2]}${arr2[3]} $(timedatectl | awk ' /Time zone/ {print $3, "UTC", $5}' | sed 's/...$//') $reset"
echo -e "${arr2[0]}${arr2[1]}USER            = ${arr2[2]}${arr2[3]} $(whoami)$reset"
echo -e "${arr2[0]}${arr2[1]}OS              = ${arr2[2]}${arr2[3]} $(lsb_release -ds)$reset"
echo -e "${arr2[0]}${arr2[1]}DATE            = ${arr2[2]}${arr2[3]} $(date +"%d %b %Y %H:%M:%S")$reset"
echo -e "${arr2[0]}${arr2[1]}UPTIME          = ${arr2[2]}${arr2[3]} $(uptime -p)$reset"
echo -e "${arr2[0]}${arr2[1]}UPTIME_SEC      = ${arr2[2]}${arr2[3]} $(awk '{printf("%s", $1)}' /proc/uptime)$reset"
echo -e "${arr2[0]}${arr2[1]}IP              = ${arr2[2]}${arr2[3]} $IP$reset"
echo -e "${arr2[0]}${arr2[1]}MASK            = ${arr2[2]}${arr2[3]} $(ipcalc $IP | awk 'NR==2{printf("%s", $2)}')$reset"
echo -e "${arr2[0]}${arr2[1]}GATEWAY         = ${arr2[2]}${arr2[3]} $(ip rout | awk '/default/ {printf("%s", $3)}')$reset"
echo -e "${arr2[0]}${arr2[1]}RAM_TOTAL       = ${arr2[2]}${arr2[3]} $(free | awk '/Mem:/ { printf "%.3f", $2 / 1024 / 1024}') GB$reset"
echo -e "${arr2[0]}${arr2[1]}RAM_USED        = ${arr2[2]}${arr2[3]} $(free | awk '/Mem:/ { printf "%.3f", $3 / 1024 / 1024}') GB$reset"
echo -e "${arr2[0]}${arr2[1]}RAM_FREE        = ${arr2[2]}${arr2[3]} $(free | awk '/Mem:/ { printf "%.3f", $4 / 1024 / 1024}') GB$reset"
echo -e "${arr2[0]}${arr2[1]}SPACE_ROOT      = ${arr2[2]}${arr2[3]} $(df / | awk 'NR==2{printf("%.2f", $2 / 1024)}') MB$reset"
echo -e "${arr2[0]}${arr2[1]}SPACE_ROOT_USED = ${arr2[2]}${arr2[3]} $(df / | awk 'NR==2{printf("%.2f", $3 / 1024)}') MB$reset"
echo -e "${arr2[0]}${arr2[1]}SPACE_ROOT_FREE = ${arr2[2]}${arr2[3]} $(df / | awk 'NR==2{printf("%.2f", $4 / 1024)}') MB$reset"
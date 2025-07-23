#!/bin/bash

echo "Installing bc..."
{
    sudo apt install bc -Y
} &> /dev/null

echo -e "${green_f}Installing complit\n $reset"

clear

directory=$1

start_time=$(date +%s.%N)

echo "Total number of folders (including all nested ones) = $(($(find "$directory" -type d | wc -l) - 1))"

# Вывод топ 5 папок максимального размера, расположенных в порядке убывания
echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
echo "$(du -h $directory | sort -rh | head -6 | tail -n 5| awk '{print "- " $2", "$1"b"}' |nl)"

echo "Total number of files = $(find "$directory" -type f | wc -l)"

echo "Number of:"
echo "Configuration files (with the .conf extension)   = $(find $directory -name "*.conf" | wc -l)"
echo "Text files                                       = $(find $directory -name "*.txt" | wc -l)"
echo "Executable files                                 = $(find $directory -type f -executable | wc -l)"
echo "Log files (with the extension .log)              = $(find $directory -name "*.log" | wc -l)"
echo "Archive files                                    = $(find $directory -name '*.tar' -name '*.zip' -name '*.7z' -name '*.rar' -name '*.gz' | wc -l)"
echo "Symbolic links                                   = $(find $directory -type l | wc -l)"

# Вывод топ-10 файлов максимального размера, расположенных в порядке убывания
echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
echo "$(find "$directory" -type f -exec ls -lh {} + | sort -k5,5 -rh |
    head -10 | awk -F '[^[:alpha:]]' '{ print $0,$NF }' | awk '{print "- " $9", "$5"b"", "$10}' | nl)"

# Вывод топ-10 исполняемых файлов максимального размера
echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
top_executable=$(find $directory -type f -executable -exec du -h {} + | sort -rh | head -10 | awk '{print $2}')

number=0
for path in ${top_executable[*]}
do
    number=$(( $number + 1 ))
    echo "     $number  - "$(find $path -type f -exec du -h {} + | awk '{printf "%s, %s", $2, $1}')"b, "$(md5sum $path | awk '{print $1}')
done

end_time=$(date +%s.%N)
all_time=$(echo "$end_time - $start_time" | bc -l)
all_time=$(printf "%.1f" "$all_time")
echo "Script execution time (in seconds) = $all_time"
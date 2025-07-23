#!/bin/bash

read -p "Хотите записать данные в файл? (Y/N): " choice
if [[ $choice =~ ^[Yy]$ ]]; then
    file=$(date +"%d_%m_%y_%H_%M_%S.status")
    ./get_info.sh > $file
    tail -n +4 "$file" > "$file.tmp" && mv "$file.tmp" "$file"
else
    echo "Вы отказались от записи данных в файл."
fi

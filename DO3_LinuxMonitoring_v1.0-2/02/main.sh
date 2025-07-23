#!/bin/bash

if [ $# -gt 0 ]; then
    echo "Некорректный ввод: параметры не требуются." >&2
else
    sudo chmod -R +x ./
    ./get_info.sh
    ./write_file.sh
fi
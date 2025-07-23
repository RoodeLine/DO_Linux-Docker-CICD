#!/bin/bash

if [ $# -gt 0 ]; then
    echo "Некорректный ввод: параметры не требуются." >&2
else
    sudo chmod +x info_color.sh
    ./info_color.sh
fi

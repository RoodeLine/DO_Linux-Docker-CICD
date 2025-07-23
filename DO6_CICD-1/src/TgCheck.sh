#!/bin/bash

TOKEN="7875451479:AAF6c9eurGZjIgPJSdTslol0OZ982EHwzxc"
USER_ID=1068755021
TIME=10
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

TEXT="Этап $1 > $CI_JOB_NAME $CI_JOB_STATUS >> $CI_PROJECT_URL/pipelines/$CI_PIPELINE_ID"
response=$(curl -s --max-time $TIME -d "chat_id=$USER_ID&disable_web_page_preview=1&text=$TEXT" $URL)

if [[ $response != *'"ok":true'* ]]; 
    then
        echo "Ошибка: Telegram API вернуло ошибку: $response"
        exit 1
fi

echo "Сообщение успешно отправлено!"
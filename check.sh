#!/usr/bin/env bash
set -Eeuo pipefail
APP_MESSAGE=$(curl -sf http://127.0.0.1:8080)
#Проверка автозапуска
if systemctl is-enabled --quiet lf-app.service; then
    echo "Сервис в автозапуске"
else
    echo "Сервис отсутствует в автозапуске"
    exit 1
fi

#Проверка работоспособности сервиса
if systemctl is-active --quiet lf-app.service; then
    echo "Сервис работает"
else
    echo "Сервис не работает"
    exit 1
fi
echo "----------------------------------------------------------------"

if [[ "$APP_MESSAGE" == "Linux Factory работает" ]]; then
    echo "Вывод APP_MESSAGE корректен - $APP_MESSAGE"
else
    echo "APP_MESSAGE не соответствует: '$APP_MESSAGE'"
    exit 1
fi
echo "----------------------------------------------------------------"


#!/usr/bin/env bash
set -Eeuo pipefail

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
# Проверяем успешен ли запрос
echo "Вывод APP_MESSAGE - $(curl -sf http://127.0.0.1:8080)"

echo "----------------------------------------------------------------"


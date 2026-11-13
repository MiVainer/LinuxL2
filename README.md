# Запуск сервиса
## Создаём системного пользователя.  
`sudo useradd --system --user-group --shell /usr/sbin/nologin lfapp`  

## Создаём директорию и файлы сервиса, накидываем права  
`sudo install -d -m 0750 -o root -g lfapp /opt/lf-app  `
`sudo install -d -m 0750 -o root -g lfapp /etc/lf-app`

Создаем файл lf-app.env
`sudo tee /etc/lf-app/lf-app.env >/dev/null <<'EOF'
PORT=8080
APP_MESSAGE="Linux Factory работает"
EOF

Копируем файл app.py в каталог /opt/lf-app
Копируем файл lf-app.service в каталог /etc/systemd/system

## Накидываем права
`sudo chown root:lfapp /opt/lf-app/app.py`
`sudo chmod 640 /opt/lf-app/app.py`
`sudo chown root:lfapp /etc/lf-app/lf-app.env`
`sudo chmod 640 /etc/lf-app/lf-app.env`

## Проверяем конфигурацию сервиса и добавляем в автозапуск
`sudo systemd-analyze verify /etc/systemd/system/lf-app.service`
`sudo systemctl daemon-reload`
`sudo systemctl enable --now lf-app`

## Проверяем статус и работу сервиса
`systemctl is-enabled lf-app`
`systemctl is-active lf-app`
`curl -f http://localhost:8080`
`journalctl -u lf-app -n 10 --no-pager`


## Проверяем работает ли сервис:  
`bash check.sh`  
`echo $?`  
если вывело 0 значит все ок.  


# Возможные инциденты и пути решения:  
## 1. Неверно указан путь к приложению в ExecStart  
`curl -f http://localhost:8080`
curl: (7) Failed to connect to localhost port 8080 after 0 ms: В соединении отказано  

## Диагностика:  
`systemctl status lf-app --no-pager -l`   
видим что сервис лежит
## Указание на ошибку
journalctl -u lf-app -n 10 --no-pager
ноя 12 10:27:23 NoutMH lf-app[237614]: /usr/bin/python3: can't open file '/opt/lf-app/1/app.py': [Errno 2] No such file or directory

## Решение:
корректируем размещение файла app.py
sudo sed -i '/^ExecStart=/ s#=.*#=/usr/bin/python3 /opt/lf-app/app.py#' /etc/systemd/system/lf-app.service
выполняем команду
`sudo systemctl daemon-reload`
`sudo systemctl reset-failed lf-app`
`sudo systemctl restart lf-app`
## Проверка:  
`bash check.sh`  
`echo $?`  




## 2. Отсутствует или переименован файл lf-app.env  
вывод команды `systemctl status lf-app` указывает на то что сервис не работает, и возникли ошибки  

## Диагностика:  
`journalctl -u lf-app -n 10 --no-pager`  
lf-app.service: Failed to load environment files: No such file or directory 


`sudo ls -la /etc/lf-app`
проверяем что именно не так с файлом env  

## Решение:
sudo mv /etc/lf-app/lf-app.env1 /etc/lf-app/lf-app.env

`systemctl restart lf-app`  
оживляем сервис  

## Проверка:  
`bash check.sh`  
`echo $?`  

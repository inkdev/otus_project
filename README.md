OTUS-project
* [Описание проекта](#Описание-проекта)
* [Как запустить проект](#Как-запустить-проект)
* [Структура проекта](#Структура-проекта)
* [Что было реализовано в проекте](#Что-было-реализовано-в-проекте)
# Описание проекта
Проект представляет собой контейнеризированное приложение crawler, позволяющее парсить сайты по ключевым словам. Контейнеры  развернуты с помощью  docker-compose,
настроен процесс CI/CD для кода приложения. Настроен мониторинг с помощью Prometheus, метрики визаулизированы с помощью grafana. Автоматизирован процесс поднятия инфраструктуры с помощью terraform и packer

Основные компоненты проекта:
- crawler-app бекенд приложения
- crawler-ui user-interface
- mongo_db БД MongoDB
- rabbit_mq брокер сообщений
- gitlab-ci SVC и CI/CD
- prometheus-бекенд для сбора метрик
- grafana-фронтенд для визуализации метрик
- node-exporter-агент для мониторинга собственно сервера prometheus
- cadvisor-мониторинг развернутых контейнеров


# Как запустить проект
1. Настройка GCP. 
 - Создать проект в GCP
 - Создать входящие правила фаерволла для разрешения работы(пока не завернуто в Terraform)
  - rabbitmq-web-access: tcp-15672
  - crawler-ui: tcp-8000
  - crawler-monitoring: tcp-9090, tcp-3000, tcp-8080
  - gitlab-web: 8900
 - Создаем метаданные проекта, экспортируем публичный ключ appuser.pub в метаданные проекта
2. Настройка и автоматический запуск инфраструктуры. Меняем файлы конфигурации 
 - /terraform  mv terraform.tfvars.example terraform.tfvars заполняем поля в соответствии с данными своего проекта
 - /packer mv variables.example.json variables.json заполняем поля в соответствии с данными своего проекта
 - /.env mv .env.example .env заполняем поля в соответствии с данными своего проекта
3. Переходим в /terraform, выполняем
```
terraform init && terraform apply --auto-approve=true
```
- Дожидаемся поднятия инфраструктуры(WARN: gitlab подниматеся около 7-10 минут)
- Проверяем доступ к приложениям 
 
Доступ к приложениям
Crawler: http://ip:8000
Gitlab: http://ip:8900
Prometheus: http://ip:9090
Grafana: http://ip:3000
Cadvisor: http://ip:8080
- Проверяем работоспособность приложения Crawler, вводим слово или фразу, получаем список ссылок
4. Настройка gitlab
 - Заходим по адресу приложения gitlab http://ip:8900, устанавливаем логин/пароль root/secretsecret
 - Создаем группу crawler и проект crawler-project
 - В папке проекта выполняем
 ```
 git init
 git remote add origin http://ip:8900/crawler/crawler-project.git
 git add .
 git commit -m 'Initial commit'
 git push -u origin master
 ``` 
 - Для деплоя контейнеров необходима учетная запись на docker-hub. Создаем ее в Settings-CI/CD-Variables
 CI_REGISTRY_USER
 CI_REGISTRY_PASSWORD 
 - Для запуска процесса CI/CD необходим раннер. Заходим по ssh на crawler хост, выполняем
 ```
 docker run -d --name gitlab-runner --restart always \
-v /srv/gitlab-runner/config:/etc/gitlab-runner \
-v /var/run/docker.sock:/var/run/docker.sock \
gitlab/gitlab-runner:latest 
 ```
- Регистрируем раннер 

5. Проверка мониторинга
 - Prometheus. Проверяем работоспособность метрик
 - Grafana. Заходим по адресу http://ip:3000. login/password admin/secretsecret. Проверяем наличие дашбоарда Crawler_metrics с графиками 'Web page generate time bucket' и 'Count of served web-pages'. Не забыть сгененрировать страничку в приложении Crawler и поставить источник метрик в графиках
 - Cadvisor. Проверяем состояние контейнеров


# Структура проекта

- crawler-app #приложение crawler и dockerfile для него
- crawler-ui  #приложение ui и dockerfile для него
- monitoring  #хранилище конфигураций Prometheus и Grafana
- monitoring/prometheus/grafana/Dashboards #каталог с конфигурацией дашбоарда для grafana
- packer      #папка с конфигурацией образа для packer
- terraform   #папка с конфигурацией для terraform
- docker-compose-crawler.yml #манифест со сценарием поднятия контейнеров для приложения
- docker-compose-gitlab.yml #манифест со сценарием поднятия контейнеров для gitlab
- docker-compose-monitoring.yml #манифест со сценарием поднятия контейнеров для мониторинга
- gitlab-ci.yml #манифест со сценарием поднятия контейнера для gitlab
- install_docker_script.sh #скрипт с инсталляцией docker и docker-compose
- install_playbook.sh #скрипт с запуском сценариев для docker-compose


# Что было реализовано в проекте

1. Контейнеризация. Приложения crawler-search-engine и crawler-search-ui контейниризированы в соответствующие контейнеры crawler-app и crawler-ui
2. Контейнеризация. Настроено автоматическое развертывание контейнеров с помощью сценариев docker-compose-*.yml
3. IaC. Настроен образ для докер-хоста crawler. С помощью packer в состав образа запечены сценарии 
- docker-compose-crawler.yml
- docker-compose-gitlab.yml
- docker-compose-monitoring.yml,
скрипт для развертывания docker и docker-compose
4. IaC. C помощью terraform на основе образа packer-full развернут инстанс crawler в качестве хост-машины для контейнеров. В состав манифеста включен скрипт для автоматического запуска плейбуков docker-compose-*.yml 
5. CI/CD. C помощью Gitlab Настроен процесс CI/CD: настроено тестирование приложений crawler-search-engine и crawler-search-ui и автоматический деплой контейнеров при изменении кода
6. Monitoring. В качестве бекенда для получения метрик задействован Prometheus. Метрики визуализированы с помощью grafana




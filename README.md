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

Доступ к приложениям
Crawler: http://ip:8000
Gitlab: http://ip:8900
Prometheus: http://ip:9090
Grafana: http://ip:3000

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




# img-spectru

`img-spectru` is a software for automatically building Raspbian OS images with hyperspectral camera recording tools. It based on [`img-tool`](https://github.com/urpylka/img-tool).

## Usage

Run `./build.sh`

## Установка docker
https://docs.docker.com/engine/install/ubuntu/
<br>Ставить - docker-ce

## Установка WSL (windows subsystem linux) не из магазина приложений Windows
https://docs.microsoft.com/ru-ru/windows/wsl/install-manual#installing-your-distro
<br>я использую сборку 17763, поэтому до WSL 2 пока не обновился
<br>В первой WSL в качестве демона используется виндовый Docker Desktop

Чтоб линуксовый WSL клиент Докера мог подключиться к виндовому серверу Докера, надо:
- В параметрах Docker Desktop в трее - поставить галку Expose Daemon on tcp://localhost:2375 without TLS
- Перезапустить Docker Desktop (мне удавалось только через снос процесса docker в таск менеджере)
- В линуксине установить `export DOCKER_HOST=localhost:2375`
<br>После этого `docker version` выдаёт подключение к серверу, `docker run hello-world` выполняется ОК.
<br>Решение нагуглено тут: https://github.com/docker/for-linux/issues/535

Обновление до WSL2:
https://docs.microsoft.com/ru-ru/windows/wsl/install-win10#step-2---update-to-wsl-2

Статьи на хабре по работе с докером:
https://habr.com/ru/post/474346/
https://habr.com/ru/post/412633/

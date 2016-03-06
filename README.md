# simple php-fpm docker image

This is a simple docker image for using php-fpm as fastcgi-server for other docker containers.
If you wish to use my nginx docker image and want to use php-fpm with it, look at [jkuettner/nginx](https://github.com/jkuettner/nginx)

## Features
This image contains php-fpm with php 7 and the following php-extensions:

* apcu
* apcu-bc
* cli
* common
* curl
* fpm
* gd
* imagick
* imap
* json
* mcrypt
* mongodb
* mysql(nd)
* opcache
* pgsql
* readline
* xmlrpc

## Configure
This script uses the default php-ini-settings comming with debian jessie from dotdeb.
If you wish to add custom settings, add your custom ".ini" file to the **php** folder and (re)build the image (look at the **Install** section).

## Install
First clone this repositoriy and build the image:
```sh
git clone https://github.com/jkuettner/fpm.git
cd fpm
docker build -t jkuettner/fpm .
```

**Make sure that the owner your webroot and its contents is the uid 10000!**

run the image with the mounted webroot:
```sh
docker run -d \
    --name fpm \
    -v /path/to/your/webroot:/www \
    jkuettner/fpm
```

Now you are able to use the image as php-fpm fastcgi-server via "fpm:9000".
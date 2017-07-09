#!/bin/bash
export SERVER_NAME='bkforum.local'
export MYSQL_ROOT_PASSWORD='root'
export MYSQL_DATABASE='phpbb'
export MYSQL_USER='phpbb'
export DBPASSWD='phpbb'
export MYSQL_PASSWORD="$DBPASSWD"
docker-compose -p phpbb up


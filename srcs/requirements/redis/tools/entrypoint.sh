#!/bin/sh

export REDIS_PASS=$(cat /run/secrets/redis_pass)
envsubst '$REDIS_PASS' < /etc/redis/redis.conf.template > /etc/redis/redis.conf
unset REDIS_PASS
#sysctl vm.overcommit_memory=1
exec redis-server /etc/redis/redis.conf
exit 0

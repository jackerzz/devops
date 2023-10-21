#!/bin/bash
pod_seq=`echo $POD_NAME | awk -F"-" '{print $2}'`
if [ $pod_seq -eq 0 ];then
    ip=`hostname -I`
    hostname -I > /usr/local/etc/redis/ip.txt
    sed -ri "/^bind/c bind $ip" /usr/local/etc/redis/redis.conf
    sed -ri "/^bind/c bind $ip" /usr/local/etc/redis/sentinel.conf
    sed -ri "/2$/c sentinel monitor mymaster $ip 6379 2" /usr/local/etc/redis/sentinel.conf
    redis-server /usr/local/etc/redis/redis.conf
    redis-sentinel /usr/local/etc/redis/sentinel.conf
else
    ip=`hostname -I`
    i=`cat /usr/local/etc/redis/ip.txt`
    sed -ri "/^bind/c bind $ip" /usr/local/etc/redis/redis.conf
    sed -ri "/^bind/c bind $ip" /usr/local/etc/redis/sentinel.conf
    sed -ri "/2$/c sentinel monitor mymaster $i 6379 2" /usr/local/etc/redis/sentinel.conf
    echo "replicaof redis-0.redis 6379" >> /usr/local/etc/redis/redis.conf
    redis-server /usr/local/etc/redis/redis.conf
    redis-sentinel /usr/local/etc/redis/sentinel.conf
fi
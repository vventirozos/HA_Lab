#!/bin/bash
sudo service ssh start 
mkdir -p /home/postgres/logs/
ln -s /home/postgres/pgdata/log/postgresql.log /home/postgres/logs/postgresql.log
/usr/bin/etcd --config-file /home/postgres/configs/etcd.db2.conf > /home/postgres/logs/etcd.db2.log 2>&1 &
sleep 6
patroni /home/postgres/configs/patroni.db2.yml > /home/postgres/logs/patroni.db2.log 2>&1 &
tail -f /dev/null

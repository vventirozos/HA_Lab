# PostgreSQL High availability Lab

## Description
The purpose of this Lab is to demonstrate and provide a sandbox for experiments and tests of
a completely highly available PostgreSQL environment. The goal is to eliminate all
single points of failure while maintaining high availability and a single endpoint for postgres.
The lab will use Patroni to manage postgres, etcd for distributed configuration store (DCS),
containing cluster information such as configuration, health, and current status.
pgbackrest for backups and WAL archiving that will be leveraged by Patroni to re-sync or
initiate new standbys, HAProxy for load ballancing and for providing a single endpoint for
PostgreSQL connections and keepalived for IP switchover between HAProxy servers.
Lab is also designed to use a single custom image that includes all the software nessesary to
fullfil any role. All configuration is centralized in a single directory that each container has mapped
as (../configs:/home/postgres/configs).
All containers have sshd running and they all expose ports for it :

Postgres endpoint: 10.1.1.100 port 5000
`ssh -p 3001 postgres@localhost # 10.1.1.10	db1` \
`ssh -p 3002 postgres@localhost # 10.1.1.11	db2` \
`ssh -p 3003 postgres@localhost # 10.1.1.12	db3` \
`ssh -p 3004 postgres@localhost # 10.1.1.13	db_backup` \
`ssh -p 3005 postgres@localhost # 10.1.1.14	db_proxy1` \
`ssh -p 3006 postgres@localhost # 10.1.1.15	db_proxy2` \
`ssh -p 3007 postgres@localhost # 10.1.1.16	db_empty`

## How to start and use:
`cd HA_Lab/ ; ./build_lab.sh`

build_lab.sh will build the image, create a new ssh key for the containers
note that all containers will share the same ssh key, generated on image build.
We need passwordless access between the containers but mainly for simplicity
The script that generates the ssh key will also attempt to add your ssh key
from $HOME/.ssh/id_rsa.pub in all containers authorized_hosts file so you
can ssh to each host. After the image is built , docker compose will start all
containers with all services started. Afer 60 seconds of sleep db_backup will start
a new pgbackrest full backup. At this point the lab is fully up and you should be able to
ssh to any of the containers.
Postgres will be accessible through 10.1.1.100 port 5000 with 10.1.1.1/24 network trusted.
Each container has a 'configs' and a 'logs' directory. Inside these 2 directories you will
find the logfiles for all services and in configs you'll find every single configuration file
needed by the LAB. - This directory is a volume shared to all containers.
All services start from entrypoint scripts, found in configs directory.


#docker RUN -dit --net garden --ip 10.0.0.2 -p 3001:22 --name db_server1 db_server

FROM ubuntu:latest

# MAINTAINER v.ventirozos@evolmonkey.com

### CHANGE THE FOLLOWING 4 PARAMETERS IF YOU WANNA CHANGE ###
### Postgres VERSION, USER, POSTGRES INSTALLATION AND PGDATA DIRECTORIES ###

ENV PGVERSION=17.4
ENV PGUSER=postgres
ENV PGBINDIR=/home/$PGUSER/pgsql
ENV PGDATADIR=/home/$PGUSER/pgdata

RUN apt update && \
    apt install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/Europe/Athens /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

ENV TZ="Europe/Athens"

RUN apt update && apt -yq upgrade && \
    apt install -yq \
		sudo wget apt-transport-https \
		joe less build-essential libreadline-dev \
		zlib1g-dev flex bison libxml2-dev libxslt-dev \
		libssl-dev ssh openssh-server screen git net-tools \
		locales kmod pip haproxy watchdog keepalived psmisc \
		systemtap sysstat systemtap-sdt-dev pkg-config iotop gdb strace \
		lsof bpftrace etcd-server etcd-discovery etcd-client curl \
		libcurl4-openssl-dev liblz4-dev libzstd-dev iputils-ping && \
	useradd -c /home/$PGUSER -ms /bin/bash $PGUSER

RUN locale-gen en_US.UTF-8
RUN echo "$PGUSER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $PGUSER
WORKDIR /home/$PGUSER

RUN mkdir $HOME/.ssh/ && \
	chmod 700 $HOME/.ssh/ && \
	echo "Host *" > $HOME/.ssh/config ; echo " StrictHostKeyChecking no" >> $HOME/.ssh/config && \
	cd $HOME && \
	wget https://ftp.postgresql.org/pub/source/v$PGVERSION/postgresql-$PGVERSION.tar.gz && \
	tar zxfv /home/postgres/postgresql-$PGVERSION.tar.gz 
RUN cd postgres* ; ./configure --enable-dtrace --prefix=$PGBINDIR --with-openssl; make ; make install ; cd contrib ; make ; make install ;

RUN git clone https://github.com/citusdata/citus.git
RUN export PATH=$PGBINDIR/bin:$PATH && cd /home/postgres/citus ; ./configure ; make ; make install-all

RUN sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
RUN sudo apt update && sudo apt install -y pgbackrest patroni
RUN mkdir $PGDATADIR && $PGBINDIR/bin/initdb -k -D $PGDATADIR

RUN echo "export PGDATA=$PGDATADIR" >> ~/.bashrc && \
	echo "export PATH=$PGBINDIR/bin:$PATH" >> ~/.bashrc && \
	echo "LD_LIBRARY_PATH=$PGBINDIR/lib">> ~/.bashrc && \
	echo "alias joe='joe -wordwrap -nobackups -tab 2'"  >> ~/.bashrc && \
	echo "listen_addresses = '*'" >> $PGDATADIR/postgresql.conf && \
	echo "log_destination = 'stderr'" >> $PGDATADIR/postgresql.conf && \
	echo "logging_collector = on" >> $PGDATADIR/postgresql.conf && \
	echo "log_filename = 'postgresql.log'" >> $PGDATADIR/postgresql.conf && \
	echo "archive_mode = on" >> $PGDATADIR/postgresql.conf && \
	echo "shared_preload_libraries = 'citus'" >> $PGDATADIR/postgresql.conf && \
	echo "archive_command = 'pgbackrest --config=/home/postgres/configs/pgbackrest.archive.conf --stanza=ha_lab archive-push %p'" >> $PGDATADIR/postgresql.conf && \
	echo "host    all             all             10.1.1.1/16            trust" >> $PGDATADIR/pg_hba.conf && \
	echo "host    replication     all             10.1.1.1/16            trust" >> $PGDATADIR/pg_hba.conf

EXPOSE 5432
EXPOSE 22 
EXPOSE 5000
EXPOSE 8008


COPY --chown=postgres:postgres --chmod=700 id_rsa.pub /home/$PGUSER/.ssh/
COPY --chown=postgres:postgres --chmod=700 id_rsa /home/$PGUSER/.ssh/
COPY --chown=postgres:postgres --chmod=700 authorized_keys /home/$PGUSER/.ssh/

#ENTRYPOINT sudo service ssh start && $PGBINDIR/bin/pg_ctl -D $PGDATADIR start ; ; /bin/bash
#CMD sudo service ssh start && $PGBINDIR/bin/pg_ctl -D $PGDATADIR start ; /bin/bash
#Tadah !

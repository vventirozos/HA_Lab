pgbench -i -s 100 postgres
pgbench -j 2 -c 6 -T 60 -h 10.1.1.10 -p 5432 postgres
pgbench -j 2 -c 6 -T 60 -h 10.1.1.100 -p 5000 postgres


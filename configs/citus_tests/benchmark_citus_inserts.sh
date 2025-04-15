pgbench -i -s 100 postgres


psql -h 10.1.1.10 -p 5432 -c "SELECT create_distributed_table('pgbench_history', 'aid');" postgres

pgbench  -h 10.1.1.10 -p 5432 -j 8 -c 64 -f benchmark_citus_inserts.sql -T 30 postgres

#pgbench -j 2 -c 6 -T 60 -h 10.1.1.10 -p 5432 postgres


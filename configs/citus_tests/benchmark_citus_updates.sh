pgbench -i -s 100 postgres

psql -h 10.1.1.10 -p 5432 -c "SELECT create_distributed_table('pgbench_accounts', 'aid');" postgres
psql -h 10.1.1.10 -p 5432 -c " SELECT truncate_local_data_after_distributing_table('public.pgbench_accounts');" postgres
pgbench  -h 10.1.1.10 -p 5432 -j 8 -c 64 -f benchmark_citus_updates.sql -T 30 postgres


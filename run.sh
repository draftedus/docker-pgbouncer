#!/bin/bash

set -e

cat << EOF > /etc/pgbouncer/pgbconf.ini
[databases]
* = host=${PG_ADDR} port=${PG_PORT} user=${PG_USER}

[pgbouncer]
logfile = /var/log/postgresql/logging.txt
pidfile = /var/run/postgresql/pgbouncer.pid
listen_addr = 0.0.0.0
listen_port = 6432
unix_socket_dir = /var/run/postgresql
auth_type = trust
auth_file = /etc/pgbouncer/userlist.txt
pool_mode = session
server_reset_query = DISCARD ALL
max_client_conn = ${PG_MAX_CLIENT_CONN}
default_pool_size = ${PG_DEFAULT_POOL_SIZE}
ignore_startup_parameters = extra_float_digits
server_idle_timeout = ${PG_SERVER_IDLE_TIMEOUT}
log_connections = 0
log_disconnections = 0
stats_period = 3600
server_tls_sslmode=allow
verbose=2
EOF


echo '"'${PG_USER}'" "'${PG_PASS}'"'  > /etc/pgbouncer/userlist.txt

chown -R app:app /etc/pgbouncer
mkdir -p /var/log/postgresql
chown root:app /var/log/postgresql
chmod 1775 /var/log/postgresql
chmod 640 /etc/pgbouncer/userlist.txt

/usr/bin/pgbouncer -u app /etc/pgbouncer/pgbconf.ini

#!/bin/bash

set -e

POSTGRES_URLS=${PGBOUNCER_URLS:-DATABASE_URL}
POOL_MODE=${PGBOUNCER_POOL_MODE:-transaction}
SERVER_RESET_QUERY=${PGBOUNCER_SERVER_RESET_QUERY}
n=1

# if the SERVER_RESET_QUERY and pool mode is session, pgbouncer recommends DISCARD ALL be the default
# http://pgbouncer.projects.pgfoundry.org/doc/faq.html#_what_should_my_server_reset_query_be
if [ -z "${SERVER_RESET_QUERY}" ] &&  [ "$POOL_MODE" == "session" ]; then
  SERVER_RESET_QUERY="DISCARD ALL;"
fi

cat > /etc/pgbouncer/pgbconf.ini << EOFEOF
[pgbouncer]
listen_addr = 0.0.0.0
listen_port = 6432
unix_socket_dir = /var/run/postgresql
auth_type = md5
auth_file = /etc/pgbouncer/userlist.txt

; When server connection is released back to pool:
;   session      - after client disconnects
;   transaction  - after transaction finishes
;   statement    - after statement finishes
pool_mode = ${POOL_MODE}
server_reset_query = ${SERVER_RESET_QUERY}
max_client_conn = ${PGBOUNCER_MAX_CLIENT_CONN:-100}
default_pool_size = ${PGBOUNCER_DEFAULT_POOL_SIZE:-1}
min_pool_size = ${PGBOUNCER_MIN_POOL_SIZE:-0}
reserve_pool_size = ${PGBOUNCER_RESERVE_POOL_SIZE:-1}
reserve_pool_timeout = ${PGBOUNCER_RESERVE_POOL_TIMEOUT:-5.0}
server_lifetime = ${PGBOUNCER_SERVER_LIFETIME:-3600}
server_idle_timeout = ${PGBOUNCER_SERVER_IDLE_TIMEOUT:-600}
log_connections = ${PGBOUNCER_LOG_CONNECTIONS:-1}
log_disconnections = ${PGBOUNCER_LOG_DISCONNECTIONS:-1}
log_pooler_errors = ${PGBOUNCER_LOG_POOLER_ERRORS:-1}
stats_period = ${PGBOUNCER_STATS_PERIOD:-60}
server_tls_sslmode=${PGBOUNCER_TLS_SSLMODE:-require}
client_tls_sslmode=${PGBOUNCER_TLS_SSLMODE:-require}
client_tls_key_file = ${PGBOUNCER_CLIENT_TLS_KEY_FILE}
client_tls_cert_file = ${PGBOUNCER_CLIENT_TLS_CERT_FILE}
client_tls_ca_file = ${PGBOUNCER_CLIENT_TLS_CA_FILE}
client_tls_protocols = ${PGBOUNCER_TLS_PROTOCOLS:-secure}
[databases]
EOFEOF

cat > /etc/pgbouncer/userlist.txt << EOFEOF
EOFEOF

for POSTGRES_URL in $POSTGRES_URLS
do

  POSTGRES_URL_VALUE=$POSTGRES_URL
  IFS=':' read DB_USER DB_PASS DB_HOST DB_PORT DB_NAME <<< $(echo $POSTGRES_URL_VALUE | perl -lne 'print "$1:$2:$3:$4:$5" if /^postgres(?:ql)?:\/\/([^:]*):([^@]*)@(.*?):(.*?)\/(.*?)$/')

  DB_MD5_PASS="md5"`echo -n ${DB_PASS}${DB_USER} | md5sum | awk '{print $1}'`
  CLIENT_DB_NAME=$DB_NAME

  cat >> /etc/pgbouncer/userlist.txt << EOFEOF
"$DB_USER" "$DB_MD5_PASS"
EOFEOF

  cat >> /etc/pgbouncer/pgbconf.ini << EOFEOF
$CLIENT_DB_NAME = host=$DB_HOST dbname=$DB_NAME port=$DB_PORT
EOFEOF

  let "n += 1"
done

chown -R app:app /etc/pgbouncer
mkdir -p /var/log/postgresql
chown root:app /var/log/postgresql
chmod 1775 /var/log/postgresql
chmod 640 /etc/pgbouncer/userlist.txt

/usr/bin/pgbouncer -u app /etc/pgbouncer/pgbconf.ini

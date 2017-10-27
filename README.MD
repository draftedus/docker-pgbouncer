draftedus/docker-pgbouncer
==================

## Intro

**Based on Heroku's buildpack for pgbouncer found here:**

https://github.com/heroku/heroku-buildpack-pgbouncer

**Based on Logicify's dockerized version of pgbouncer found here:**

https://github.com/Logicify/docker-pgbouncer

## Configuration:

Available environment variables:

| Variable        | Description                   | Default Value                 |
| --------------- | ----------------------------- | ----------------------------- |
| PGBOUNCER_URLS  | Comma separated list of psql URIs to proxy | |
| PGBOUNCER_VERBOSITY | Number from 0-2 to determine log verbosity | 2 |
| PGBOUNCER_POOL_MODE | Specifies when a server connection can be reused by other clients | 'transaction' |
| PGBOUNCER_MAX_CLIENT_CONN | Maximum number of clients allowed to connected to pgbouncer | 100 |
| PGBOUNCER_DEFAULT_POOL_SIZE | Connections allowed "per user per database" | 20 |
| PGBOUNCER_MIN_POOL_SIZE | Opens connections to the database if the connections dip below this number | 0 |
| PGBOUNCER_RESERVE_POOL_SIZE | Number of connections allowed as backup if all connections are taken | 0 |
| PGBOUNCER_RESERVE_POOL_TIMEOUT | If a connection isn't serviced in X seconds, use a reserve connection if available | 5.0 |
| PGBOUNCER_SERVER_LIFETIME | TTL in seconds of connections to the pgbouncer proxy | 3600 |
| PGBOUNCER_SERVER_IDLE_TIMEOUT | TTL in seconds of idle connections to the pgbouncer proxy | 600 |
| PGBOUNCER_LOG_CONNECTIONS | Log whether a successful connection was made or not | 1 |
| PGBOUNCER_LOG_DISCONNECTIONS | Log whether or not a connection fails | 1 |
| PGBOUNCER_LOG_POOLER_ERRORS | Log if an error occurred with the pooler | 1 |
| PGBOUNCER_STATS_PERIOD | Amount of time in seconds to wait to buffer the stats to write to a log | 60 |
| PGBOUNCER_SERVER_TLS_SSLMODE | SSLMODE for the pgbouncer connection to the original psql URIs | require |
| PGBOUNCER_CLIENT_TLS_SSLMODE | SSLMODE for the client connections (your app) to the pgbouncer proxy | require |
| PGBOUNCER_CLIENT_TLS_KEY_FILE | TLS key file to use for SSL connections | |
| PGBOUNCER_CLIENT_TLS_CERT_FILE | TLS cert file to use for SSL connections | |
| PGBOUNCER_CLIENT_TLS_CA_FILE | Certificate Authority to use for SSL connections | |

## TLS

If you are going to use TLS (**which we HIGHLY recommend**), mount a volume via Docker that points to `/etc/pgbouncer/keys/` and point your environment
variables to files in that folder. The folder `/etc/pgbouncer/keys` is CHMOD'd appropriately to work with `pgbouncer`.

**Example:**

```
PGBOUNCER_CLIENT_TLS_KEY_FILE=/etc/pgbouncer/keys/server.key
PGBOUNCER_CLIENT_TLS_CERT_FILE=/etc/pgbouncer/keys/STAR_example_com.crt
PGBOUNCER_CLIENT_TLS_CA_FILE=/etc/pgbouncer/keys/STAR_example_com.crt
```

If you are curious what any of these options mean, visit the `pgbouncer` docs here:
https://pgbouncer.github.io/config.html
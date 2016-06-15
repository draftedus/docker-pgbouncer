Logicify/pgbouncer
==================

Docker image for pgbouncer based on centos7

To pull this image:
`docker pull logicify/pgbouncer`

Avaliable variables:

| Variable        | Description                   |
|:---------------:|:-----------------------------:|
| PG_ADDR         | Host name of IP of the real postgres server   |
| PG_PORT         | Port of the of IP of the real postgres server |
| PG_USER         | Name of the user to be used to connect to postgresql server |
| PG_PASS         | Password of the user to be used to connect to postgresql server |
| PG_MAX_CLIENT_CONN | Maximum number of client connections allowed. When increased then the file descriptor limits should also be increased. Theoretical maximum used is: ```max_client_conn + (max_pool_size * total_databases * total_users)``` Default: 500|
| PG_DEFAULT_POOL_SIZE | How many server connections to allow per user/database pair. Default: 200 |
| PG_SERVER_IDLE_TIMEOUT | If a server connection has been idle more than this many seconds it will be dropped. If 0 then timeout is disabled. Default: 500 |

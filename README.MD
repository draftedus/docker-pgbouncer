Logicify/pgbouncer
==================

Docker image for pgbouncer based on centos7

To pull this image:
`docker pull logicify/pgbouncer`

Avaliable variables:

| Variable        | Description                   |
| PG_ADDR         | Host name of IP of the real postgres server   |
| PG_PORT         | Port of the of IP of the real postgres server |
| PG_USER         | Name of the user to be used to connect to postgresql server |
| PG_PASS         | Password of the user to be used to connect to postgresql server |
| PG_MAX_CLIENT_CONN |                                                              |
| PG_DEFAULT_POOL_SIZE |                                                            |
| PG_SERVER_IDLE_TIMEOUT |                                                          |

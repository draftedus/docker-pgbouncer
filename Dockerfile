FROM logicify/centos7
MAINTAINER Eric Hagman <emhagman@gmail.com>

RUN curl -o pgdg-centos.rpm https://download.postgresql.org/pub/repos/yum/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-2.noarch.rpm && rpm -ivf pgdg-centos.rpm && rm pgdg-centos.rpm
RUN yum install -y pgbouncer

ADD run.sh /usr/local/bin/run-pgbouncer
COPY ./keys/ /etc/pgbouncer/keys/

RUN chmod +x /usr/local/bin/run-pgbouncer \
  && mkdir -p /var/run/postgresql/ \
  && chown app:app /var/run/postgresql
EXPOSE 6432
CMD ["/usr/local/bin/run-pgbouncer"]

FROM alpine:3.13

RUN apk add --update --no-cache pgbouncer perl curl bash git make coreutils

# install aws cli
WORKDIR /tmp
RUN git clone -o github https://github.com/draftedus/aws-secrets && cd aws-secrets && make install
RUN apk add --no-cache \
    python3 \
    py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install \
    awscli \
    && rm -rf /var/cache/apk/*

# switch back to root
WORKDIR /

# setup pgbouncer
RUN addgroup -S app && adduser -S app -G app
ADD run.sh /usr/local/bin/run-pgbouncer
RUN chmod +x /usr/local/bin/run-pgbouncer && mkdir -p /var/run/postgresql/ && chown -R app:app /var/run/postgresql /etc/pgbouncer
EXPOSE 6432

# always setup the env via aws kms secrets
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# run pgbouncer
CMD  ["/usr/local/bin/run-pgbouncer"]
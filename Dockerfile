FROM docker:1.12.1

ARG compose_version=1.8.0

# Install docker-compose (extra complicated since the base image uses alpine as base)
RUN set -x \
 && apk update \
 && apk add \
      bash \
      ca-certificates \
      curl \
      openssl \
 && curl -fsSL -o /tmp/docker-compose "https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-$(uname -s)-$(uname -m)" \
 && install /tmp/docker-compose /usr/local/bin/docker-compose \
 && curl -fsSL -o /etc/apk/keys/sgerrand.rsa.pub "https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub" \
 && curl -fsSL -o /tmp/glibc.apk  "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk" \
 && apk add \
      /tmp/glibc.apk \
 && ln -s /lib/libz.so.1 /usr/glibc-compat/lib/ \
 && ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib \
 && rm -f /tmp/* /var/cache/apk/* \
 && docker-compose -v

COPY ./docker-cache /usr/local/bin/

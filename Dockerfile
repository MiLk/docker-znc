# version 1.6.4-1
# docker-version 1.11.1
FROM alpine:3.3
MAINTAINER Jim Myhrberg "contact@jimeh.me"

ENV ZNC_VERSION 1.6.4

RUN apk add --no-cache sudo bash autoconf automake gettext-dev make g++ \
	       openssl-dev pkgconfig perl-dev swig zlib-dev ca-certificates \
         python3 python3-dev \
    && mkdir -p /src \
    && cd /src \
    && wget "http://znc.in/releases/archive/znc-${ZNC_VERSION}.tar.gz" \
    && tar -zxf "znc-${ZNC_VERSION}.tar.gz" \
    && cd "znc-${ZNC_VERSION}" \
    && ./configure --disable-ipv6 --enable-python \
    && make \
    && make install \
    && rm -rf /var/cache/apk/*

RUN adduser -S znc
RUN addgroup -S znc
ADD docker-entrypoint.sh /entrypoint.sh
ADD znc.conf.default /znc.conf.default
RUN chmod 644 /znc.conf.default

VOLUME /znc-data

EXPOSE 6667
ENTRYPOINT ["/entrypoint.sh"]
CMD [""]

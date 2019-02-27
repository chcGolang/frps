FROM alpine:latest
MAINTAINER chc

ENV FRP_VERSION 0.24.1
RUN wget https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz \
    && tar -xf frp_${FRP_VERSION}_linux_amd64.tar.gz \
    && mkdir /frps && mkdir -p /frps/conf && mkdir -p /frps/log \
    && cp frp_${FRP_VERSION}_linux_amd64/frps* /frps/ \
    && rm -rf frp_${FRP_VERSION}_linux_amd64* \
    && rm -f /frps/frps.ini

#更新Alpine的软件源为国内（清华大学）的站点，因为从默认官源拉取实在太慢了。。。
RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.4/main/" > /etc/apk/repositories
RUN apk update \
        && apk upgrade \
        && apk add --no-cache bash \
        bash-doc \
        bash-completion \
        && rm -rf /var/cache/apk/* \
        && /bin/bash

EXPOSE 7000 7001 7500
VOLUME /frps/log
VOLUME /frps/conf

ADD frps.sh /frps.sh
RUN chmod +x /frps.sh /frps/frps
ENTRYPOINT ["/frps.sh"]


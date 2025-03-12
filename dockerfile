FROM ubuntu:noble

RUN apt update -y -q
RUN apt-get install -qy vim iptables curl iproute2 wget unzip
# https://obsproject.com/forum/resources/how-to-set-up-your-own-private-rtmp-server-using-nginx.50/
RUN apt-get install -qy build-essential libpcre3 libpcre3-dev libssl-dev
ARG OHOME=/etc/nginx
# ARG CADIR=/etc/openvpn-ca
RUN mkdir -p $OHOME
# RUN make-cadir $CADIR

WORKDIR $OHOME
RUN wget http://nginx.org/download/nginx-1.15.1.tar.gz
RUN wget https://github.com/sergey-dryabzhinsky/nginx-rtmp-module/archive/dev.zip
RUN tar -zxvf nginx-1.15.1.tar.gz
RUN unzip dev.zip

WORKDIR $OHOME/nginx-1.15.1
RUN apt-get install -qy zlib1g-dev
RUN ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-dev --with-cc-opt=-Wno-error
RUN make
RUN make install
ADD ./nginxConf /usr/local/nginx/conf
# RUN /usr/local/nginx/sbin/nginx


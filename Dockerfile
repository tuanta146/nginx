FROM centos:7
LABEL maintainer="tdtuan146@gmail.com"

RUN yum update -y &&\
    yum install -y wget openssl openssl-devel perl perl-core zlib-devel gd gd-devel pcre-devel gcc &&\
    wget https://nginx.org/download/nginx-1.21.6.tar.gz &&\
    tar -xf nginx-1.21.6.tar.gz &&\
    cd nginx-1.21.6 &&\
    ./configure --sbin-path=/usr/bin/nginx --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log \
    --with-pcre --pid-path=/var/run/nginx.pid --with-http_ssl_module \ 
    --modules-path=/etc/nginx/modules --with-http_v2_module &&\
    make &&\
    make install &&\
    mkdir -p /etc/nginx/modules &&\
    mkdir -p /etc/nginx/ssl &&\
    mkdir -p /etc/nginx/demo &&\
    mkdir -p /etc/nginx/conf.d

COPY ./nginx.service /lib/systemd/system/

COPY ./conf.d/ /etc/nginx/modules

COPY ./modules/ /etc/nginx/modules    

COPY ./nginx.conf /etc/nginx/

COPY ./ssl/ /etc/nginx/ssl    

COPY ./demo /etc/nginx/demo

RUN systemctl enable nginx 

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]

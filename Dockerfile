FROM alpine:3.8

ARG SERVER_ADMIN_EMAIL=noreply.docker.server@impresscms.org
ARG SSL_CRT_FILE=/srv/ssl/server.crt
ARG SSL_KEY_FILE=/srv/ssl/server.key
ARG GITHUB_RELEASE_ID=latest
ARG SERVER_NAME=impresscms.test
ARG CERTIFICATE_COUNTRY_ISO_CODE=UN
ARG CERTIFICATE_STATE=Unknown
ARG CERTIFICATE_LOCATION=Unknown
ARG CERTIFICATE_ORGANISATION_NAME="ImpressCMS Demo Network"
ARG CERTIFICATE_ORGANISATION_UNIT=User
ARG CERTIFICATE_COMMON_NAME=another.impresscms.demo
ARG ICMS_DB_HOST
ARG ICMS_DB_USER
ARG ICMS_DB_PASS
ARG ICMS_DB_PCONNECT=0
ARG ICMS_DB_NAME=impresscms
ARG ICMS_URL=http://localhost
ARG ICMS_DB_TYPE=mysql
ARG ICMS_DB_CHARSET=utf8
ARG ICMS_DB_COLLATION=utf8_general_ci
ARG ICMS_DB_PREFIX
ARG ICMS_DB_SALT

ENV SERVER_ADMIN_EMAIL=${SERVER_ADMIN_EMAIL} \
    SSL_CRT_FILE=${SSL_CRT_FILE} \
    SSL_KEY_FILE=${SSL_KEY_FILE} \
    SERVER_NAME=${SERVER_NAME} \
    ICMS_DB_HOST=${ICMS_DB_HOST} \
    ICMS_DB_USER=${ICMS_DB_USER} \
    ICMS_DB_PASS=${ICMS_DB_PASS} \
    ICMS_DB_NAME=${ICMS_DB_NAME} \
    ICMS_DB_PCONNECT=${ICMS_DB_PCONNECT} \
    ICMS_URL=${ICMS_URL} \
    ICMS_DB_TYPE=${ICMS_DB_TYPE} \
    ICMS_DB_CHARSET=${ICMS_DB_CHARSET} \
    ICMS_DB_COLLATION=${ICMS_DB_COLLATION} \
    ICMS_DB_PREFIX=${ICMS_DB_PREFIX} \
    ICMS_DB_SALT=${ICMS_DB_SALT}

RUN apk add --no-cache \
                       apache2 \
                       apache2-utils \
                       apache2-ctl \
                       apache2-ssl \
                       apache2-error \
                       php5-apache2 \
                       php5-mysql \
                       php5-suhosin \
                       php5-xml \
                       php5-gd \
                       php5-curl \
                       php5-bcmath \
                       php5-mysqli \
                       php5-pdo_mysql \
                       php5-openssl \
                       php5-iconv \
                       curl \
                       wget \
                       lynx \
                       mysql-client \
                       bash \
                       sed \
                       openssl \
                       outils-md5

COPY ./scripts/service.sh /usr/local/bin/fg-apache
COPY ./scripts/rand_str.sh /usr/local/bin/rand-str
COPY ./scripts/hash_args.sh /usr/local/bin/hash-args
COPY ./scripts/save_config.sh /usr/local/bin/impresscms-save-config
COPY ./configs/apache2/conf.d/ /etc/apache2/conf.d/
COPY ./configs/apache2/httpd.conf /etc/apache2/httpd.conf

RUN mkdir -p /srv/www && \
    mkdir -p /srv/ssl && \
    mkdir -p /run/apache2 && \
    mkdir -p /srv/templates && \
    mkdir -p /etc/impresscms && \
    cd /etc/apache2 && \
    ln -s /usr/lib/apache2 modules && \
    rm -rf /var/www && \
    chmod +x /usr/local/bin/*

RUN apk add --no-cache jq && \
    RELEASE_INFO_URL=https://api.github.com/repos/ImpressCMS/impresscms/releases/${GITHUB_RELEASE_ID} && \
    RELEASE_TAR_URL=$(curl -s $RELEASE_INFO_URL | jq -r ".tarball_url") && \
    cd /tmp && \
    wget -O impresscms.tar.gz $RELEASE_TAR_URL && \
    tar xvzf impresscms.tar.gz && \
    cd ImpressCMS-impresscms-* && \
    mv * /srv/www && \
    cd .. && \
    rm -rf impresscms.tar.gz ImpressCMS-impresscms-* && \
    apk del --no-cache --purge jq && \
    cd /srv/www && \
    chmod -R 777 htdocs/templates_c htdocs/cache htdocs/uploads

RUN openssl req -x509 \
    -nodes \
    -days 365 \
    -newkey rsa:2048 \
    -keyout /srv/ssl/server.key \
    -out /srv/ssl/server.crt \
    -subj "/C=${CERTIFICATE_COUNTRY_ISO_CODE}/ST=${CERTIFICATE_STATE}/L=${CERTIFICATE_LOCATION}/O=${CERTIFICATE_ORGANISATION_NAME}/OU=${CERTIFICATE_ORGANISATION_UNIT}/CN=${CERTIFICATE_COMMON_NAME}"

EXPOSE 80 443
VOLUME ["/srv/www/htdocs/modules", "/srv/www/htdocs/templates_c", "/srv/www/htdocs/cache", "/srv/www/htdocs/uploads", "/etc/impresscms"]
ENTRYPOINT ["/usr/local/bin/fg-apache"]


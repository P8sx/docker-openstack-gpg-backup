FROM alpine:3.12

RUN apk add --update --no-cache\
    py3-pip \
    py3-netifaces \
    python3-dev \
    musl-dev \
    gcc \
    gpgme \
    xz  \
    build-base \
    libffi-dev \
    openssl-dev \ 
    krb5-dev \
    linux-headers \
    zeromq-dev


RUN rm -rf /var/cache/apk/*

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip3 install --no-cache --upgrade pip
RUN pip3 install --no-cache python-swiftclient python-keystoneclient



COPY . .
RUN chmod 755 /*.sh
CMD ["/init.sh"]



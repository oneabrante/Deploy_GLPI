FROM debian:12.5

LABEL org.opencontainers.image.authors="github.com/oneabrante"

RUN apt update && \
    apt install -y openssl && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY ssl.sh /usr/local/bin/ssl.sh

RUN mkdir -p /app/certs

WORKDIR /app

CMD ["/bin/bash", "/usr/local/bin/ssl.sh"]
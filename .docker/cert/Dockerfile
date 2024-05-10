FROM debian:latest

RUN apt-get update && \
    apt-get install -y openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ssl.sh /usr/local/bin/ssl.sh

RUN mkdir -p /app/certs

WORKDIR /app

CMD ["/bin/bash", "/usr/local/bin/ssl.sh"]
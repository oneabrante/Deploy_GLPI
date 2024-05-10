openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /app/certs/www.glpi.web.app.key \
    -out /app/certs/www.glpi.web.app.crt \
    -subj "/C=BR/ST=PB/L=PB/O=Oneabrante/OU=Abranteme/CN=oneabrante.com.br"
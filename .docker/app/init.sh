#!/bin/bash
# https://glpi-install.readthedocs.io/en/latest/

[[ ! "$VERSION_GLPI" ]] && VERSION_GLPI="10.0.15"

if [[ -n "${TIMEZONE}" ]]; then
    echo "date.timezone = \"$TIMEZONE\"" > /etc/php/8.3/fpm/conf.d/timezone.ini
fi

sed -i 's,session.cookie_httponly = *\(on\|off\|true\|false\|0\|1\)\?,session.cookie_httponly = on,gi' /etc/php/8.3/fpm/php.ini

FOLDER_GLPI=glpi/
FOLDER_WEB=/var/www/html/

if !(grep -q "TLS_REQCERT" /etc/ldap/ldap.conf); then
    echo "TLS_REQCERT isn't present"
    echo -e "TLS_REQCERT\tnever" >> /etc/ldap/ldap.conf
fi

if [ "$(ls ${FOLDER_WEB}${FOLDER_GLPI}/bin)" ]; then
    echo "GLPI já está instalado"
else
    wget -P ${FOLDER_WEB} "https://github.com/glpi-project/glpi/releases/download/${VERSION_GLPI}/glpi-${VERSION_GLPI}.tgz"
    tar -xzf ${FOLDER_WEB}glpi-${VERSION_GLPI}.tgz -C ${FOLDER_WEB}
    rm -rf ${FOLDER_WEB}glpi-${VERSION_GLPI}.tgz
    chown -R www-data:www-data ${FOLDER_WEB}${FOLDER_GLPI}
fi

echo 'server {
    listen 80;
    listen [::]:80;
    root /var/www/html/glpi/public;

    location / {
        try_files $uri /index.php$is_args$args;
    }

    location ~ ^/index\.php$ {
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}' > /etc/nginx/sites-available/default

if [ ! -f /etc/nginx/sites-enabled/default ]; then
    ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
fi

echo "*/2 * * * * www-data /usr/bin/php /var/www/html/glpi/front/cron.php &>/dev/null" > /etc/cron.d/glpi
service cron start

service php8.3-fpm start

nginx -g "daemon off;"
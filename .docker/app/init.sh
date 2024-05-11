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
        fastcgi_intercept_errors on;
    }

    error_page 403 /403.html;
    location = /403.html {
        root /var/www/html/glpi/public;
        internal;
    }

}' > /etc/nginx/sites-available/default

if [ ! -f /var/www/html/glpi/public/403.html ]; then
    echo "<!DOCTYPE html>
<html lang=\"pt\">
<head>
    <meta charset=\"UTF-8\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css\">
    <title>403 Forbidden</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            text-align: center;
            padding: 50px;
        }

        h1 {
            color: #333;
        }

        p {
            color: #666;
            margin-bottom: 20px;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <i class=\"fas fa-exclamation-triangle fa-5x\"></i>
    <h1>Desculpe, mas esta página não existe...</h1>
    <p>Pedimos desculpas pelo inconveniente, mas a página que você estava tentando acessar não existe neste endereço.</p>
    <p>Você pode voltar para a página inicial clicando no botão abaixo:</p>
    <a href="index.php" class=\"btn\"><i class=\"fas fa-home\"></i> Ir para a Página Principal</a>
</body>
</html>" > /var/www/html/glpi/public/403.html
fi

if [ ! -f /etc/nginx/sites-enabled/default ]; then
    ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
fi

echo "*/2 * * * * www-data /usr/bin/php /var/www/html/glpi/front/cron.php &>/dev/null" > /etc/cron.d/glpi
service cron start

service php8.3-fpm start

nginx -g "daemon off;"
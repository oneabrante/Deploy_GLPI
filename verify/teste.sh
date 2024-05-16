#!/bin/bash

# Check container status
container_status=$(docker inspect -f '{{.State.Status}}' glpi)
if [ $? -eq 0 ]; then
  echo -e "\033[92mContainer status: $container_status (OK)\033[0m"
else
  echo -e "\033[91mContainer status: $container_status (Falha)\033[0m"
  exit 1
fi

# Check NGINX status in container
curl -I http://localhost:80 > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo -e "\033[92mNGINX status: OK\033[0m"
else
  echo -e "\033[91mNGINX status: Falha\033[0m"
  exit 1
fi

# Check PHP-FPM v8.3 status in container
php_status=$(docker exec glpi service php8.3-fpm status)
sleep 15
if [ $? -eq 0 ]; then
  echo -e "\033[92mPHP-FPM v8.3 status: $php_status (OK)\033[0m"
else
  echo -e "\033[91mPHP-FPM v8.3 status: $php_status (Falha)\033[0m"
  exit 1
fi

# Deploy do GLPI com Nginx, MariaDB e Redis

<p align="center">
  <img src="https://raw.githubusercontent.com/glpi-project/glpi/main/pics/logos/logo-GLPI-250-black.png" width="180"><span style="margin: 10px;"></span>
  <img src="https://upload.wikimedia.org/wikipedia/commons/c/c5/Nginx_logo.svg" alt="logo nginx" width="180" height="110"><span style="margin: 10px;"></span>
  <img src="https://static-00.iconduck.com/assets.00/mariadb-icon-512x340-txozryr2.png" width="180"><span style="margin: 10px;"></span>
  <img src="./registry/redis_logo.png" width="130"><span style="margin: 10px;"></span>
</p>


## Stack
- Debian / Ubuntu
- Docker v26.1.1
- Docker Compose v1.29.2

## Como usar
1. Clone o repositório e acesse a pasta do projeto
```bash
git clone https://github.com/oneabrante/Deploy_GLPI.git ; cd Deploy_GLPI
```
2. Instale os pré-requisitos (pule caso possuir estas ferramentas)
```bash
chmod +x requirements.sh
./requirements.sh
```
3. Inicie os containers a partir do arquivo `docker-compose.yml` com o comando:
```bash
docker-compose up -d
```
Nesse momento são criados ao todo 4 containers: glpi, phpmyadmin, mariadb e redis. O container do phpmyadmin foi criados para uma complementação de serviços à parte, assim como também o trecho comentado do container OpenSSL que gera certificados ssl.

## Procedimento
- GLPI: http://localhost ou http://ip-do-servidor

<p align="center">
  <img src="./registry/init.png">
</p>

Para configurar o GLPI com o banco de dados MariaDB, siga os passos abaixo:
1. No campo relacionado ao banco de dados, use o nome do container do MariaDB: `mariadb`
2. No campo do usuário, use `glpi`
3. No campo da senha, use `password_glpi`

Com isso, temos que a configuração com o banco de dados esteja concluída. Selecione o nome do banco, conforme a imagem abaixo

<p align="center">
  <img src="./registry/init2.png">
</p>

<p align="center">
  <img src="./registry/init3.png">
</p>

## Uso do Redis 
Para habilitar o Redis, digite no terminal:
```bash
docker exec glpi php /var/www/html/glpi/bin/console cache:configure --context=core --dsn=redis://redis:6379
```

## Autor
<img src="https://avatars.githubusercontent.com/u/89171200?v=4" width=115><br><sub>Thiago Abrante</sub>

## Referências
- [GLPI](https://glpi-project.org/)
- [Nginx](https://www.nginx.com/)
- [MariaDB](https://mariadb.org/)
- [Redis](https://redis.io/)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)



# Implantação do GLPI com Nginx, MariaDB e Redis


<p align="center">
  <img src="https://raw.githubusercontent.com/glpi-project/glpi/main/pics/logos/logo-GLPI-250-black.png" width=200 margin="110px"><span style="margin: 10px;"></span>
  <img src="https://upload.wikimedia.org/wikipedia/commons/c/c5/Nginx_logo.svg" alt="logo nginx" width="200" height="130"><span style="margin: 10px;"></span>
  <img src="https://static-00.iconduck.com/assets.00/mariadb-icon-512x340-txozryr2.png" width=200><span style="margin: 10px;"></span>
  <img src="https://w7.pngwing.com/pngs/799/831/png-transparent-redis-in-memory-database-key-value-database-cache-speech-miscellaneous-logo-data-thumbnail.png" width=150><span style="margin: 10px;"></span>
</p>



## Pré-requisitos
- Docker
- Docker Compose

## Como usar
1. Clone o repositório
2. Acesse a pasta do projeto
3. Execute o comando `docker-compose up -d`

## Acesso
- GLPI: http://localhost ou http://ip-do-servidor

## Dados de acesso
- Usuário: glpi
- Senha: glpi

## Comandos úteis
- Iniciar os serviços: `docker-compose up -d`
- Parar os serviços: `docker-compose down`
- Verificar os logs: `docker-compose logs -f`
- Acessar o container do GLPI: `docker exec -it glpi bash`

## Licença
MIT

## Autor
<img src="https://avatars.githubusercontent.com/u/89171200?v=4" width=115><br><sub>Thiago Abrante</sub>

## Referências
- [GLPI](https://glpi-project.org/)
- [Nginx](https://www.nginx.com/)
- [MariaDB](https://mariadb.org/)
- [Redis](https://redis.io/)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)



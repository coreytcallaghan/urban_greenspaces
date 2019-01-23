# Setup instructions

1. create the docker container:


`
docker run --name ebird-mariadb \
  -d \
  -e MYSQL_ROOT_PASSWORD=<root password> \
  -e MYSQL_DATABASE=ebird \
  -e MYSQL_USER=ebird \
  -e MYSQL_PASSWORD=<mysql password> \
  -p 3306:3306 \
  -v /home/corey:/home/corey \
  mariadb
`

copy the init files to the root of the docker image

`docker exec -itd ebird-mariadb cp -r /home/corey/init /`

run the import scripts, this will take some time... (nothing with ebird is quick)

`docker exec -itd ebird-mariadb mysql -p<mysql password> -e "source /init/init.sql" ebird`


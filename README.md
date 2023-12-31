# juicefs-docker

An alternative to the juicefs docker volume driver.

## Usage

### Plain docker

```sh
docker run                                          \
    --detach                                        \
    --privileged                                    \
    --env META_URI="mysql://user@tcp(host)/db"      \
    --env META_PASSWORD="db_passw0rd"               \
    --env S3_BUCKET="https://..."                   \
    --env S3_ACCESS_KEY="..."                       \
    --env S3_SECRET_KEY="..."                       \
    --env S3_REGION="us-east-1"                     \
    --env FS_NAME="myjuicefs"                       \
    --env JFS_RSA_PASSPHRASE="pem_passw0rd"         \
    --volume path/to/cert/dir:/cert:ro              \
    --mount type=bind,source=/mnt/juicefs,target=/mnt,bind-propagation=shared \
    docker.io/altaris/juicefs-docker
```

The folder `path/to/cert/dir` must contain `myjuicefs.pem` inside (of more
generally, `<FS_NAME>.pem`).

### `docker-compose`

```yml
volumes:
  juicefs-certs: # Put myjuicefs.pem here
  mariadb-data:

services:
  mariadb:
    env:
      MARIADB_ROOT_PASSWORD: ...
      MARIADB_USER: user
      MARIADB_PASSWORD: db_passw0rd
      MARIADB_DATABASE: db
    image: mariadb:latest
    volumes:
      - mariadb-data:/var/lib/mysql
  juicefs:
    container_name: juicefs
    depends_on:
      - mariadb
    env:
      META_URI: mysql://user@tcp(mariadb)/db
      META_PASSWORD: db_passw0rd
      S3_BUCKET: https://...
      S3_ACCESS_KEY: ...
      S3_SECRET_KEY: ...
      S3_REGION: us-east-1
      FS_NAME: myjuicefs
      JFS_RSA_PASSPHRASE: pem_passw0rd
    image: altaris/juicefs-docker
    networks:
      - back
    privileged: true
    volumes:
      - juicefs-certs:/cert:ro
      - type: bind
        source: /mnt/juicefs
        target: /mnt
        bind:
          propagation: shared
```

## Generate a RSA key

ezpz

```sh
PASSWORD=$(openssl rand -base64 32)
echo $PASSWORD  # Don't loose it ;)
openssl genrsa -out key.pem -aes256 -passout "pass:$PASSWORD" 2048
```

You can also just run

```sh
openssl genrsa -out key.pem -aes256 2048
```

and set the password manually.

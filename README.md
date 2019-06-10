# Dockerizing iDempiere 6.2

Dependencies commands: `make`, `unzip`, `wget` and [docker](https://docs.docker.com/install/).

## Getting Started

```
$ docker swarm init
$ make download build run
```

Open in the browser: [http://localhost:8080/webui/](http://localhost:8080/webui/)

## Default Accounts

The following users and passwords are part of the initial seed database:

| Usage | User | Password |
| - | - | - |
| System Management | System | System |
| System Management or any role/company | SuperUser | System |
| Sample Client Administration | GardenAdmin | GardenAdmin |
| Sample Client User | GardenUser | GardenUser |

## How it works



> This project has not support for oracle database.

## Make Commands

`make download` downloads iDempiere

`make build` creates iDempiere docker image (with labels `idempiere:6.2` and `idempiere:latest`)

`make run` runs iDempiere docker stack (includes `postgres:9.6`)

`make stop` stops the stack

`make log` shows the logs of iDempiere

`make unzip` extracts iDempire

`make bash` creates a terminal within iDempiere docker image

## Docker Stack

This is an example of how deploy iDempiere using a docker stack file:

```yaml
version: '3.7'

services:
  idempiere:
    image: idempiere:6.2
    ports:
      - 8080:8080
      - 8443:8443
      - 12612:12612
    environment:
      - TZ=America/Guayaquil

  postgres:
    image: postgres:9.6
    volumes:
      - idempiere_data:/var/lib/postgresql/data
    environment:
      - TZ=America/Guayaquil
      - POSTGRES_PASSWORD=postgres
    ports:
      - 5432:5432

volumes:
  idempiere_data:
```

## Environment Variables

| Variable | Default Value | Description |
| - | - | - |
| KEY_STORE_PASS | myPassword | Password for java key store (SSL Certificate) |

## Ports

| Port | Description |
| - | - |
| 8080 | Default HTTP port for iDempiere |
| 8443 | Default HTTPS port for iDempiere |
| 12612 | Default OSGI port for telnet connection |

## Docker Volumes

## Docker Secrets

As an alternative to passing sensitive information via environment variables, 
`_FILE` may be appended to some of the previously listed environment variables, 
causing the initialization script to load the values for those variables 
from files present in the container. See [Docker Secrets](https://docs.docker.com/engine/swarm/secrets/) and [Docker PosgreSQL](https://hub.docker.com/_/postgres).

#### Variable list:

| Variable | Original variable |
| - | - |
| `DB_ADMIN_PASS_FILE` | `DB_ADMIN_PASS` |
| `DB_PASS_FILE` | `DB_PASS` |
| `MAIL_PASS_FILE` | `MAIL_PASS` |
| `KEY_STORE_PASS_FILE` | `KEY_STORE_PASS` |


#### Example:

Create the secret:

```bash
$ printf "postgres" | docker secret create db_admin_pass -
```

Use environment variable in the stack file:

```yaml
version: '3.7'

services:
  idempiere:
    image: idempiere:6.2
    ports:
      - 8080:8080
      - 8443:8443
      - 12612:12612
    environment:
      - TZ=America/Guayaquil
      - DB_ADMIN_PASS_FILE=/run/secrets/db_admin_pass
    secrets:
      - db_admin_pass

  postgres:
    image: postgres:9.6
    volumes:
      - idempiere_data:/var/lib/postgresql/data
    environment:
      - TZ=America/Guayaquil
      - POSTGRES_PASSWORD_FILE=/run/secrets/db_admin_pass
    secrets:
      - db_admin_pass
    ports:
      - 5432:5432

volumes:
  idempiere_data:

secrets:
  db_admin_pass:
    external: true
```

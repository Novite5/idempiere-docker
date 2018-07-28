# Dockerizing iDempiere

This project was created to be used for development, and if you need a phoenix environment, not for production

Commands needed: `make`, `docker-compose`, `python`, `wget`, `jar`.

## Docker Version

- `docker-compose`: 1.17.1
- `docker-compose.yml`: 3.4
- `docker`: 18.06.0-ce

## Getting Started

```
make download init
make up
```

## Commands

`make download` gets the daily idempiere version

`make extract` extracts zip file (needs `download`)

`make config` executes the console-setup (needs `up-database`)

`make import-db` creates database (needs `up-database`)

`make build` creates containers

`make up` runs the application (needs `init`)

`make up-database` runs postgres only

`make down` stops the application

`make delete` deletes containers and volumes

`make show` shows the current containers (needs `up`)

`make log` shows the logs (needs `up`)

`make init` starts the configuration (needs `up-database`)

`make console` opens idempiere container (needs `run`)

## Default Accounts
The following users and passwords are part of the initial seed database:

|Usage|User|Password|
|-|-|-|
|System Management|System|System|
|System Management or any role/company|SuperUser|System|
|Sample Client Administration|GardenAdmin|GardenAdmin|
|Sample Client User|GardenUser|GardenUser|

Path: [http://localhost:8080/webui/](http://localhost:8080/webui/)

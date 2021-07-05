# ShortUrl

This project is to create a URL shortener web application in the same vein as bitly, TinyURL, or the now defunct Google URL Shortener.


## Tech. Facts

- Backend: Elixir + Phoenix Web Framework
- Frontend: React + Material UI
- Database: PostgreSQL
- Execution Env.: Docker (Docker Compose) 


## Prep for the project

For fresh start, make sure Postgres docker volume local directory removed.

```
$ rm -rf ./pgdata
```

Also, cleaning up Docker env. is suggested.
```
$ docker system prune -a
```

## System Environment Set up

```
export MIX_ENV=prod 
export DATABASE_URL=ecto://postgres:postgres@short-url-db/short-url 
export SECRET_KEY_BASE=secret_url  
export RELEASE_ENV=prod
```

## Perform Unit Tests

```
docker-compose -f docker-compose.yml -f docker-compose.test.yml build
docker-compose -f docker-compose.yml -f docker-compose.test.yml run --rm short-url mix ecto.create
docker-compose -f docker-compose.yml -f docker-compose.test.yml run --rm short-url mix ecto.migrate
docker-compose -f docker-compose.yml -f docker-compose.test.yml run --rm short-url mix test
```

## Run Application


### Init Prod DB

It requires to run once to initiate DB database and schemas. 

```
docker-compose -f docker-compose.yml -f docker-compose.base.yml build
docker-compose -f docker-compose.yml -f docker-compose.base.yml run --rm short-url mix ecto.create
docker-compose -f docker-compose.yml -f docker-compose.base.yml run --rm short-url mix ecto.migrate
```

## Build and Run

```
docker-compose -f docker-compose.yml build
docker-compose -f docker-compose.yml up
```

## Landing page once the application is up

Open browser with `http://localhost:4000/`

![alt tag](./landing-screen.png)

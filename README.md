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
docker-compose -f docker-compose.yml -f docker-compose.test.yml run --rm short-url mix test
```

## Run Application


### Init Prod DB

It requires to run once to initiate DB database and schemas. 

```
docker-compose -f docker-compose.yml -f docker-compose.base.yml build
docker-compose -f docker-compose.yml -f docker-compose.base.yml run --rm short-url mix ecto.setup
```
No worry about `Could not find static manifest` error for now.

## Build and Run

```
docker-compose -f docker-compose.yml build
docker-compose -f docker-compose.yml up
```

## Landing page once the application is up

Open browser with `http://localhost:4000/`

![alt tag](./landing-screen.png)


## Performace Test Result
```
% ab -p post.txt -T application/json -c 10 -n 100 http://localhost:4000/api/url/
This is ApacheBench, Version 2.3 <$Revision: 1879490 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking localhost (be patient).....done


Server Software:        Cowboy
Server Hostname:        localhost
Server Port:            4000

Document Path:          /api/url/
Document Length:        94 bytes

Concurrency Level:      10
Time taken for tests:   3.021 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      45800 bytes
Total body sent:        18400
HTML transferred:       9400 bytes
Requests per second:    33.10 [#/sec] (mean)
Time per request:       302.109 [ms] (mean)
Time per request:       30.211 [ms] (mean, across all concurrent requests)
Transfer rate:          14.80 [Kbytes/sec] received
                        5.95 kb/s sent
                        20.75 kb/s total

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       1
Processing:    12  290 137.8    288     569
Waiting:       12  290 137.8    288     569
Total:         12  290 137.7    288     569

Percentage of the requests served within a certain time (ms)
  50%    288
  66%    347
  75%    399
  80%    445
  90%    493
  95%    516
  98%    554
  99%    569
 100%    569 (longest request)
 ```


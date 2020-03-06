# NOC List adhoc

## Deps

* docker-compose
* docker

## Running in docker compose

This will start the noclist service and run the homework code and output
json array of users

```bash
$ docker-compose up
```

## Run out of compose (images already built)
```bash
$ docker run --rm -p 8888:8888 adhocteam/noclist

$ docker run --rm -it noclist_noc:latest bundle exec ruby ./bin/noclist
```

## Running the tests (adhoc service already running)
```bash
$ docker run --rm -it noclist_noc:latest bundle exec ruby rspec
```

## Running outside of docker
```bash
$ gem install bundler
$ bundle exec ruby ./bin/noclist
```

## Running tests outside of docker
```bash
$ bundle exec rspec
```


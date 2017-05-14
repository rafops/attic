# Docker

Install Docker Engine:

    https://download.docker.com/mac/stable/Docker.dmg

Dockerfile:

    FROM debian:jessie
    CMD while [ 1 ] ; do date; sleep 1s; done

Build:

    docker build -t jessie-date .

Create a new container:

    docker create --name jd-01 jessie-date

List containers:

    docker container ls -a

Start container:

    docker start jd-01

Show running containers:

    docker ps
    
Run a command on a container:

    docker exec -t 70421a9edeaf top

Show processes inside a container:

    docker top 70421a9edeaf

Run an interactive command on a container (process will exit after CTRL+C):

    docker exec -it 70421a9edeaf top

Kill a process inside a container

    docker exec -it 70421a9edeaf kill -9 139

Stop a container:

    docker stop 70421a9edeaf

Inspect a container:

    docker inspect 70421a9edeaf

Remove container:

    docker rm 70421a9edeaf

Build a new image based on jessie-date:

    # AnotherDockerFile
    FROM jessie-date
    CMD echo 'cool'

    docker build -f AnotherDockerfile -t jessie-date-cool .

Remove image:

    docker rmi jessie-date

Remove image and containers:

    docker rmi jessie-date -f

Start a container:

    docker restart container1 container1

Attach a container:

    docker attach container1

Useful Dockerfile commands:

    FROM  image:tag
    LABEL Description="This image is used to start the foobar executable" Vendor="ACME Products" Version="1.0"
    RUN                 execute and commit
    CMD                 execute
    EXPOSE port
    ENV key value
    ADD                 copy files from src to dst
    COPY                ADD without URLs or unpacking (prefered)
    ENTRYPOINT          like CMD but not cannot be overriden
    VOLUME              why only one argument?
    USER                run RUN CMD or ENTRYPOINT with specific user
    WORKDIR             run RUN CMD or ENTRYPOINT inside workdir

        # Example:
        ENV DIRPATH /path
        WORKDIR $DIRPATH/$DIRNAME
        RUN pwd

    STOPSIGNAL          can be useful for sidekiq (STOPSIGNAL SIGUSR1+SIGTERM)
                        together with -t option

    HEALTHCHECK  --interval=5m --timeout=3s \
      CMD curl -f http://localhost/ || exit 1

    SHELL ['/bin/zsh']
    RUN echo 'hello'  # run this command with zsh
    

## Docker Compose

    version: '2'
    services:
      db:
      image: postgres
      web:
      build: .
      command: bundle exec rails s -p 3000 -b '0.0.0.0'
      volumes:
        - .:/myapp
      ports:
        - "3000:3000"
      depends_on:
        - db


## Fortune Example

    # Dockerfile
    FROM debian:jessie
    CMD echo 'hello world'

    docker build -t jessie-hello-world .

    docker images

    # options are interactive (STDIN open) + tty
    docker run -it jessie-hello-world

    # run another command without interactive
    docker run -t jessie-hello-world echo 'nice'


## Ruby App

    FROM ruby:2.3.3
    RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
    RUN mkdir /myapp
    WORKDIR /myapp
    ADD Gemfile /myapp/Gemfile
    ADD Gemfile.lock /myapp/Gemfile.lock
    RUN bundle install
    ADD . /myapp

Build:

    docker build -t myimagename .



    FROM docker/whalesay:latest
    RUN apt-get -y update && apt-get install -y fortunes
    CMD /usr/games/fortune -a | cowsay

    docker-compose up

    docker-compose up -d
    ./run_tests
    docker-compose down


Kompose: a tool to go from Docker-compose to Kubernetes


    bundle package --all-platforms --all
    docker build -t myapp .

    docker save  myapp | gzip -c - > myapp-7507127eb4f5.tar.gz


    docker run -it myapp /bin/bash
    bundle exec foreman run web


## Draft

    # docket-compose.yml

    bundle package --all-platforms --all
    docker-compose run myapp rails db:create


    docker-compose build

    docker-compose run myapp rails db:create
    docker-compose run myapp rails db:migrate
   
    docker-compose up
    docker-compose down

# Docker

## Versions

- Local development: Docker CE / Docker for Mac
- Production: Docker for AWS
- Docker EE (Enterprise Edition): Support + extra products. Certified on specific platforms. Longer support lifecycles.
- Docker for Mac: https://www.docker.com/docker-mac
- See`docker version`

## Docker Engine

- Docker Engine is a client/server application
- A server is daemon process (dockerd)
- A REST API interfaces the daemon
- The daemon creates and manages Docker objects, such as images, containers, networks, and volumes.
- A command line interface interacts with the REST API
- Docker for Mac runs linux/amd64 as the server

## ZSH Completion

```
mkdir -p $ZSH/completions
curl -L https://raw.githubusercontent.com/docker/compose/1.16.1/contrib/completion/zsh/_docker-compose > $ZSH/completions/_docker-compose
echo "autoload -Uz compinit && compinit -i" >> ~/.zshrc
```

## Docker Machine

TODO

```
docker-machine create --driver
```

## Docker CLI

Run a container:

```
docker container run \
  --publish 8001:80 \
  --name webhost \
  --detach nginx:latest \
  --environment SOMEENVVAR=1024
  nginx \
  -T
```

- Looks for *nginx:latest* image locally in image cache,
- Download latest version of image *nginx* from image repository Docker Hub,
- Creates and start a new container from that image
- Gives it a virtual IP on a private network inside docker engine
- Open port 8001 on the host and routes traffic to the container on port 80 (--publish)
- Run detached (--detach) from the current shell
- Set a name (--name) for the container
- Starts container by running the command *nginx* specified in the CLI or by using the CMD in the image Dockerfile

## Images

- An **image** is an ordered collection of root filesystem changes and the corresponding execution parameters for use within a container runtime. Not a complete OS. No kernel or kernel modules.
- Community images have the format: `username/image`.
- Official images dont have the username namespace on the name image.

List images in the cache:

```
docker image ls 
```

Show image layers:

```
docker history nginx:latest
```

Show information about an image:

```
docker image inspect ubuntu
```

## Containers

- A **container** is an instance of that image running as a process. A container is just a process, not a VM!

Show running containers:

```
docker container ls
```

Stop running containers:

```
docker container stop <CONTAINER ID>
```

Show container history:

```
docker container ls -a
```

Remove containers (need stop first)

```
docker container rm <CONTAINER ID> <CONTAINER ID> …
```

Passing environment variables:

```
docker container run … --env PASSWORD=123456 …
```

## Information about containers

Show logs for specific container:

```
docker container logs webhost
```

Process list in the container:

```
docker container top webhost
```

Inspect data for the running container:

```
docker container inspect webhost
```

Show live performance data for all containers

```
docker container stats
```

## Getting a shell inside containers

- No need of SSH
- Attached (-a)
- get a TTY (-t)
- Interactive (-i)

Start a new *ubuntu* container interactively with *bash* command

```
docker container run -it --name linux ubuntu bash
```

Run attached/interactive:

```
docker container start -ai ubuntu
```

Once you exit the shell, container is stopped.

Run additional command in existing container:

```
docker container exec -it ubuntu bash
```

## Networks

- All containers on a virtual network can talk to each other without `-p`
- Skip virtual networks and use host IP with `--net=host`
- Default network is bridge/docker0. More virtual networks can be created.
- The default driver for a new network is bridge.
- DNS is built-in if you use custom networks. This is even more easier with Docker Compose.

Show open ports:

```
docker container port webhost
```

List networks:

```
docker network ls
```

Inspect bridge network:

```
docker network inspect bridge
```

Connect a container to a network:

```
docker network connect <NETWORK ID> <CONTAINER ID>
```

### Round-robin

```
docker network create foobar
docker container run -d --net foobar --net-alias webhost nginx
docker container run -d --net foobar --net-alias webhost nginx
docker container ls
docker container run --rm --net foobar ubuntu curl -s webhost:80
docker container run --rm --net foobar ubuntu curl -s webhost:80
```

## Tagging

```
docker image tag nginx:latest rafops/nginx:latest
```

Upload image to Docker Hub:

```
docker login
docker image push rafops/nginx:latest
```

## Dockerfile

- Keep the things that change less often at the top of the Dockerfile and things that change oftern at the bottom in order to take advantage of proper layer caching.
- ENV's are not inherited from the upstream image.

```
FROM nginx:latest
ENV SOMEENVVAR 1024
RUN apt-get update
WORKDIR /usr/share/nginx/html
COPY index.html index.html
VOLUME /var/lib/mysql
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

Build image from Dockerfile:

```
docker image build -t rafops/nginx:custom .
```

## Logging

Log everything to STDOUT and STDERR:

```
ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log
```

## Volumes

- Containers are usually immutable and ephemeral.
- Volumes: Storage outside of container UFS.
- Volumes persist after stopping/deleting a container.

List volumes:

```
docker volume ls
```

Name a volume as *mysql-db* during a container run:

```
docker container run -d --name mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=True \
  -v mysql-db:/var/lib/mysql \
  mysql
```

Create a volume:

```
docker volume create …
```

## Bind mounting

- Bind Mounts: Link container path to host path.

```
docker container run … -v $HOME/data:/data
```

## Docker Compose

- Configure relationship between containers.
- YAML formatted file that describes containers, networks and volumes.
- Can be used locally with docker-compose or in production environment with Swarm.
- Use multiple files with `-f` to stack overrides for different environments:
 
```
docker-compose up
docker-compose down
```

Detached:

```
docker-compose up -d
```

Show running processes:

```
docker-compose ps
docker-compose top
```

Build image:

```
docker-compose build 
```

## Services

- Swarm is a clustering solution built inside Docker
- How do we automate container lifecycle?
- How can we scale up/down?
- How to do blue/green deploy?
- How track where containers are deployed?
- How to do secret management?
- Composed by Managers+Internal distributed data store and Workers
- Each Swarm node is a different machine
- `docker-machine` can provision machines for AWS, etc. Use ECS instead?

**Example**

- Service: 3 Nginx replicas (Swarm manager)
- Task: nginx.1 (nginx:latest container) => Available Node 1
- Task: nginx.2 (nginx:latest container) => Available Node 2
- Task: nginx.3 (nginx:latest container) => Available Node 3

**Manager Node**

- API: Accepts command from client and creates service object
- Orchestrator: Reconciliation loop for service objects and creates tasks
- Allocator: Allocates IP addresses to tasks
- Scheduler: Assigns nodes to tasks
- Dispatcher: Checks in on workers

**Worker Node**

- Worker: Connects to dispatcher to check on assigned tasks
- Executor: Executes the tasks assigned to worker node

**Initialize Swarm**

- Creates Root Signed Certificated for our swarm
- Certificate is issued for first manager node
- Join tokens are created
- Raft database created to store root CA, configs and secrets

```
docker swarm init
```

Show leader manager:

```
docker node ls
```

Create a new service:

```
docker service create alpine ping 8.8.8.8
```

Show which node service is running:

```
docker service ps <SERVICE NAME>
```

Scale up service:

```
docker service update <SERVICE ID> --replicas 3
```

Create nodes with `docker-machine` and VirtualBox:

```
docker-machine create node1
docker-machine ssh node1
docker-machine env node1
```

TODO:

- Overlay network (uses VIP). Load balances Swarm services.
- Routing mesh. Layer 3 (TCP) load balancer. Use nginx or haproxy for Layer 4 load balancer (DNS).

## Stacks

- Requires version 3 or later.
- Stacks accept Compose files as their declarative definition for services, networks, volumes, and secrets.
- Compose ignores `deploy:`, Swarm ignores `build:`.
- Changes to the .yml file can be applied with deploy command.

To deploy a stack (add processes to the scheduler):

```
docker stack deploy -c my-app.yml myapp
```

To list services in the stack:

```
docker stack services myapp
```

To list processes:

```
docker stack ps myapp
```

To list networks created by the stack:

```
docker network ls
```

## Secrets

- Secrets are managed by Raft DB, only stored on disk on Manager nodes.
- Only containers in assigned Service(s) can see them.
- They look like files in container but are actually in-memory fs.
- Local docker-compose can use file-based secrets to simulate the Swarm environment.

To create a secret:

```
docker secret create secret_key_name secret_file.txt
```

To list secrets:

```
docker secret ls
```

To inspect:

```
docker inspect secret_key_name
```

Assign secret to a service:

```
docker service create --name myservice --secret secret_key_name -e SECRET_ENV_FILE=/run/secrets/secret_key_name
```

- The option `-e` above sets an environment variable `SECRET_ENV` based on the specified secret file.
- These environment variables can be defined in the YAML file within `environment:` section
- docker-compose bind mount in run time to simulate secrets in development mode.

```
postgres:
  image: postgres:9.6
  environment:
    - POSTGRES_PASSWORD_FILE=/run/secrets/password
  secrets:
    - password
```

```
echo "s3cr3t" | docker secret create password -
```

## Application Lifecycle

- Development environment: docker-compose up
- CI environment: Remote docker-compose up
- Production: docker stack deploy
 
## Docker Registry
 
- Can run as a hub caching/failover via `--registry-mirror` to optmize image downloading within a company/cloud network.
- Preferably use a SaaS hosted solution.

Run a registry:

```
docker container run -d -p 5000:5000 --name registry registry
```

Pull to a local registry:

```
docker tag hello-world 127.0.0.1:5000/hey-wrld
docker push 127.0.0.1:5000/hey-wrld
```

## Old Notes

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
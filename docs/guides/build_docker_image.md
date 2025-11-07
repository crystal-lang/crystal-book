# Build Docker Image

When your Crystal application is developed, you can build a Docker image for using it portably. To do this, you can use the Crystal's Docker Image that are available on the [Docker hub](https://hub.docker.com/r/crystallang/crystal/tags?name=1).

For example, let's suppose we create a simple program that displays "Hello World":

```cr title="program.cr"
puts "Hello World"
```

To proceed to the compilation of your program, we can use the Dockerfile and that's what we will look at in this guide.

```dockerfile
FROM crystallang/crystal:1

WORKDIR /app
COPY ./program.cr /app

RUN crystal build program.cr -o program --release --static \
    --progress --stats --no-debug

CMD ["bin/program"]
```

!!!info
    You can also use `shards build` to compile the program.

Once the Dockerfile is configured, we can now build a Docker image by running the command:

```cr
docker build -t program:latest .
```

Finally, the Docker image is built with the matched name.

```sh
$ docker image ls program
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
program      latest    fd8159825ab7   5 seconds ago   471MB
```

The disadvantage is that the size of this Docker image is large, which leads to things that are not really useful for running a program, such as the Crystal compiler and the `shards` binary. It is possible to optimize the image size by using a multi-step build.

## Multi-stage builds

The Multi-stage builds consist to compile the program in the first image and copying it to another image adapted for production mode.

```dockerfile
# Build stage
FROM crystallang/crystal:1 AS build

COPY . /app
WORKDIR /app

RUN crystal build program.cr -o program --release --static \
--progress --stats --no-debug

# Prod stage
FROM ubuntu AS prod

WORKDIR /usr/local

COPY --from=build /app/program /usr/local/bin/program

CMD ["bin/program"]
```

The advantage is that the production image will be less heavy, containing only the programs and libraries necessary for it to be operational.

Result: you will get the Docker image with a reasonable size.

```sh
$ docker image ls program
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
program      latest    42a3633f95c9   4 seconds ago   79.7MB
```

!!! note
    The image size depends on the size of the executable and the libraries.

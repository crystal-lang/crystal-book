# Build Docker Image

When your Crystal application is developed, you can build a Docker image for using it portably.

If you build your program in the production mode, it is recommended to use the Crystal's Docker Image with the Alpine version. You can find a set of images on the [Docker hub](https://hub.docker.com/r/crystallang/crystal/tags?name=1-alpine).

For example, let's suppose we create a simple program that lists the persons:

```cr title="program.cr"
class Person
  def initialize(@first_name : String, @last_name : String); end

  def full_name : String
    [@first_name, @last_name].join(' ')
  end
end

class People
  class_getter persons = [] of Person
end

People.persons << Person.new("John", "Doe")
People.persons << Person.new("Jane", "Doe")

puts "There are #{People.persons.size} persons:"

People.persons.each do |person|
  puts "- #{person.full_name}"
end
```

To proceed to the compilation of your program, we can use the Dockerfile and there are two ways. That's what we will look at in this guide.

## With the `crystal build` command

The first way to compile your program is to use the `crystal build` command.

```dockerfile
# Build stage
FROM crystallang/crystal:1-alpine AS build

COPY ./program.cr /app
WORKDIR /app

RUN crystal build program.cr -o program --release --static \
    --progress --stats --no-debug

# Prod stage
FROM alpine:3.20 AS prod

WORKDIR /usr/local

COPY --from=build /app/program /usr/local/bin/program

CMD ["bin/program"]
```

!!!info
    You can replace `/usr/local` by the executable path where you want to place the program.

## With the `shards` command

By default, the Crystal Docker image includes the `shards` package manager. This is useful for compiling your program.

```dockerfile
# Build stage
FROM crystallang/crystal:1-alpine AS build

COPY . /app
WORKDIR /app

RUN shards build program --release --static --progress \
    --stats --no-debug

# Prod stage
FROM alpine:3.20 AS prod

WORKDIR /usr/local

COPY --from=build /app/program /usr/local/bin/program

CMD ["bin/program"]
```

# Build with `docker build`

Once the Dockerfile is configured, we can now build a Docker image by running the command:

In both cases, you get a Docker image with a reasonable size.

```sh
$ docker image ls program
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
program      latest    0c5c52c894ba   5 minutes ago   9.52MB
```

!!! note
    The image size depends on the size of the executable and the libraries if you don't use the `--static` option.
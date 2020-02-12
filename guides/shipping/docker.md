# Shipping with Docker

Already at the docks?! Not at all, matey, we’ve just started the journey! Docker will let us ship our application in a more homogeneous way.

We will create a `Dockerfile` that will let us:
* create a base image
* build the application
* list the dependencies
* build a custom docker image (only with our application and the dependencies) based on a small docker image.

And then we will publish the final image (with our application)

## Creating the Dockerfile

Let’s create a `Dockerfile`. This file will create a docker image from other image: `crystallang/crystal:latest`, which is based on Ubuntu and it ships with the Crystal compiler. On the other hand, we will use multistage-build, so that our new image will be as small as possible (brave buccaneers have [already sailed](https://manas.tech/blog/2017/04/03/shipping-crystal-apps-in-a-small-docker-image/) these [wild seas](https://gist.github.com/bcardiff/85ae47e66ff0df35a78697508fcb49af)).

Our `Dockerfile` will look like this:

```dockerfile
FROM crystallang/crystal:latest

ADD . /src
WORKDIR /src
RUN shards build --production

RUN ldd bin/staticserver | tr -s '[:blank:]' '\n' | grep '^/' | \
   xargs -I % sh -c 'mkdir -p $(dirname deps%); cp % deps%;'

FROM scratch
COPY --from=0 /src/deps /
COPY --from=0 /src/bin/staticserver /staticserver

EXPOSE 80

ENTRYPOINT ["/staticserver"]
```

**Note:** if you are building an application that needs static files (for example: you are building a Web Application and you need `favicon.ico`), in that case we would need to copy those files to the final image using `COPY`.

Let’s build it with:

```shell-session
$ docker build -t "staticserver:0.1.0" .
```

Was our image created? Well, I hope so (or someone will be _walking the plank_)
To be certain, let’s run:

```shell-session
$ docker images
REPOSITORY	TAG		IMAGE ID		CREATED		SIZE
staticserver	0.1.0	0b57eeef751c	9 seconds ago	10.4MB
```

Sink Me!! Only 10.4MB! This is great!

**Why are we listing the dependencies inside the container?**

We are doing this because the dependencies would be different depending on the Operating System the application is running (or will run). In this case we need the dependencies for an Ubuntu distribution.

**And why are we using multistage-build?**

Well, first we need the Crystal compiler for building our application, so we base our image on the `crystallang/crystal:latest`image.
Then we won’t need the compiler anymore, so we base the final image on Docker Official Image [scratch](https://hub.docker.com/_/scratch/). In case the `scratch` image is not enough then we may use another image based on Ubuntu since the Crystal image is based on this Linux distribution.

**Wait! and if I’m using an external library like `sqlite`?**

Oh well, in that case we are going to need it for compiling and then the script should make the external library available in the final image.

Continuing our example, before publishing our image let’s see if it’s working:

```shell-session
$ docker run --rm -it -v ${PWD}:/www -p 8080:80 staticserver:0.1.0
Listening on http://0.0.0.0:80 and serving files in path /www
```

If we go to our browser and navigate to `http://localhost:8080` then we will see the files list. Yarr!

### Publishing

Finally, we only have to publish our new image with our application!
To do so, we may use [`docker push`](https://docs.docker.com/engine/reference/commandline/push/) to push the image to a registry (for example [Docker Hub](https://hub.docker.com/))

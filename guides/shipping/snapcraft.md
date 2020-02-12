# Shipping with snapcraft.io

Snapcraft will allow us to package and publish our application for users using Linux. Also, it will allow the users to discover our application more easily through the [Snapcraft Store](https://snapcraft.io/store)
We only need to create a configuration file where we set the language, the application and dependencies. So let’s start!

## Creating the snap

As the [snapcraft documentation](https://snapcraft.io/docs) says _Snaps are app packages for desktop, cloud and IoT that are easy to install, secure, cross-platform and dependency-free_ And also important: they are **containerised** software.

To describe our application, Snapcraft uses a [snapcraft.yaml](https://snapcraft.io/docs/snapcraft-yaml-reference) file. In our example, the file `snapcraft.yaml` will be located in a folder called `snap` and it will look like this:

```yaml
name: crystal-staticserver
version: "0.1.0"
summary: Create the static file server snap
description: Create the static file server snap

base: core
grade: devel
confinement: classic
build-packages:
 - libz-dev
 - libssl-dev

apps:
 crystal-staticserver:
   command: bin/staticserver

parts:
 crystal-staticserver:
   plugin: crystal
   source: ./
```

Let’s see some of the fields:

`name`, `version`, `summary` and `description` define and describe our application, allowing users to easily find software in the store.

The `base` field will let us specify a [base snap](https://snapcraft.io/docs/base-snaps) which will _provide a run-time environment with a minimal set of libraries_.
In our example `base: core` is based on `Ubuntu 16.04 LTS`

The `grade` field could be `stable` or `devel` (for development). This will have an impact on the [channels](https://snapcraft.io/docs/channels) where our application could be published.

The `confinement`field will set the [degree of isolation](https://snapcraft.io/docs/snap-confinement)

In the `build-packages` field we may list needed libraries for building our application.

In the `apps` field we will set `app-name` and the `command` to run it.

The `parts` field will let us define the differents [building blocks](https://snapcraft.io/docs/snapcraft-parts-metadata) that form our application.
Here, in the `plugin` field we may set the tool that will drive the building process. In our example we will use the [crystal plugin](https://snapcraft.io/docs/the-crystal-plugin)

Great! Now, we only need to build the package, using:

```shell-session
$ snapcraft
Launching a VM.
Starting snapcraft-crystal-staticserver -
...
Snapping 'crystal-staticserver' \
Snapped crystal-staticserver_0.1.0_amd64.snap
```

## Publishing

Finally, to share our application to the world, we need to publish it in the Snapcraft Store. Follow the steps described in the [official documentation](https://snapcraft.io/docs/releasing-your-app)

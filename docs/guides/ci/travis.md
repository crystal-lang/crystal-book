# Travis CI

In this section we are going to use [Travis CI](https://travis-ci.org/) as our continuous-integration service. Travis CI is [mostly used](https://docs.travis-ci.com/user/tutorial/#more-than-running-tests) for building and running tests for projects hosted at GitHub. It supports [different programming languages](https://docs.travis-ci.com/user/tutorial/#selecting-a-different-programming-language) and for our particular case, it supports the [Crystal language](https://docs.travis-ci.com/user/languages/crystal/).

!!! note
    If you are new to continuous integration (or you want to refresh the basic concepts) we may start reading the [core concepts guide](https://docs.travis-ci.com/user/for-beginners/).

Now let's see some examples!

## Build and run specs

### Using `latest` and `nightly`

A first (and very basic) Travis CI config file could be:

!!! example ".travis.yml"
    ```yaml
    language: crystal
    ```

That's it! With this config file, Travis CI by default will run `crystal spec`.
Now, we just need to go to Travis CI dashboard to [add the GitHub repository](https://docs.travis-ci.com/user/tutorial/#to-get-started-with-travis-ci).

Let's see another example:

!!! example ".travis.yml"
    ```yaml
    language: crystal

    crystal:
      - latest
      - nightly

    script:
      - crystal spec
      - crystal tool format --check
    ```

With this configuration, Travis CI will run the tests using both Crystal `latest` and `nightly` releases on every push to a branch on your Github repository.

!!! note
    When [creating a Crystal project](../../using_the_compiler/#creating-a-crystal-project) using `crystal init`, Crystal creates a `.travis.yml` file for us.

### Using a specific Crystal release

Let's suppose we want to pin a specific Crystal release (maybe we want to make sure the shard compiles and works with that version) for example [Crystal 0.31.1](https://github.com/crystal-lang/crystal/releases/tag/0.31.1).

Travis CI only provides _runners_ to `latest` and `nightly` releases directly and so, we need to install the requested Crystal release manually. For this we are going to use [Docker](https://www.docker.com/).

First we need to add Docker as a service in `.travis.yml`, and then we can use `docker` commands in our build steps, like this:

!!! example ".travis.yml"
    ```yaml
    language: minimal

    services:
      - docker

    script:
      - docker run -v $PWD:/src -w /src crystallang/crystal:0.31.1 crystal spec
    ```

!!! note
    We may read about different [languages](https://docs.travis-ci.com/user/languages/) supported by Travis CI, included [minimal](https://docs.travis-ci.com/user/languages/minimal-and-generic/).

!!! note
    A list with the different official [Crystal docker images](https://hub.docker.com/r/crystallang/crystal/tags) is available at [DockerHub](https://hub.docker.com/r/crystallang/crystal).

### Using `latest`, `nightly` and a specific Crystal release all together!

Supported _runners_ can be combined with Docker-based _runners_ using a [Build Matrix](https://docs.travis-ci.com/user/customizing-the-build#build-matrix). This will allow us to run tests against `latest` and `nightly` and pinned releases.

Here is the example:

!!! example ".travis.yml"
    ```yaml
    matrix:
    include:
      - language: crystal
        crystal:
          - latest
        script:
          - crystal spec

      - language: crystal
        crystal:
          - nightly
        script:
          - crystal spec

      - language: bash
        services:
          - docker
        script:
          - docker run -v $PWD:/src -w /src crystallang/crystal:0.31.1 crystal spec
    ```

## Installing shards packages

In native _runners_ (`language: crystal`), Travis CI already automatically installs shards dependencies using `shards install`. To improve build performance we may add [caching](#caching) on top of that.

### Using Docker

In a Docker-based _runner_ we need to run `shards install` explicitly, like this:

!!! example ".travis.yml"
    ```yaml
    language: bash

    services:
      - docker

    script:
      - docker run -v $PWD:/src -w /src crystallang/crystal:0.31.1 shards install
      - docker run -v $PWD:/src -w /src crystallang/crystal:0.31.1 crystal spec
    ```

!!! note
    Since the shards will be installed in `./lib/` folder, it will be preserved for the second docker run command.

## Installing binary dependencies

Our application or maybe some shards may required libraries and packages. This binary dependencies may be installed using different methods. Here we are going to show an example using the [Apt](https://help.ubuntu.com/lts/serverguide/apt.html) command (since the Docker image we are using is based on Ubuntu)

Here is a first example installing the `libsqlite3` development package using the [APT addon](https://docs.travis-ci.com/user/installing-dependencies/#installing-packages-with-the-apt-addon):

!!! example ".travis.yml"
    ```yaml
    language: crystal
    crystal:
      - latest

    before_install:
      - sudo apt-get -y install libsqlite3-dev

    addons:
      apt:
        update: true

    script:
      - crystal spec
    ```

### Using Docker

We are going to build a new docker image based on [crystallang/crystal](https://hub.docker.com/r/crystallang/crystal/), and in this new image we will be installing the binary dependencies.

To accomplish this we are going to use a [Dockerfile](https://docs.docker.com/engine/reference/builder/):

!!! example "Dockerfile"
    ```dockerfile
    FROM crystallang/crystal:latest

    # install binary dependencies:
    RUN apt-get update && apt-get install -y libsqlite3-dev
    ```

And here is the Travis CI configuration file:

!!! example ".travis.yml"
    ```yaml
    language: bash

    services:
      - docker

    before_install:
      # build image using Dockerfile:
      - docker build -t testing .

    script:
      # run specs in the container
      - docker run -v $PWD:/src -w /src testing crystal spec
    ```

!!! note
    Dockerfile arguments can be used to use the same Dockerfile for latest, nightly or a specific version.

## Using services

Travis CI may start [services](https://docs.travis-ci.com/user/database-setup/) as requested.

For example, we can start a [MySQL](https://docs.travis-ci.com/user/database-setup/#mysql) database service by adding a `services:` section to our `.travis.yml`:

!!! example ".travis.yml"
    ```yaml
    language: crystal
    crystal:
      - latest

    services:
      - mysql

    script:
      - crystal spec
    ```

Here is the new test file for testing against the database:

!!! example "spec/simple_db_spec.cr"
    ```crystal
    require "./spec_helper"
    require "mysql"

    it "connects to the database" do
      DB.connect ENV["DATABASE_URL"] do |cnn|
        cnn.query_one("SELECT 'foo'", as: String).should eq "foo"
      end
    end
    ```

When pushing this changes Travis CI will report the following error: `Unknown database 'test' (Exception)`, showing that we need to configure the MySQL service **and also setup the database**:

!!! example ".travis.yml"
    ```yaml
    language: crystal
    crystal:
      - latest

    env:
      global:
        - DATABASE_NAME=test
        - DATABASE_URL=mysql://root@localhost/$DATABASE_NAME

    services:
      - mysql

    before_install:
      - mysql -e "CREATE DATABASE IF NOT EXISTS $DATABASE_NAME;"
      - mysql -u root --password="" $DATABASE_NAME < db/schema.sql

    script:
      - crystal spec
    ```

We are [using a `schema.sql` script](https://andidittrich.de/2017/06/travisci-setup-mysql-tablesdata-before-running-tests.html) to create a more readable `.travis.yml`. The file `./db/schema.sql` looks like this:

!!! example "schema.sql"
    ```sql
    CREATE TABLE ... etc ...
    ```

Pushing these changes will trigger Travis CI and the build should be successful!

## Caching

If we read Travis CI job log, we will find that every time the job runs, Travis CI needs to fetch the libraries needed to run the application:

```
Fetching https://github.com/crystal-lang/crystal-mysql.git
Fetching https://github.com/crystal-lang/crystal-db.git
```

This takes time and, on the other hand, these libraries might not change as often as our application, so it looks like we may cache them and save time.

Travis CI [uses caching](https://docs.travis-ci.com/user/caching/) to improve some parts of the building path. Here is the new configuration file **with cache enabled**:

!!! example ".travis.yml"
    ```yaml
    language: crystal
    crystal:
      - latest

    cache: shards

    script:
      - crystal spec
    ```

Let's push these changes. Travis CI will run, and it will install dependencies, but then it will cache the shards cache folder which, usually, is `~/.cache/shards`. The following runs will use the cached dependencies.

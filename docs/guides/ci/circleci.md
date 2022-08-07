# CircleCI

In this section we are going to use [CircleCI](https://circleci.com/) as our continuous-integration service. In a [few words](https://circleci.com/docs/2.0/about-circleci/#section=welcome) CircleCI automates your software builds, tests, and deployments. It supports [different programming languages](https://circleci.com/docs/2.0/demo-apps/#section=welcome) and for our particular case, it supports the [Crystal language](https://circleci.com/docs/2.0/language-crystal/).

In this section we are going to present some configuration examples to see how CircleCI implements some [continuous integration concepts](https://circleci.com/docs/2.0/concepts/).

## CircleCI orbs

Before showing some examples, it’s worth mentioning [CircleCI orbs](https://circleci.com/orbs/). As defined in the official docs:
> Orbs define reusable commands, executors, and jobs so that commonly used pieces of configuration can be condensed into a single line of code.

In our case, we are going to use [Crystal’s Orb](https://circleci.com/orbs/registry/orb/manastech/crystal)

## Build and run specs

### Simple example using `latest`

Let’s start with a simple example. We are going to run the tests **using latest** Crystal release:

```yaml title=".circleci/config.yml"
workflows:
  version: 2
  build:
    jobs:
      - crystal/test

orbs:
  crystal: manastech/crystal@1.0
version: 2.1
```

Yeah! That was simple! With Orbs an abstraction layer is built so that the configuration file is more readable and intuitive.

In case we are wondering what the job [crystal/test](https://circleci.com/orbs/registry/orb/manastech/crystal#jobs-test) does, we always may see the source code.

### Using `nightly`

Using nightly Crystal release is as easy as:

```yaml title=".circleci/config.yml"
workflows:
  version: 2
  build:
    jobs:
      - crystal/test:
          name: test-on-nightly
          executor:
            name: crystal/default
            tag: nightly

orbs:
  crystal: manastech/crystal@1.0
version: 2.1
```

### Using a specific Crystal release

```yaml title=".circleci/config.yml"
workflows:
  version: 2
  build:
    jobs:
      - crystal/test:
          name: test-on-0.30
          executor:
            name: crystal/default
            tag: 0.30.0

orbs:
  crystal: manastech/crystal@1.0
version: 2.1
```

## Installing shards packages

You need not worry about it since the `crystal/test` job runs the `crystal/shard-install` orb command.

## Installing binary dependencies

Our application or maybe some shards may require libraries and packages. This binary dependencies may be installed using the [Apt](https://help.ubuntu.com/lts/serverguide/apt.html) command.

Here is an example installing the `libsqlite3` development package:

```yaml title=".circleci/config.yml"
workflows:
  version: 2
  build:
    jobs:
      - crystal/test:
          pre-steps:
            - run: apt-get update && apt-get install -y libsqlite3-dev

orbs:
  crystal: manastech/crystal@1.0
version: 2.1
```

## Using services

Now, let’s run specs using an external service (for example MySQL):

```yaml title=".circleci/config.yml"
executors:
  crystal_mysql:
    docker:
      - image: 'crystallang/crystal:latest'
        environment:
          DATABASE_URL: 'mysql://root@localhost/db'
      - image: 'mysql:5.7'
        environment:
          MYSQL_DATABASE: db
          MYSQL_ALLOW_EMPTY_PASSWORD: 'yes'

workflows:
  version: 2
  build:
    jobs:
      - crystal/test:
          executor: crystal_mysql
          pre-steps:
            - run:
                name: Waiting for service to start (check dockerize)
                command: sleep 1m
            - checkout
            - run:
                name: Install MySQL CLI; Import dummy data
                command: |
                        apt-get update && apt-get install -y mysql-client
                        mysql -h 127.0.0.1 -u root --password="" db < test-data/setup.sql

orbs:
  crystal: manastech/crystal@1.0
version: 2.1
```

NOTE: The explicit `checkout` in the `pre-steps` is to have the `test-data/setup.sql` file available.

## Caching

Caching is enabled by default when using the job `crystal/test`, because internally it uses the `command` [with-shards-cache](https://circleci.com/orbs/registry/orb/manastech/crystal#commands-with-shards-cache)

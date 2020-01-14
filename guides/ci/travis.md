# Travis CI

If you are new to continuous integration (or you want to refresh the basic concepts) we may start reading the [core concepts guide](https://docs.travis-ci.com/user/for-beginners/) and then a [short tutorial](https://docs.travis-ci.com/user/tutorial/).

Now let's see an example of using Travis CI with Crystal.

## Build and run specs

### Using `latest` and `nightly`

When [creating a Crystal project](../../using_the_compiler/#creating-a-crystal-project) using `crystal init`, Crystal creates a `.travis.yml` file for us:

```yaml
# .travis.yml
language: crystal

crystal:
  - latest
  - nightly

script:
  - crystal spec
  - crystal tool format --check
```

Although a basic configuration file, it will let us use Travis CI. Now, let's go to Travis CI dashboard to [add the GitHub repository](https://docs.travis-ci.com/user/tutorial/#to-get-started-with-travis-ci). From this moment, Travis CI will run the `specs` against the Crystal compiler (using both `latest` and `nightly` releases).

### Using a specific Crystal release

So, let's suppose we want to use version [0.31.1](https://github.com/crystal-lang/crystal/releases/tag/0.31.1) of the Crystal compiler. For this we are going to use [Docker](https://www.docker.com/). First we need to add Docker as a service in `.travis.yml`, and then we can use `docker` commands in our build steps, like this:

```yml
# .travis.yml
language: bash

services:
  - docker

script:
  - docker run -v $PWD:/src -w /src crystallang/crystal:0.31.1 crystal spec
```

**Note:** A list with the different official [Crystal docker images](https://hub.docker.com/r/crystallang/crystal/tags) is available at [DockerHub](https://hub.docker.com/r/crystallang/crystal).

### Using `latest`, `nightly` and a specific Crystal release all together!

For using 3 versions of the compiler we are going to use a different configuration file based on [Build Matrix](https://docs.travis-ci.com/user/customizing-the-build#build-matrix)
Here is the example:

```yaml
# .travis.yml
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

## Using binary dependencies

Before presenting some examples, it is important to mention that there are many ways to achieve this and **it will heavily depend on our development workflow**.

With this in mind, let's continue!

Using shards dependencies (i.e. libraries declared in `shard.yml`) will not be a problem because, thanks to the `language: crystal` support, Travis CI automatically runs `shards install`.

But, how do we install dependencies outside `shards.yml`?
Well, here is a first example installing SQLite3 using Travis CI configuration file:

```yaml
# .travis.yml
language: crystal
crystal:
  - latest

before_install:
  - sudo apt-get -y install sqlite3

addons:
  apt:
    update: true

script:
  - sqlite3 --version
  - crystal spec
```

**Note:** We are using `sqlite3` just for printing SQLite's version, as an example of external dependency.

The same can be accomplished using a containerization service like Docker. Here is an example of a `Dockerfile` installing SQLite3:

```dockerfile
# Dockerfile
FROM crystallang/crystal:latest

RUN apt-get update && apt-get install -y sqlite3
```

And here is the Travis CI configuration file:

```yml
# .travis.yml
language: bash

services:
  - docker

before_install:
  # build image using Dockerfile:
  - docker build -t testing .

script:
  # run specs in the container
  - docker run -v $PWD:/src -w /src testing crystal spec
  # sqlite3
  - docker run -v $PWD:/src -w /src testing sqlite3 --version
```

Again, these are only examples of two ways of running our application and installing (and using) dependencies.

> *Note:* Dockerfile arguments can be used to use the same Dockerfile for latest, nightly or a specific version.

## Using a database (example using MySQL)

As you may notice, in the last configuration file we are using `docker` as a `service`. Travis CI may start different services as needed. For example, we may need [MySQL](https://docs.travis-ci.com/user/database-setup/#mysql).

```yaml
# .travis.yml
language: crystal
crystal:
  - latest

services:
  - mysql

script:
  - crystal spec
```

Here is the new test file for testing against the database:

```crystal
# spec/simple_db_spec.cr
require "./spec_helper"
require "mysql"

it "connects to the database" do
  DB.connect ENV["DATABASE_URL"] do |cnn|
    cnn.query_one("SELECT 'foo'", as: String).should eq "foo"
  end
end
```

When pushing this changes Travis CI will report the following error: `Unknown database 'test' (Exception)`, showing that we need to configure the MySQL service **and also setup the database**:

> It's really **important** to notice that the lines we are adding to `.travis.yml` will depend exclusively on the development workflow we are using!
> And remember that this is only an example using MySQL.

```yaml
# .travis.yml
language: crystal
crystal:
  - latest

env:
  - DATABASE_URL="mysql://root@localhost/test"

services:
  - mysql

before_install:
  - mysql -u root --password="" < test-data/setup.sql

script:
  - crystal spec
```

We are [using a `setup.sql` script](https://andidittrich.de/2017/06/travisci-setup-mysql-tablesdata-before-running-tests.html) to create a more readable `.travis.yml`. The file `./test-data/setup.sql` looks like this:

```sql
-- setup.sql
CREATE DATABASE IF NOT EXISTS test;
-- CREATE TABLE ... etc ...
```

Pushing these changes will trigger Travis CI and the build should be successful!!

## Caching

If we read Travis CI job log, we will find that every time the job runs, Travis CI needs to fetch the libraries needed to run the application:

```log
Fetching https://github.com/crystal-lang/crystal-mysql.git
Fetching https://github.com/crystal-lang/crystal-db.git
```

This takes time and on the other hand these libraries might not change as often as our application, so it looks like we may cache them and save time.

Travis CI [uses caching](https://docs.travis-ci.com/user/caching/) to improve some parts of the building path. For our example. Here is the new configuration file **with cache enabled**:

```yml
# .travis.yml
language: crystal
crystal:
  - latest

env:
  - DATABASE_URL="mysql://root@localhost/test"

cache:
  directories:
    - $HOME/.cache/shards

services:
  - mysql

before_install:
  - mysql -u root --password="" < travisci/test.sql

script:
  - crystal spec
```

Let's push these changes. Travis CI will run, and it will install dependencies, but then it will cache the `$HOME/.cache/shards` folder. The following runs will use the cached dependencies.

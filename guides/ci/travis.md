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

Although a basic configuration file, it will let's use Travis CI. Now, let's go to Travis CI dashboard to [add the GitHub repository](https://docs.travis-ci.com/user/tutorial/#to-get-started-with-travis-ci). From this moment, Travis CI will run the `specs` against the Crystal compiler (using both `latest` and `nightly` releases)

### Using a specific Crystal release

So, let's suppose we want to use version [0.31.1](https://github.com/crystal-lang/crystal/releases/tag/0.31.1)
 of the Crystal compiler. We will be tempting to add `- 0.31.1`. But, as we may read at the [Crystal configuration options](https://docs.travis-ci.com/user/languages/crystal/#configuration-options), we can only use the values `latest` and `nightly`.

So, how do we test against a specific version?

For this we are going to use [Docker](https://www.docker.com/). First we need to add Docker as a service in `.travis.yml`, and then use `docker` from the CLI to run the specs with a specific Crystal version, like this:

```yml
# .travis.yml
language: bash

services:
  - docker

script:
  - docker run -v $PWD:/src -w /src crystallang/crystal:0.31.1 crystal spec
```

**Note:** We may find the list with the different official [Crystal docker images](https://hub.docker.com/r/crystallang/crystal/tags) at [DockerHub](https://hub.docker.com/r/crystallang/crystal).

**Note:** This is a great trick that will let us use different Crystal versions without the need of actually installing the compiler and without the need of creating a `Dockerfile` configuration file.

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

## Using external dependencies

Before presenting some examples, it is important to mention that there are many ways to achieve this and **it will heavily depend on our development workflow**.

With this in mind, let's continue!

Using shards dependencies (i.e. libraries declared in `shard.yml`) will not be a problem, because thanks to the `language: crystal` support, TravisCI automatically runs `shards install`. But, how do we install dependencies outside `shards.yml`? Well, here is a first example installing SQLite3 using Travis CI configuration file:

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

And here is the TravisCI configuration file:

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

## Using a database (example using MySQL)

As you may notice, in the last configuration file we are using `docker` as a `service`. Travis CI may start different services as needed. For example, we may need  [MySQL](https://docs.travis-ci.com/user/database-setup/#mysql)

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

To continue this example, let's add a new test that uses the database.
(**important:** the new test case is only for testing Travis CI database service, and it's not a good design or test case by any means)

```crystal
# game_of_life_spec.cr
require "./spec_helper"

describe "a new world" do
  it "should be empty" do
    world = World.new
    world.is_empty?.should be_true
  end
end

describe "an empty world" do
  it "should not be empty after adding a cell" do
    world = World.empty
    world.set_living_at(Location.random)
    world.is_empty?.should be_false
  end

  it "should be persisted" do
    World.empty.save
  end
end
```

And the new implementation:

```crystal
# game_of_life.cr
require "mysql"

class Location
  getter x : Int32
  getter y : Int32

  def self.random
    Location.new(Random.rand(10), Random.rand(10))
  end

  def initialize(@x, @y)
  end
end

class World
  @living_cells : Array(Location)

  def self.empty
    World.new([] of Location)
  end

  def initialize
    initialize([] of Location)
  end

  def initialize(living_cells)
    @living_cells = living_cells
  end

  def set_living_at(a_location)
    @living_cells << a_location
  end

  def is_empty?
    @living_cells.size == 0
  end

  def save
    DB.connect ENV["DATABASE_URL"], do |cnn|
      cnn.exec("insert into worlds (living_cells) values (?);", @living_cells.size)
    end
  end
end
```

We may use this `docker-compose` configuration to have a local MySQL database for our test to run:

```yaml
version: '3'

services:
  db:
    image: mysql:8.0.17
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    environment:
      MYSQL_ALLOW_EMPTY_PASSWORD: 'yes'
    container_name: conways_db
    ports:
      - 3306:3306

volumes:
  db:
```

and start the container with:

```shell-session
$ docker-compose up
```

Using your favourite database client, we need to create a `database` named `test` with a `table` called `worlds` with two columns: `id` and `living_cells` (`int`).

And set the environment variable:

```shell-session
$ export DATABASE_URL="mysql://root@localhost/test"
```

**Running the `specs` locally** should output 3 examples successfully. But, if we push the changes then Travis CI will report the following error: `Unknown database 'test' (Exception)`
So, we need to configure Travis CI to use a MySQL service **and also setup the database**:

>It's really **important** to notice that the lines we are adding to `.travis.yml` will depend exclusively on the development workflow we are using!
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
  - mysql -e 'CREATE DATABASE IF NOT EXISTS test;'
  - mysql -e 'CREATE TABLE `test`.`worlds` (`id` serial,`living_cells` int NOT NULL DEFAULT 0, PRIMARY KEY (id));'

script:
  - crystal spec
```

Pushing these changes will trigger Travis CI and the build should be successful!!

We [use a `setup.sql` script](https://andidittrich.de/2017/06/travisci-setup-mysql-tablesdata-before-running-tests.html) to create a more readable `.travis.yml` file:

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

and then, the file `./test-data/setup.sql` will look like this:

```sql
-- setup.sql
CREATE DATABASE IF NOT EXISTS test;
CREATE TABLE `test`.`worlds` (`id` serial,`living_cells` int NOT NULL DEFAULT 0, PRIMARY KEY (id));
```

## Caching

If we read Travis CI job log, we will find that every time the job runs, Travis CI needs to fetch the libraries needed to run the application:

```log
Fetching https://github.com/crystal-lang/crystal-mysql.git
Fetching https://github.com/crystal-lang/crystal-db.git
```

This takes time and on the other hand these libraries might not change as often as our application, so it looks like we may cache them and save time.

Travis CI [uses caching](https://docs.travis-ci.com/user/caching/) to improve some parts of the building path. For our example. here is the new configuration file **with cache enabled**:

```yml
# .travis.yml
language: crystal
crystal:
  - latest

env:
  - DATABASE_URL="mysql://root@localhost/test"

cache:
  directories:
    - lib
    - $HOME/.cache/shards

services:
  - mysql

before_install:
  - mysql -u root --password="" < travisci/test.sql

script:
  - crystal spec
```

Let's push these changes. Travis CI will run, and it will install dependencies, but then it will cache the `lib/` and `$HOME/.cache/shards` folders. The following runs will use the cached dependencies.

# Continuous Integration

The ability of having immediate feedback on what we are working should be one of the most important characteristics in software development. Imagine making one change to our source code and having to wait 2 weeks to see if it broke something? oh! That would be a nightmare! For this, Continuous Integration will help a team to have immediate and frequent feedback about the status of what they are building.

Martin Fowler [defines Continuous Integration](https://www.martinfowler.com/articles/continuousIntegration.html) as
_a software development practice where members of a team integrate their work frequently, usually each person integrates at least daily - leading to multiple integrations per day. Each integration is verified by an automated build (including test) to detect integration errors as quickly as possible. Many teams find that this approach leads to significantly reduced integration problems and allows a team to develop cohesive software more rapidly._

In the next subsections, we are going to present 2 continuous integration tools: [Travis CI](https://travis-ci.org/) and [Circle CI](https://circleci.com/) and use them with a Crystal example application.

These tools not only will let us build and test our code each time the source has changed but also deploy the result (if the build was successful) or use automatic builds, and maybe test against different platforms, to mention a few.

## The example application

We are going to use Conway's Game of Life as the example application. More precisely, we are going to use only the first iterations in [Conway's Game of Life Kata](http://codingdojo.org/kata/GameOfLife/) solution using [TDD](https://martinfowler.com/bliki/TestDrivenDevelopment.html).

Note that we won't be using TDD in the example itself, but we will mimic as if the example code is the result of the first iterations.

Another important thing to mention is that we are using `crystal init` to [create the application](../using_the_compiler/#creating-a-crystal-project).

And here's the implementation:

```crystal
# src/game_of_life.cr
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
    new
  end

  def initialize(living_cells = [] of Location)
    @living_cells = living_cells
  end

  def set_living_at(a_location)
    @living_cells << a_location
  end

  def is_empty?
    @living_cells.size == 0
  end
end
```

And the specs:

```crystal
# spec/game_of_life_spec.cr
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
end
```

And this is all we need for our continuous integration examples! Let's start!

## Continuous Integration step by step

Here's the list of items we want to achieve:

1. Build and run specs using 3 different Crystal's versions:
   * latest
   * nightly
   * 0.31.1 (using a Docker image)
2. Install shards packages
3. Install binary dependencies
4. Use a database (for example MySQL)
5. Cache dependencies to make the build run faster

From here choose your next steps:

* I want to use [Travis CI](./ci/travis.md)
* I want to use [CircleCI](./ci/circleci.md)

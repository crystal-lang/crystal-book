# GitHub Actions

## Build and run specs

To continuously test [our example application](README.md#the-example-application) -- both whenever a commit is pushed and when someone opens a [pull request](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests), add this minimal [workflow file](https://docs.github.com/en/actions/learn-github-actions/introduction-to-github-actions#create-an-example-workflow):

```yaml title=".github/workflows/ci.yml"
on:
  push:
  pull_request:
    branches: [master]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Download source
        uses: actions/checkout@v2
      - name: Install Crystal
        uses: crystal-lang/install-crystal@v1
      - name: Run tests
        run: crystal spec
```

To get started with [GitHub Actions](https://docs.github.com/en/actions/guides/about-continuous-integration#about-continuous-integration-using-github-actions), commit this YAML file into your Git repository under the directory `.github/workflows/`, push it to GitHub, and observe the Actions tab.

TIP: **Quickstart.**
Check out [**Configurator for *install-crystal* action**](https://crystal-lang.github.io/install-crystal/configurator.html) to quickly get a config with the CI features you need. Or continue reading for more details.

This runs on GitHub's [default](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners#supported-runners-and-hardware-resources) "latest Ubuntu" container. It downloads the source code from the repository itself (directly into the current directory), installs Crystal via [Crystal's official GitHub Action](https://github.com/crystal-lang/install-crystal), then runs the specs, assuming they are there in the `spec/` directory.

If any step fails, the build will show up as failed, notify the author and, if it's a push, set the overall build status of the project to failing.

TIP:
For a healthier codebase, consider these flags for `crystal spec`:  
`--order=random` `--error-on-warnings`

### No specs?

If your test coverage isn't great, consider at least adding an example program, and building it as part of CI:

For a library:

```yaml
          - name: Build example
            run: crystal build examples/hello.cr
```

For an application (very good to do even if you have specs):

```yaml
          - name: Build
            run: crystal build src/game_of_life.cr
```

### Testing with different versions of Crystal

By default, the latest released version of Crystal is installed. But you may want to also test with the "nightly" build of Crystal, and perhaps some older versions that you still support for your project. Change the top of the workflow as follows:

```yaml hl_lines="6 14"
jobs:
  build:
    strategy:
      fail-fast: false
      matrix:
        crystal: [0.35.1, latest, nightly]
    runs-on: ubuntu-latest
    steps:
      - name: Download source
        uses: actions/checkout@v2
      - name: Install Crystal
        uses: crystal-lang/install-crystal@v1
        with:
          crystal: ${{ matrix.crystal }}
      - ...
```

All those versions will be tested for *in parallel*.

By specifying the version of Crystal you could even opt *out* of supporting the latest version (which *is* a moving target), and only support particular ones.

### Testing on multiple operating systems

Typically, developers run tests only on Ubuntu, which is OK if there is no platform-sensitive code. But it's easy to add another [system](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners#supported-runners-and-hardware-resources) into the test matrix, just add the following near the top of your job definition:

```yaml hl_lines="6 7"
jobs:
  build:
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, macos-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - ...
```

## Installing Shards packages

Most projects will have external dependencies, ["shards"](https://github.com/crystal-lang/shards#usage). Having declared them in `shard.yml`, just add the installation step into your workflow (after `install-crystal` and before any testing):

```yaml
      - name: Install shards
        run: shards install
```

### Latest or locked dependencies?

If your repository has a checked in `shard.lock` file (typically good for applications), consider the effect that this has on CI: `shards install` will always install the exact versions specified in that file. But if you're developing a library, you probably want to be the first to find out in case a new version of a dependency breaks the installation of your library -- otherwise the users will, because the lock doesn't apply transitively. So, strongly consider running `shards update` instead of `shards install`, or don't check in `shard.lock`. And then it makes sense to add [scheduled runs](https://www.jeffgeerling.com/blog/2020/running-github-actions-workflow-on-schedule-and-other-events) to your repository.

## Installing binary dependencies

Our application or some shards may require external libraries. The approach to installing them can vary widely. The typical way is to install packages using the `apt` command in Ubuntu.

Add the installation step somewhere near the beginning. For example, with `libsqlite3`:

```yaml
      - name: Install packages
        run: sudo apt-get -qy install libsqlite3-dev
```

## Enforcing code formatting

If you want to verify that all your code has been formatted with [`crystal tool format`](../writing_shards.md#coding-style), add the according check as a step near the end of the workflow. If someone pushes code that is not formatted correctly, this will break the build just like failing tests would.

```yaml
      - name: Check formatting
        run: crystal tool format --check
```

Consider also adding this check as a *Git pre-commit hook* for yourself.

## Using the official Docker image

We have been using an "action" to install Crystal into the default OS image that GitHub provides. Which [has multiple advantages](https://forum.crystal-lang.org/t/github-action-to-install-crystal-and-shards-unified-ci-across-linux-macos-and-windows/2837). But you may instead choose to use Crystal's official Docker image(s), though that's applicable only to Linux.

The base config becomes this instead:

```yaml title=".github/workflows/ci.yml" hl_lines="4-5 9"
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: crystallang/crystal:latest
    steps:
      - name: Download source
        uses: actions/checkout@v2

      - name: Run tests
        run: crystal spec
```

Some [other options](https://hub.docker.com/r/crystallang/crystal/tags) for containers are `crystallang/crystal:nightly`, `crystallang/crystal:0.36.1`, `crystallang/crystal:latest-alpine`.

## Caching

The process of downloading and installing dependencies (shards specifically) is done from scratch on every run. With caching in GitHub Actions, we can save some of that duplicated work.

The safe approach is to add the [actions/cache](https://github.com/actions/cache) step (**before the step that uses `shards`**) defined as follows:

```yaml
      - name: Cache shards
        uses: actions/cache@v2
        with:
          path: ~/.cache/shards
          key: ${{ runner.os }}-shards-${{ hashFiles('shard.yml') }}
          restore-keys: ${{ runner.os }}-shards-
      - name: Install shards
        run: shards update
```

DANGER: **Important.**
You **must** use the separate [`key` and `restore-keys`](https://docs.github.com/en/actions/guides/caching-dependencies-to-speed-up-workflows#matching-a-cache-key). With just a static key, the cache would save only the state after the very first run and then keep reusing it forever, regardless of any changes.

But this saves us only the time spent *downloading* the repositories initially.

A "braver" approach is to cache the `lib` directory itself, but that works only if you fully rely on `shard.lock` (see [Latest or locked dependencies?](#latest-or-locked-dependencies)):

```yaml
      - name: Cache shards
        uses: actions/cache@v2
        with:
          path: lib
          key: ${{ runner.os }}-shards-${{ hashFiles('**/shard.lock') }}
      - name: Install shards
        run: shards check || shards install
```

Note that we also made the installation conditional on `shards check`. That saves even a little more time.

## Publishing executables

If your project is an application, you likely want to distribute it as an executable ("binary") file. For the case of Linux x86_64, by far the most popular option is to build and [link statically](../static_linking.md) [on Alpine Linux](../static_linking.md#linux). This means that you *cannot* use GitHub's default Ubuntu container and the install action. Instead, just use the official container:

```yaml title=".github/workflows/release.yml" hl_lines="5 8"
jobs:
  release_linux:
    runs-on: ubuntu-latest
    container:
      image: crystallang/crystal:latest-alpine
    steps:
      - uses: actions/checkout@v2
      - run: shards build --production --release --static --no-debug
```

These steps would be followed by some action to publish the produced executable (`bin/*`), in one of the two ways (or both of them):

* As part of a release: [see complete example](https://github.com/Blacksmoke16/oq/blob/56bd3d306ede15e86481d7b5db4af7f89b85a37f/.github/workflows/deployment.yml).  
    Then in your README you can link to the latest release using a URL such as https://github.com/:username/:reponame/releases/latest

* As part of the CI done for every commit, via [actions/upload-artifact](https://github.com/actions/upload-artifact).  
    Then consider linking to the latest "nightly" build using the external service https://nightly.link/

Distributing executables for macOS ([search for examples](https://github.com/search?q=%22macos-latest%22+%22shards+build%22+%22--release%22+dylib+path%3A.github%2Fworkflows&type=Code)) and Windows ([search for examples](https://github.com/search?l=YAML&q=%22windows-latest%22+%22shards+build%22+%22--release%22+path%3A.github%2Fworkflows&type=Code)) is also possible.

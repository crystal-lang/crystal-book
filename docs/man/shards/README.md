# The shards command

Crystal is typically accompanied by Shards, its dependency manager.

It manages dependencies for Crystal projects and libraries with reproducible
installs across computers and systems.

## Installation

Shards is usually distributed with Crystal itself. Alternatively, a separate `shards` package may be available for your system.

To install from source, download or clone [the repository](https://github.com/crystal-lang/shards) and run `make CRFLAGS=--release`. The compiled binary is in `bin/shards` and should be added to `PATH`.

## Usage

`shards` requires the presence of a `shard.yml` file in the project folder (working directory). This file describes the project and lists dependencies that are required to build it.
A default file can be created by running [`shards init`](#shards-install).
The file's contents are explained in the [*Writing a Shard* guide](../../guides/writing_shards.md) and a detailed description of the file format is provided by the [shard.yml specification](https://github.com/crystal-lang/shards/blob/master/docs/shard.yml.adoc).

Running [`shards install`](#shards-install) resolves and installs the specified dependencies.
The installed versions are written into a `shard.lock` file for using the exact same dependency versions when running `shards install` again.

If your shard builds an application, both `shard.yml` and `shard.lock` should be checked into version control to provide reproducible dependency installs.
If it is only a library for other shards to depend on, `shard.lock` should *not* be checked in, only `shard.yml`. It's good advice to add it to `.gitignore` (the [`crystal init`](../crystal/README.md#crystal-init) does this automatically when initializing a `lib` repository).

## Shards commands

```bash
shards [<options>...] [<command>]
```

If no command is given, `install` will be run by default.

* [`shards build`](#shards-build): Builds an executable
* [`shards check`](#shards-check): Verifies dependencies are installed
* [`shards init`](#shards-init): Generates a new `shard.yml`
* [`shards install`](#shards-install): Resolves and installs dependencies
* [`shards list`](#shards-list): Lists installed dependencies
* [`shards prune`](#shards-prune): Removes unused dependencies
* [`shards update`](#shards-update): Resolves and updates dependencies
* [`shards version`](#shards-version): Shows version of a shard

To see the available options for a particular command, use `--help` after a command.

**Common options:**

* `--version`: Prints the version of `shards`.
* `-h, --help`: Prints usage synopsis.
* `--no-color`: Disabled colored output.
* `--production`: Runs in release mode. Development dependencies won't be installed and only locked dependencies will be installed. Commands will fail if dependencies in `shard.yml` and `shard.lock` are out of sync (used by `install`, `update`, `check` and `list` command)
* `-q, --quiet`: Decreases the log verbosity, printing only warnings and errors.
* `-v, --verbose`: Increases the log verbosity, printing all debug statements.

### `shards build`

```bash
shards build [<targets>] [<options>...]
```

Builds the specified targets in `bin` path. If no targets are specified, all are built.
This command ensures all dependencies are installed, so it is not necessary to run `shards install` before.

All options following the command are delegated to `crystal build`.

### `shards check`

```bash
shards check
```

Verifies that all dependencies are installed and requirements are satisfied.

Exit status:

* `0`: Dependencies are satisfied.
* `1`: Dependencies are not satisfied.

### `shards init`

```bash
shards init
```

Initializes a shard folder and creates a `shard.yml`.

### `shards install`

```bash
shards install
```

Resolves and installs dependencies into the `lib` folder. If not already present, generates a `shard.lock` file from resolved dependencies, locking version
numbers or Git commits.

Reads and enforces locked versions and commits if a `shard.lock` file is present. The install command may fail if a locked version doesn't match a requirement, but may succeed if a new dependency was added, as long as it doesn't generate a conflict, thus generating a new `shard.lock` file.

### `shards list`

```bash
shards list
```

Lists the installed dependencies and their versions.

### `shards prune`

```bash
shards prune
```

Removes unused dependencies from lib folder.

### `shards update`

```bash
shards update
```

Resolves and updates all dependencies into the lib folder again, whatever the locked versions and commits in the `shard.lock` file. Eventually generates a
new `shard.lock` file.

### `shards version`

```bash
shards version [<path>]
```

Prints the version of the shard.

## Fixing Dependency Version Conflicts

A `shard.override.yml` file allows overriding the source and restriction of dependencies. An alternative location can be configured with the env var `SHARDS_OVERRIDE`.

The file contains a YAML document with a single `dependencies` key. It has the same semantics as in `shard.yml`. Dependency configuration takes precedence over the configuration in `shard.yml` or any dependency’s `shard.yml`.

Use cases are local working copies, forcing a specific dependency version despite mismatching constraints, fixing a dependency, checking compatibility with unreleased dependency versions.

Example file contents

```yaml
dependencies:
  # Assuming we have a conflict with the version of the Redis shard
  # This will override any specified version and use the `master` branch instead
  redis:
    github: jgaskins/redis
    branch: master
```

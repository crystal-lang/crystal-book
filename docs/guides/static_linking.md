# Static Linking

Crystal supports static linking, i.e. it can link a binary with static libraries so that these libraries don't need to be available as runtime dependencies.

Static linking can be enabled using the `--static` compiler flag. See [the usage instructions](../using_the_compiler/README.md#creating-a-statically-linked-executable) in the language reference.

When `--static` is given, linking static libraries is enabled, but it's not exclusive. The produced binary won't be fully static linked if the dynamic version of a library is higher in the compiler's library lookup chain than the static variant (or if the static library is entirely missing). In order to build a static binary you need to make sure that static versions of the linked libraries are available and the compiler can find them.

The compiler uses the `CRYSTAL_LIBRARY_PATH` environment variable as a first lookup destination for static and dynamic libraries that are to be linked. This can be used to provide static versions of libraries that are also available as dynamic libraries.

Not all libraries work well with being statically linked, so there may be some issues. `openssl` for example is known for complications, as well as `glibc` (see [Fully Static Linking](#fully-static-linking)).

Some package managers provide specific packages for static libraries, where `foo` provides the dynamic library and `foo-static` for example provides the static library. Sometimes static libraries are also included in development packages.

## Fully Static Linking

A fully statically linked program has no dynamic library dependencies at all. Prominent examples of fully statically linked Crystal programs are the `crystal` and `shards` binaries from the official distribution packages.

In order to link a program fully statically, all dependencies need to be available as static libraries at compiler time. This can be tricky sometimes, especially with common `libc` libraries.

### Linux

#### `glibc`

`glibc` is the most common `libc` implementation on Linux systems. Unfortunately, it doesn't play nicely with static linking and it's highly discouraged.

Instead, static linking against [`musl-libc`](#musl-libc) is the recommended option on Linux. Since it's statically linked, a binary linked against `musl-libc` will also run on a glibc system. That's the entire point of it.

#### `musl-libc`

[`musl-libc`](https://musl.libc.org/) is a clean, efficient `libc` implementation with excellent static linking support.

The recommended way to build a statically linked Crystal program is [Alpine Linux](https://alpinelinux.org/), a minimal Linux distribution based on `musl-libc`.

Official [Docker Images based on Alpine Linux](https://crystal-lang.org/2020/02/02/alpine-based-docker-images.html) are available on Docker Hub at [`crystallang/crystal`](https://hub.docker.com/r/crystallang/crystal/). The latest release is tagged as `crystallang/crystal:latest-alpine`. The Dockerfile source is available at [crystal-lang/distribution-scripts](https://github.com/crystal-lang/distribution-scripts/blob/master/docker/alpine.Dockerfile).

With pre-installed `crystal` compiler, `shards`, and static libraries of all of stdlib's dependencies these Docker images allow to easily build static Crystal binaries even from `glibc`-based systems. The official Crystal compiler builds for Linux are created using these images.

Here's an example how the Docker image can be used to build a statically linked *Hello World* program:

```console
$ echo 'puts "Hello World!"' > hello-world.cr
$ docker run --rm -it -v $(pwd):/workspace -w /workspace crystallang/crystal:latest-alpine \
    crystal build hello-world.cr --static
$ ./hello-world
Hello World!
$ ldd hello-world
        statically linked
```

Alpine’s package manager APK is also easy to work with to install static libraries. Available packages can be found at [pkgs.alpinelinux.org](https://pkgs.alpinelinux.org/packages).

### macOS

macOS doesn't [officially support fully static linking](https://developer.apple.com/library/content/qa/qa1118/_index.html) because the required system libraries are not available as static libraries.

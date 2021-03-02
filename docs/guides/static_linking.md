Crystal supports static linking, i.e. it can build a binary that doesn't have any runtime dependencies.
A prominent example of statically linked Crystal programs are the `crystal` and `shards` binaries from the official distribution packages.

Static linking can be enabled using the `--static` compiler flag. See [the usage instructions](https://crystal-lang.org/reference/using_the_compiler/#creating-a-statically-linked-executable) in the language reference.

When `--static` is given, linking static libraries is enabled, but it's not exclusive. The produced binary won't be fully static linked if the dynamic version of a library is higher in the compiler's library lookup chain than the static variant (or if the static library is entirely missing). In order to build a static binary you need to make sure that static versions of the linked libraries are available and the compiler can find them.

The compiler uses the `CRYSTAL_LIBRARY_PATH` environment variable as a first lookup destination for static and dynamic libraries that are to be linked. This can be used to provide static versions of libraries that are also available as dynamic libraries.

NOTE: `glibc`, the most common libc implementation on Linux systems doesn't play nicely with static linking. Thus, currently static linking is only supported with [`musl-libc`](https://www.musl-libc.org/), a libc implementation intended for static linking. The recommended way to build a statically linked binary on Linux is to compile on [Alpine Linux](https://alpinelinux.org/) for a `linux-musl` target.

macOS doesn't [officially support static linking](https://developer.apple.com/library/content/qa/qa1118/_index.html) because the required system libraries are not available as static libraries.

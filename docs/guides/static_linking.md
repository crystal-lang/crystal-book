# Static Linking

Crystal supports static linking, i.e. it can link a binary with static libraries so that these libraries don't need to be available as runtime dependencies. This improves portability at the cost of larger binaries.

Static linking can be enabled using the `--static` compiler flag. See [the usage instructions](../man/crystal/README.md#creating-a-statically-linked-executable) in the language reference.

When `--static` is given, linking static libraries is enabled, but it's not exclusive. The produced binary won't be fully static linked if the dynamic version of a library is higher in the compiler's library lookup chain than the static variant (or if the static library is entirely missing). In order to build a static binary you need to make sure that static versions of the linked libraries are available and the compiler can find them.

The compiler uses the `CRYSTAL_LIBRARY_PATH` environment variable as a first lookup destination for static and dynamic libraries that are to be linked. This can be used to provide static versions of libraries that are also available as dynamic libraries.

Not all libraries work well with being statically linked, so there may be some issues. `openssl` for example is known for complications, as well as `glibc` (see [Fully Static Linking](#fully-static-linking)).

Some package managers provide specific packages for static libraries, where `foo` provides the dynamic library and `foo-static` for example provides the static library. Sometimes static libraries are also included in development packages.

## Fully Static Linking

A fully statically linked program has no dynamic library dependencies at all. This is useful for delivering portable, pre-compiled binaries. Prominent examples of fully statically linked Crystal programs are the `crystal` and `shards` binaries from the official distribution packages.

In order to link a program fully statically, all dependencies need to be available as static libraries at compile time. This can be tricky sometimes, especially with common `libc` libraries.

### Linux

#### `glibc`

`glibc` is the most common `libc` implementation on Linux systems. Unfortunately, it doesn't play nicely with static linking and it's highly discouraged.

Instead, static linking against [`musl-libc`](#musl-libc) is the recommended option on Linux. Since it's statically linked, a binary linked against `musl-libc` will also run on a glibc system. That's the entire point of it.

It is however completely fine to statically link other libraries besides a dynamically linked `glibc`.

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

### Windows

#### MSVC

Windows doesn't support fully static linking because the Win32 libraries are not available as static libraries.

Currently, static linking is the default mode of linking on Windows, and dynamic linking can be opted in via the `-Dpreview_dll` compile-time flag. In order to distinguish static libraries from DLL import libraries, when the compiler searches for a library `foo.lib` in a given directory, `foo-static.lib` will be attempted first while linking statically, and `foo-dynamic.lib` will be attempted first while linking dynamically. The official Windows packages are distributed with both static and DLL import libraries for all third-party dependencies, except for LLVM.

Static linking implies using the static version of Microsoft's C runtime library (`/MT`), and dynamic linking implies the dynamic version (`/MD`); extra C libraries should be built with this in mind to avoid linker warnings about mixing CRT versions. There is currently no way to use the dynamic CRT while linking statically.

#### MinGW-w64

MinGW-w64 provides import libraries for the Win32 APIs and the C runtimes; therefore, unlike the MSVC toolchain, all libraries link against the C runtime dynamically, even for static builds.

The default C runtime depends on MinGW-w64's build-time configuration, and this default is always called `libmsvcrt.a`. On an MSYS2 UCRT64 environment, this is a copy of `libucrt.a`, the Universal C Runtime, whereas on a MINGW64 environment, this is a copy of `libmsvcrt-os.a` instead, the old system MSVCRT runtime. This can be overridden using `--link-flags=-mcrtdll=ucrt` or `--link-flags=-mcrtdll=msvcrt-os`, provided the MinGW-w64 installation understands it.

## Identifying Static Dependencies

If you want to statically link dependencies, you need to have their static libraries available.
Most systems don't install static libraries by default, so you need to install them explicitly.
First you have to know which libraries your program links against.

NOTE:
Static libraries have the file extension `.a` on POSIX (including MinGW-w64) and `.lib` on Windows MSVC. DLL import libraries on Windows have the `.dll.a` extension for MinGW-w64 and `.lib` for MSVC.
Dynamic libraries have `.so` on Linux and most other POSIX platforms, `.dylib` on macOS and `.dll` on Windows.

On most POSIX systems the tool `ldd` shows which dynamic libraries an executable links to. The equivalent
on macOS is `otool -L` and the equivalent on Windows is `dumpbin /dependents`.

The following example shows the output of `ldd` for a simple *Hello World* program built with Crystal 0.36.1 and LLVM 10.0 on Ubuntu 18.04 LTS (in the `crystallang/crystal:0.36.1` docker image). The result varies on other systems and versions.

```console
$ ldd hello-world_glibc
    linux-vdso.so.1 (0x00007ffeaf990000)
    libpcre.so.3 => /lib/x86_64-linux-gnu/libpcre.so.3 (0x00007fc393624000)
    libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007fc393286000)
    libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007fc393067000)
    libevent-2.1.so.6 => /usr/lib/x86_64-linux-gnu/libevent-2.1.so.6 (0x00007fc392e16000)
    libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007fc392c12000)
    libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007fc3929fa000)
    libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fc392609000)
    /lib64/ld-linux-x86-64.so.2 (0x00007fc393dde000)
```

These libraries are the minimal dependencies of Crystal's standard library.
Even an empty program requires these libraries for setting up the Crystal runtime.

This looks like a lot, but most of these libraries are actually part of the libc distribution.

On Alpine Linux the list is much smaller because musl includes more symbols directly into a
single binary. The following example shows the output of the same program built with Crystal 0.36.1 and LLVM 10.0 on Alpine Linux 3.12 (in the `crystallang/crystal:0.36.1-alpine` docker image).

```console
$ ldd hello-world_musl
    /lib/ld-musl-x86_64.so.1 (0x7fe14b05b000)
    libpcre.so.1 => /usr/lib/libpcre.so.1 (0x7fe14af1d000)
    libgc.so.1 => /usr/lib/libgc.so.1 (0x7fe14aead000)
    libgcc_s.so.1 => /usr/lib/libgcc_s.so.1 (0x7fe14ae99000)
    libc.musl-x86_64.so.1 => /lib/ld-musl-x86_64.so.1 (0x7fe14b05b000)
```

The individual libraries are `libpcre`, `libgc` and the rest is `musl` (`libc`). The same libraries are used in the Ubuntu example.

In order to link this program statically, we need static versions of these three libraries.

NOTE:
The `*-alpine` docker images ship with static versions of all libraries used by the standard library.
If your program links no other libraries then adding the `--static` flag to the build command is all you need to link fully statically.

## Dynamic library lookup

The lookup paths of dynamic libraries at runtime can be controlled by the `CRYSTAL_LIBRARY_RPATH` environment variable during compilation. Currently this is supported on Linux and Windows.

### Linux

If `CRYSTAL_LIBRARY_RPATH` is defined during compilation, it is passed unmodified to the linker via an `-Wl,rpath` option. The exact behavior depends on the linker; usually, this is appended to the ELF executable's `DT_RUNPATH` or `DT_RPATH` dynamic tag entry. The special `$ORIGIN` / `$LIB` / `$PLATFORM` variables might not be supported on all platforms.

### Windows

The standard library supports experimental [DLL delay loading](https://learn.microsoft.com/en-us/cpp/build/reference/linker-support-for-delay-loaded-dlls), and may alter the search order of DLLs by using delay loading.

If a `/DELAYLOAD` linker flag is passed for a given DLL, then the first time an executable loads a symbol from that DLL, it will attempt the semicolon-separated paths in the executable's `CRYSTAL_LIBRARY_RPATH` first, in the order they are declared, before the [default lookup order](https://learn.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-search-order#search-order-for-unpackaged-apps). `$ORIGIN` inside `CRYSTAL_LIBRARY_RPATH` expands into the path of the running executable itself. For example, if `CRYSTAL_LIBRARY_RPATH=$ORIGIN\mylibs;C:\bar` during compilation, `--link-flags=/DELAYLOAD:calc.dll` is supplied, and the executable is located at `C:\foo\test.exe`, then the executable searches for `C:\foo\mylibs\calc.dll`, then `C:\bar\calc.dll`, and uses the default order afterwards.

Non-delay-loaded DLLs are loaded immediately upon program startup, and do not respect `CRYSTAL_LIBRARY_RPATH`.

By default, no DLLs are delay-loaded. However, if the `-Dpreview_win32_delay_load` compile-time flag is specified at compilation time, the compiler will detect all DLL dependencies from their import libraries, inserting a `/DELAYLOAD` linker flag per DLL during compilation.

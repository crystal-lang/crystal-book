# Required libraries

This is a list of third-party libraries used by the Crystal compiler and the standard library.

## Core runtime dependencies

The libraries in this section are always required by Crystal's stdlib runtime. They must be present for building or running any Crystal program that uses the standard library.
Avoiding these dependencies is only possible when not using the standard library (`--prelude=none` compiler option).

### System library

A major component is the system library. Selection depends on the target platform and multiple are supported.
This usually includes the C standard library as well as additional system libraries such as `libdl`, `libm`, `libpthread`, `libcmt`, or `libiconv`
which may be part of the C library or standalone libraries. On most platforms all these libraries are provided by the operating system.

| Library | Description | License |
|---------|-------------|---------|
| [glibc][glibc] | standard C library for Linux | [LGPL](https://www.gnu.org/licenses/lgpl-3.0.en.html) |
| [musl libc][musl-libc] | standard C library for Linux | [MIT](https://git.musl-libc.org/cgit/musl/tree/COPYRIGHT) |
| [FreeBSD libc][freebsd-libc] | standard C library for FreeBSD | [BSD](https://www.freebsd.org/copyright/freebsd-license/) |
| [NetBSD libc][netbsd-libc] | standard C library for NetBSD | [BSD](http://www.netbsd.org/about/redistribution.html) |
| [OpenBSD libc][openbsd-libc] | standard C library for OpenBSD | [BSD](https://www.openbsd.org/policy.html) |
| [Dragonfly libc][dragonfly-libc] | standard C library for DragonflyBSD | [BSD](https://www.dragonflybsd.org/docs/developer/DragonFly_BSD_License/) |
| [macOS libsystem][macos-libsystem] | standard C library for macOS | [Apple](https://github.com/apple-oss-distributions/Libsystem/blob/main/APPLE_LICENSE) |
| [MSVCRT][msvcrt] | standard C library for MSVC compiler (Windows) | |
| [WASI][wasi] | WebAssembly System Interface | [Apache v2 and others](https://github.com/WebAssembly/wasi-libc/blob/main/LICENSE) |
| [bionic libc][bionic-libc] | C library for Android | [BSD-like](https://android.googlesource.com/platform/bionic/+/refs/heads/master/libc/NOTICE) |

### Other runtime libraries

| Library | Description | License |
|---------|-------------|---------|
| [Boehm GC][libgc] | The Boehm-Demers-Weiser conservative garbage collector. Performs automatic memory management. | [MIT-style](https://github.com/ivmai/bdwgc/blob/master/LICENSE)
| [Libevent][libevent] | An event notification library. Implements concurrency features such as [`Fiber`](https://crystal-lang.org/api/Fiber.html) and the event loop on POSIX platforms. Not used on Windows. | [Modified BSD](https://github.com/libevent/libevent/blob/master/LICENSE)
| [compiler-rt builtins][compiler-rt] | Provides optimized implementations for low-level routines required by code generation, such as integer multiplication. Several of these routines are ported to Crystal directly. | [MIT / UIUC][compiler-rt]

## Optional standard library dependencies

These libraries are required by different parts of the standard library, only when explicitly used.

### Regular Exception engine

Engine implementation for the [`Regex`](https://crystal-lang.org/api/Regex.html) class.
PCRE2 support was added in Crystal 1.7 and it's the default since 1.8 (see [Regex documentation](../syntax_and_semantics/literals/regex.md)).

| Library | Description | License |
|---------|-------------|---------|
| [PCRE2][libpcre] | Perl Compatible Regular Expressions, version 2. | [BSD](http://www.pcre.org/licence.txt)
| [PCRE][libpcre] | Perl Compatible Regular Expressions. | [BSD](http://www.pcre.org/licence.txt)

### Big Numbers

Implementations for `Big` types such as [`BigInt`](https://crystal-lang.org/api/BigInt.html).

| Library | Description | License |
|---------|-------------|---------|
| [GMP][libgmp] | GNU multiple precision arithmetic library. | [LGPL v3+ / GPL v2+](https://gmplib.org/manual/Copying)
| [MPIR][libmpir] | Multiple Precision Integers and Rationals, forked from GMP. Used on Windows. | [GPL-3.0](https://github.com/wbhart/mpir/blob/master/COPYING) and [LGPL-3.0](https://github.com/wbhart/mpir/blob/master/COPYING.LIB) |

### Internationalization conversion

This is either a standalone library or may be provided as part of the system library on some platforms. May be disabled with the `-Dwithout_iconv` compile-time flag.
Using a standalone library over the system library implementation can be enforced with the `-Duse_libiconv` compile-time flag.

| Library | Description | License |
|---------|-------------|---------|
| [libiconv][libiconv-gnu] (GNU) | Internationalization conversion library. | [LGPL-3.0](https://www.gnu.org/licenses/lgpl.html)

### TLS

TLS protocol implementation and general-purpose cryptographic routines for the [`OpenSSL`](https://crystal-lang.org/api/OpenSSL.html) API. May be disabled with the `-Dwithout_openssl` [compile-time flag](../syntax_and_semantics/compile_time_flags.md#compiler-features).

Both `OpenSSL` and `LibreSSL` are supported and the bindigns automaticall detect which library and API version is available on the host system.

| Library | Description | License |
|---------|-------------|---------|
| [OpenSSL][openssl] | Implementation of the SSL and TLS protocols | [Apache v2 (3.0+), OpenSSL / SSLeay (1.x)](https://www.openssl.org/source/license.html)
| [LibreSSL][libressl] | Implementation of the SSL and TLS protocols; forked from OpenSSL in 2014  | [ISC / OpenSSL / SSLeay](https://github.com/libressl-portable/openbsd/blob/master/src/lib/libssl/LICENSE)

### Other stdlib libraries

| Library | Description | License |
|---------|-------------|---------|
| [LibXML2][libxml2] | XML parser developed for the Gnome project. Implements the [`XML`](https://crystal-lang.org/api/XML.html) module. | [MIT](https://gitlab.gnome.org/GNOME/libxml2/-/blob/master/Copyright)
| [LibYAML][libyaml] | YAML parser and emitter library. Implements the [`YAML`](https://crystal-lang.org/api/YAML.html) module. | [MIT](https://github.com/yaml/libyaml/blob/master/License)
| [zlib][zlib] | Lossless data compression library. Implements the [`Compress`](https://crystal-lang.org/api/Compress.html) module. May be disabled with the `-Dwithout_zlib` compile-time flag. | [zlib](http://zlib.net/zlib_license.html)
| [LLVM][libllvm] | Target-independent code generator and optimizer. Implements the [`LLVM`](https://crystal-lang.org/api/LLVM.html) API. | [Apache v2 with LLVM exceptions](https://llvm.org/docs/DeveloperPolicy.html#new-llvm-project-license-framework)

## Compiler dependencies

In addition to the [core runtime dependencies](#core-runtime-dependencies), these libraries are needed to build the Crystal compiler.

| Library | Description | License |
|---------|-------------|---------|
| [PCRE2][libpcre] | See above. | |
| [LLVM][libllvm] | See above. | [Apache v2 with LLVM exceptions](https://llvm.org/docs/DeveloperPolicy.html#new-llvm-project-license-framework)
| [libffi][libffi] | Foreign function interface. Used for implementing binary interfaces in the interpreter. May be disabled with the `-Dwithout_interpreter` compile-time flag. | [MIT](https://github.com/libffi/libffi/blob/master/LICENSE)

[bionic-libc]: https://android.googlesource.com/platform/bionic/+/refs/heads/master/libc/
[compiler-rt]: https://compiler-rt.llvm.org/
[dragonfly-libc]: http://gitweb.dragonflybsd.org/dragonfly.git/tree/refs/heads/master:/lib/libc
[freebsd-libc]: https://svn.freebsd.org/base/head/lib/libc/
[glibc]: https://www.gnu.org/software/libc/
[libevent]: https://libevent.org/
[libffi]: https://sourceware.org/libffi/
[libgc]: https://github.com/ivmai/bdwgc
[libgmp]: https://gmplib.org/
[libiconv-gnu]: https://www.gnu.org/software/libiconv/
[libllvm]: https://llvm.org/
[libmpir]: https://github.com/wbhart/mpir
[libpcre]: http://www.pcre.org/
[libressl]: https://www.libressl.org/
[libxml2]: http://xmlsoft.org/
[libyaml]: https://pyyaml.org/wiki/LibYAML
[macos-libsystem]: https://github.com/apple-oss-distributions/Libsystem
[msvcrt]: https://learn.microsoft.com/en-us/cpp/c-runtime-library/crt-library-features?view=msvc-170
[musl-libc]: https://musl.libc.org/
[netbsd-libc]: http://cvsweb.netbsd.org/bsdweb.cgi/src/lib/libc/?only_with_tag=MAIN
[openbsd-libc]: http://cvsweb.openbsd.org/cgi-bin/cvsweb/src/lib/libc/
[openssl]: https://www.openssl.org/
[wasi]: https://wasi.dev/
[zlib]: http://zlib.net/

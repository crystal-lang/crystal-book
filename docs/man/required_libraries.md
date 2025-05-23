# Required libraries

This is a list of third-party libraries used by the Crystal compiler and the standard library.

## Core runtime dependencies

The libraries in this section are always required by Crystal's stdlib runtime. They must be present for building or running any Crystal program that uses the standard library.
Avoiding these dependencies is only possible when not using the standard library (`--prelude=empty` compiler option).

### System library

A major component is the system library. Selection depends on the target platform and multiple are supported.
This usually includes the C standard library as well as additional system libraries such as `libdl`, `libm`, `libpthread`, `libcmt`, or `libiconv`
which may be part of the C library or standalone libraries. On most platforms all these libraries are provided by the operating system.

| Library | Description | License |
|---------|-------------|---------|
| [glibc][glibc]<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/glibc.svg?header=latest)](https://repology.org/project/glibc/versions) | standard C library for Linux <br>**Supported versions:** GNU libc 2.26+ | [LGPL](https://www.gnu.org/licenses/lgpl-3.0.en.html) |
| [musl libc][musl-libc]<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/musl.svg?header=latest)](https://repology.org/project/musl/versions) | standard C library for Linux <br>**Supported versions:** MUSL libc 1.2+ | [MIT](https://git.musl-libc.org/cgit/musl/tree/COPYRIGHT) |
| [FreeBSD libc][freebsd-libc]<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/freebsd.svg?header=latest)](https://repology.org/project/freebsd/versions) | standard C library for FreeBSD <br>**Supported versions:** 12+ | [BSD](https://www.freebsd.org/copyright/freebsd-license/) |
| [NetBSD libc][netbsd-libc] | standard C library for NetBSD | [BSD](http://www.netbsd.org/about/redistribution.html) |
| [OpenBSD libc][openbsd-libc]<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/openbsd.svg?header=latest)](https://repology.org/project/openbsd/versions) | standard C library for OpenBSD <br>**Supported versions:** 6+ | [BSD](https://www.openbsd.org/policy.html) |
| [Dragonfly libc][dragonfly-libc] | standard C library for DragonflyBSD | [BSD](https://www.dragonflybsd.org/docs/developer/DragonFly_BSD_License/) |
| [macOS libsystem][macos-libsystem] | standard C library for macOS <br>**Supported versions:** 11+ | [Apple](https://github.com/apple-oss-distributions/Libsystem/blob/main/APPLE_LICENSE) |
| [MSVCRT][msvcrt] | standard C library for Visual Studio 2013 or below | |
| [UCRT][ucrt] | Universal CRT for Windows / Visual Studio 2015+ | [MIT subset available](https://www.nuget.org/packages/Microsoft.Windows.SDK.CRTSource/10.0.22621.3/License) |
| [WASI][wasi]<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/wasi-libc.svg?header=latest)](https://repology.org/project/wasi-libc/versions) | WebAssembly System Interface | [Apache v2 and others](https://github.com/WebAssembly/wasi-libc/blob/main/LICENSE) |
| [bionic libc][bionic-libc] | C library for Android <br>**Supported versions:** ABI Level 24+ | [BSD-like](https://android.googlesource.com/platform/bionic/+/refs/heads/master/libc/NOTICE) |

### Other runtime libraries

| Library | Description | License |
|---------|-------------|---------|
| [Boehm GC][libgc]<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/boehm-gc.svg?header=latest)](https://repology.org/project/boehm-gc/versions) | The Boehm-Demers-Weiser conservative garbage collector. Performs automatic memory management.<br>**Supported versions:** 8.2.0+; earlier versions require a patch for MT support | [MIT-style](https://github.com/ivmai/bdwgc/blob/master/LICENSE) |
| [Libevent][libevent]<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/llvm.svg?header=latest)](https://repology.org/project/llvm/versions) | An event notification library. Implements the event loop on OpenBSD, NetBSD, DragonflyBSD and Solaris by default and on other Unix-like systems with `-Devloop=libevent` ([availability](https://github.com/crystal-lang/rfcs/blob/main/text/0009-lifetime-event_loop.md#availability)). Never used on Windows or WASI. | [Modified BSD](https://github.com/libevent/libevent/blob/master/LICENSE) |
| [compiler-rt builtins][compiler-rt] | Provides optimized implementations for low-level routines required by code generation, such as integer multiplication. Several of these routines are ported to Crystal directly. | [MIT / UIUC][compiler-rt] |

## Optional standard library dependencies

These libraries are required by different parts of the standard library, only when explicitly used.

### Regular Expression engine

Engine implementation for the [`Regex`](https://crystal-lang.org/api/Regex.html) class.
PCRE2 support was added in Crystal 1.7 and it's the default since 1.8 (see [Regex documentation](../syntax_and_semantics/literals/regex.md)).

| Library | Description | License |
|---------|-------------|---------|
| [PCRE2][libpcre]<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/pcre2.svg?header=latest)](https://repology.org/project/pcre2/versions) | Perl Compatible Regular Expressions, version 2.<br>**Supported versions:** all (recommended: 10.36+) | [BSD](http://www.pcre.org/licence.txt) |
| [PCRE][libpcre]<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/pcre.svg?header=latest)](https://repology.org/project/pcre/versions) | Perl Compatible Regular Expressions. | [BSD](http://www.pcre.org/licence.txt) |

### Big Numbers

Implementations for `Big` types such as [`BigInt`](https://crystal-lang.org/api/BigInt.html).

| Library | Description | License |
|---------|-------------|---------|
| [GMP][libgmp]<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/gmp.svg?header=latest)](https://repology.org/project/gmp/versions) | GNU multiple precision arithmetic library. | [LGPL v3+ / GPL v2+](https://gmplib.org/manual/Copying) |
| [MPIR][libmpir]<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/mpir.svg?header=latest)](https://repology.org/project/mpir/versions) | Multiple Precision Integers and Rationals, forked from GMP. Used on Windows MSVC. | [GPL-3.0](https://github.com/wbhart/mpir/blob/master/COPYING) and [LGPL-3.0](https://github.com/wbhart/mpir/blob/master/COPYING.LIB) |

### Internationalization conversion

This is either a standalone library or may be provided as part of the system library on some platforms. May be disabled with the `-Dwithout_iconv` compile-time flag.
Using a standalone library over the system library implementation can be enforced with the `-Duse_libiconv` compile-time flag.

| Library | Description | License |
|---------|-------------|---------|
| [libiconv][libiconv-gnu] (GNU)<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/libiconv.svg?header=latest)](https://repology.org/project/libiconv/versions) | Internationalization conversion library. | [LGPL-3.0](https://www.gnu.org/licenses/lgpl.html) |

### TLS

TLS protocol implementation and general-purpose cryptographic routines for the [`OpenSSL`](https://crystal-lang.org/api/OpenSSL.html) API. May be disabled with the `-Dwithout_openssl` [compile-time flag](../syntax_and_semantics/compile_time_flags.md#stdlib-features).

Both `OpenSSL` and `LibreSSL` are supported and the bindings automatically detect which library and API version is available on the host system.

| Library | Description | License |
|---------|-------------|---------|
| [OpenSSL][openssl]<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/openssl.svg?header=latest)](https://repology.org/project/openssl/versions) | Implementation of the SSL and TLS protocols <br>**Supported versions:** 1.1.0+–3.4+ | [Apache v2 (3.0+), OpenSSL / SSLeay (1.x)](https://www.openssl.org/source/license.html) |
| [LibreSSL][libressl]<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/libressl.svg?header=latest)](https://repology.org/project/libressl/versions) | Implementation of the SSL and TLS protocols; forked from OpenSSL in 2014 <br>**Supported versions:** 2.0–4.0+ | [ISC / OpenSSL / SSLeay](https://github.com/libressl-portable/openbsd/blob/master/src/lib/libssl/LICENSE) |

### Other stdlib libraries

| Library | Description | License |
|---------|-------------|---------|
| [LibXML2][libxml2]<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/libxml2.svg?header=latest)](https://repology.org/project/libxml2/versions) | XML parser developed for the Gnome project. Implements the [`XML`](https://crystal-lang.org/api/XML.html) module.<br>⚠️ The library included in macOS has [incompatible changes][#15619] from upstream `libxml2` and is not supported. | [MIT](https://gitlab.gnome.org/GNOME/libxml2/-/blob/master/Copyright) |
| [LibYAML][libyaml]<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/libyaml.svg?header=latest)](https://repology.org/project/libyaml/versions) | YAML parser and emitter library. Implements the [`YAML`](https://crystal-lang.org/api/YAML.html) module. | [MIT](https://github.com/yaml/libyaml/blob/master/License) |
| [zlib][zlib]<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/zlib.svg?header=latest)](https://repology.org/project/zlib/versions) | Lossless data compression library. Implements the [`Compress`](https://crystal-lang.org/api/Compress.html) module. May be disabled with the `-Dwithout_zlib` compile-time flag. | [zlib](http://zlib.net/zlib_license.html) |
| [LLVM][libllvm]<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/llvm.svg?header=latest)](https://repology.org/project/llvm/versions) | Target-independent code generator and optimizer. Implements the [`LLVM`](https://crystal-lang.org/api/LLVM.html) API. <br>**Supported versions:** LLVM 8-20 (aarch64 requires LLVM 13+) | [Apache v2 with LLVM exceptions](https://llvm.org/docs/DeveloperPolicy.html#new-llvm-project-license-framework) |

[#15619]: https://github.com/crystal-lang/crystal/issues/15619

## Compiler dependencies

In addition to the [core runtime dependencies](#core-runtime-dependencies), these libraries are needed to build the Crystal compiler.

| Library | Description | License |
|---------|-------------|---------|
| [PCRE2][libpcre] | See above. | |
| [LLVM][libllvm] | See above. | [Apache v2 with LLVM exceptions](https://llvm.org/docs/DeveloperPolicy.html#new-llvm-project-license-framework) |
| [libffi][libffi]<br>[![latest packaged version(s)](https://repology.org/badge/latest-versions/libffi.svg?header=latest)](https://repology.org/project/libffi/versions) | Foreign function interface. Used for implementing binary interfaces in the interpreter. May be disabled with the `-Dwithout_interpreter` compile-time flag. | [MIT](https://github.com/libffi/libffi/blob/master/LICENSE) |

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
[msvcrt]: https://web.archive.org/web/20150630135610/https://msdn.microsoft.com/en-us/library/abx4dbyh.aspx
[musl-libc]: https://musl.libc.org/
[netbsd-libc]: http://cvsweb.netbsd.org/bsdweb.cgi/src/lib/libc/?only_with_tag=MAIN
[openbsd-libc]: http://cvsweb.openbsd.org/cgi-bin/cvsweb/src/lib/libc/
[openssl]: https://www.openssl.org/
[ucrt]: https://learn.microsoft.com/en-us/cpp/windows/universal-crt-deployment?view=msvc-170
[wasi]: https://wasi.dev/
[zlib]: http://zlib.net/

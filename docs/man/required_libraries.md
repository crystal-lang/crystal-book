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
| ------- | ----------- | ------- |
| [glibc]<br>[![latest packaged version(s)][repology:glibc.svg]][repology:glibc/versions] | standard C library for Linux <br>**Supported versions:** GNU libc 2.26+ | [LGPL 3.0] |
| [musl libc]<br>[![latest packaged version(s)][repology:musl.svg]][repology:musl/versions] | standard C library for Linux <br>**Supported versions:** MUSL libc 1.2+ | [MIT][musl-copyright] |
| [FreeBSD libc]<br>[![latest packaged version(s)][repology:freebsd.svg]][repology:freebsd/versions] | standard C library for FreeBSD <br>**Supported versions:** 12+ | [BSD][freebsd-license] |
| [NetBSD libc] | standard C library for NetBSD | [BSD][netbsd-license] |
| [OpenBSD libc]<br>[![latest packaged version(s)][repology:openbsd.svg]][repology:openbsd/versions] | standard C library for OpenBSD <br>**Supported versions:** 6+ | [BSD][openbsd-policy] |
| [Dragonfly libc] | standard C library for DragonflyBSD | [BSD][dragonfly-license] |
| [macOS libsystem] | standard C library for macOS <br>**Supported versions:** 11+ | [Apple][APPLE_LICENSE] |
| [MSVCRT] | standard C library for Visual Studio 2013 or below | |
| [UCRT] | Universal CRT for Windows / Visual Studio 2015+ | [MIT subset available][MIT-windows] |
| [WASI]<br>[![latest packaged version(s)][repology:wasi-libc.svg]][repology:wasi-libc/versions] | WebAssembly System Interface | [Apache v2 and others][wasi-license] |
| [bionic libc] | C library for Android <br>**Supported versions:** ABI Level 24+ | [BSD-like][android-notice] |
| [illumos libc] | System library for Illumos | [CDDL] |

[repology:glibc/versions]: https://repology.org/project/glibc/versions
[repology:glibc.svg]: https://repology.org/badge/latest-versions/glibc.svg?header=latest
[repology:musl/versions]: https://repology.org/project/musl/versions
[repology:musl.svg]: https://repology.org/badge/latest-versions/musl.svg?header=latest
[repology:freebsd/versions]: https://repology.org/project/freebsd/versions
[repology:freebsd.svg]: https://repology.org/badge/latest-versions/freebsd.svg?header=latest
[repology:openbsd/versions]: https://repology.org/project/openbsd/versions
[repology:openbsd.svg]: https://repology.org/badge/latest-versions/openbsd.svg?header=latest
[repology:wasi-libc/versions]: https://repology.org/project/wasi-libc/versions
[repology:wasi-libc.svg]: https://repology.org/badge/latest-versions/wasi-libc.svg?header=latest

[LGPL 3.0]: https://www.gnu.org/licenses/lgpl-3.0.en.html
[musl-copyright]: https://git.musl-libc.org/cgit/musl/tree/COPYRIGHT
[freebsd-license]: https://www.freebsd.org/copyright/freebsd-license/
[netbsd-license]: http://www.netbsd.org/about/redistribution.html
[openbsd-policy]: https://www.openbsd.org/policy.html
[dragonfly-license]: https://www.dragonflybsd.org/docs/developer/DragonFly_BSD_License/
[APPLE_LICENSE]: https://github.com/apple-oss-distributions/Libsystem/blob/main/APPLE_LICENSE
[MIT-windows]: https://www.nuget.org/packages/Microsoft.Windows.SDK.CRTSource/10.0.22621.3/License
[wasi-license]: https://github.com/WebAssembly/wasi-libc/blob/main/LICENSE
[android-notice]: https://android.googlesource.com/platform/bionic/+/refs/heads/master/libc/NOTICE
[CDDL]: https://illumos.org/license/CDDL

### Other runtime libraries

| Library | Description | License |
| ------- | ----------- | ------- |
| [Boehm GC]<br>[![latest packaged version(s)][repology:boehm-gc.svg]][repology:boehm-gc/versions] | The Boehm-Demers-Weiser conservative garbage collector. Performs automatic memory management.<br>**Supported versions:** 8.2.0+; earlier versions require a patch for MT support | [MIT-style][bdwgc-license] |
| [Libevent]<br>[![latest packaged version(s)][repology:llvm.svg]][repology:llvm/versions] | An event notification library. Implements the event loop on OpenBSD, NetBSD, DragonflyBSD and Solaris by default and on other Unix-like systems with `-Devloop=libevent` ([availability][RFC0009]). Never used on Windows or WASI. | [Modified BSD][libevent-license] |
| [compiler-rt builtins] | Provides optimized implementations for low-level routines required by code generation, such as integer multiplication. Several of these routines are ported to Crystal directly. | [MIT / UIUC][compiler-rt builtins] |

[repology:boehm-gc/versions]: https://repology.org/project/boehm-gc/versions
[repology:boehm-gc.svg]: https://repology.org/badge/latest-versions/boehm-gc.svg?header=latest
[repology:llvm/versions]: https://repology.org/project/llvm/versions
[repology:llvm.svg]: https://repology.org/badge/latest-versions/llvm.svg?header=latest

[bdwgc-license]: https://github.com/ivmai/bdwgc/blob/master/LICENSE
[libevent-license]: https://github.com/libevent/libevent/blob/master/LICENSE

[RFC0009]: https://github.com/crystal-lang/rfcs/blob/main/text/0009-lifetime-event_loop.md#availability

## Optional standard library dependencies

These libraries are required by different parts of the standard library, only when explicitly used.

### Regular Expression engine

Engine implementation for the [`Regex`][Regex] class.
PCRE2 support was added in Crystal 1.7 and it's the default since 1.8 (see [Regex documentation]).

[Regex]: https://crystal-lang.org/api/Regex.html
[Regex documentation]: ../syntax_and_semantics/literals/regex.md

| Library | Description | License |
| ------- | ----------- | ------- |
| [PCRE2]<br>[![latest packaged version(s)][repology:pcre2.svg]][repology:pcre2/versions] | Perl Compatible Regular Expressions, version 2.<br>**Supported versions:** all (recommended: 10.36+) | [BSD][pcre-license] |
| [PCRE][PCRE2]<br>[![latest packaged version(s)][repology:pcre.svg]][repology:pcre/versions] | Perl Compatible Regular Expressions. | [BSD][pcre-license] |

[repology:pcre2/versions]: https://repology.org/project/pcre2/versions
[repology:pcre2.svg]: https://repology.org/badge/latest-versions/pcre2.svg?header=latest
[repology:pcre/versions]: https://repology.org/project/pcre/versions
[repology:pcre.svg]: https://repology.org/badge/latest-versions/pcre.svg?header=latest

[pcre-license]: http://www.pcre.org/licence.txt

### Big Numbers

Implementations for `Big` types such as [`BigInt`][BigInt].

[BigInt]: https://crystal-lang.org/api/BigInt.html

| Library | Description | License |
| ------- | ----------- | ------- |
| [GMP]<br>[![latest packaged version(s)][repology:gmp.svg]][repology:gmp/versions] | GNU multiple precision arithmetic library. | [LGPL v3+ / GPL v2+][gmp-license] |
| [MPIR]<br>[![latest packaged version(s)][repology:mpir.svg]][repology:mpir/versions] | Multiple Precision Integers and Rationals, forked from GMP. Used on Windows MSVC. | [GPL-3.0][mpir-copying] and [LGPL-3.0][mpir-copying.lib] |

[repology:gmp/versions]: https://repology.org/project/gmp/versions
[repology:gmp.svg]: https://repology.org/badge/latest-versions/gmp.svg?header=latest
[repology:mpir/versions]: https://repology.org/project/mpir/versions
[repology:mpir.svg]: https://repology.org/badge/latest-versions/mpir.svg?header=latest

[gmp-license]: https://gmplib.org/manual/Copying
[mpir-copying]: https://github.com/wbhart/mpir/blob/master/COPYING
[mpir-copying.lib]: https://github.com/wbhart/mpir/blob/master/COPYING.LIB

### Internationalization conversion

This is either a standalone library or may be provided as part of the system library on some platforms. May be disabled with the `-Dwithout_iconv` compile-time flag.
Using a standalone library over the system library implementation can be enforced with the `-Duse_libiconv` compile-time flag.

| Library | Description | License |
| ------- | ----------- | ------- |
| [libiconv] (GNU)<br>[![latest packaged version(s)][repology:libiconv.svg]][repology:libiconv/versions] | Internationalization conversion library. | [LGPL 3.0] |

[repology:libiconv/versions]: https://repology.org/project/libiconv/versions
[repology:libiconv.svg]: https://repology.org/badge/latest-versions/libiconv.svg?header=latest

### TLS

TLS protocol implementation and general-purpose cryptographic routines for the [`OpenSSL`][OpenSSL] API. May be disabled with the `-Dwithout_openssl` [compile-time flag][stdlib-features].

Both `OpenSSL` and `LibreSSL` are supported and the bindings automatically detect which library and API version is available on the host system.

[OpenSSL]:https://crystal-lang.org/api/OpenSSL.html
[stdlib-features]: ../syntax_and_semantics/compile_time_flags.md#stdlib-features

| Library | Description | License |
| ------- | ----------- | ------- |
| [OpenSSL][openssl.org]<br>[![latest packaged version(s)][repology:openssl.svg]][repology:openssl/versions] | Implementation of the SSL and TLS protocols <br>**Supported versions:** 1.1.1+–3.4+ | [Apache v2 (3.0+), OpenSSL / SSLeay (1.x)] |
| [LibreSSL]<br>[![latest packaged version(s)][repology:libressl.svg]][repology:libressl/versions] | Implementation of the SSL and TLS protocols; forked from OpenSSL in 2014 <br>**Supported versions:** 3.0–4.0+ | [ISC / OpenSSL / SSLeay] |

[repology:openssl/versions]: https://repology.org/project/openssl/versions
[repology:openssl.svg]: https://repology.org/badge/latest-versions/openssl.svg?header=latest
[repology:libressl/versions]: https://repology.org/project/libressl/versions
[repology:libressl.svg]: https://repology.org/badge/latest-versions/libressl.svg?header=latest

[Apache v2 (3.0+), OpenSSL / SSLeay (1.x)]: https://www.openssl.org/source/license.html
[ISC / OpenSSL / SSLeay]: https://github.com/libressl-portable/openbsd/blob/master/src/lib/libssl/LICENSE

### Other stdlib libraries

| Library | Description | License |
| ------- | ----------- | ------- |
| [LibXML2]<br>[![latest packaged version(s)][repology:libxml2.svg]][repology:libxml2/versions] | XML parser developed for the Gnome project. Implements the [`XML`][XML] module.<br>**Supported versions:** LibXML2 2.9–2.14 | [MIT][gnome-license] |
| [LibYAML]<br>[![latest packaged version(s)][repology:libyaml.svg]][repology:libyaml/versions] | YAML parser and emitter library. Implements the [`YAML`][YAML] module. | [MIT][yaml-license] |
| [zlib]<br>[![latest packaged version(s)][repology:zlib.svg]][repology:zlib/versions] | Lossless data compression library. Implements the [`Compress`][Compress] module. May be disabled with the `-Dwithout_zlib` compile-time flag. | [zlib][zlib-license] |
| [LLVM][libllvm]<br>[![latest packaged version(s)][repology:llvm.svg]][repology:llvm/versions] | Target-independent code generator and optimizer. Implements the [`LLVM`][LLVM] API. <br>**Supported versions:** LLVM 8-22 (aarch64 requires LLVM 13+) | [Apache v2 with LLVM exceptions] |

[repology:libxml2/versions]: https://repology.org/project/libxml2/versions
[repology:libxml2.svg]: https://repology.org/badge/latest-versions/libxml2.svg?header=latest
[repology:libyaml/versions]: https://repology.org/project/libyaml/versions
[repology:libyaml.svg]: https://repology.org/badge/latest-versions/libyaml.svg?header=latest
[repology:zlib/versions]: https://repology.org/project/zlib/versions
[repology:zlib.svg]: https://repology.org/badge/latest-versions/zlib.svg?header=latest

[gnome-license]: https://gitlab.gnome.org/GNOME/libxml2/-/blob/master/Copyright
[yaml-license]: https://github.com/yaml/libyaml/blob/master/License
[zlib-license]: http://zlib.net/zlib_license.html
[Apache v2 with LLVM exceptions]: https://llvm.org/docs/DeveloperPolicy.html#new-llvm-project-license-framework

[XML]: https://crystal-lang.org/api/XML.html
[YAML]: https://crystal-lang.org/api/YAML.html
[Compress]: https://crystal-lang.org/api/Compress.html
[LLVM]: https://crystal-lang.org/api/LLVM.html

## Compiler dependencies

In addition to the [core runtime dependencies](#core-runtime-dependencies), these libraries are needed to build the Crystal compiler.

| Library | Description | License |
| ------- | ----------- | ------- |
| [PCRE2] | See [*Regular expression engine*] | |
| [LLVM][libllvm] | See [*Other stdlib libraries*] | [Apache v2 with LLVM exceptions] |
| [libffi]<br>[![latest packaged version(s)][repology:libffi.svg]][repology:libffi/versions] | Foreign function interface. Used for implementing binary interfaces in the interpreter. May be disabled with the `-Dwithout_interpreter` compile-time flag. | [MIT][ffi-license] |
| [libxml2] | Optional dependency for docs sanitizer. May be disabled with the `-Dwithout_libxml2` compile-time flag. See [*Other stdlib libraries*] | [MIT][gnome-license] |

[*Other stdlib libraries*]: #other-stdlib-libraries
[*Regular expression engine*]: #regular-expression-engine

[repology:libffi/versions]: https://repology.org/project/libffi/versions
[repology:libffi.svg]: https://repology.org/badge/latest-versions/libffi.svg?header=latest

[ffi-license]: https://github.com/libffi/libffi/blob/master/LICENSE

[bionic libc]: https://android.googlesource.com/platform/bionic/+/refs/heads/master/libc/
[compiler-rt builtins]: https://compiler-rt.llvm.org/
[Dragonfly libc]: http://gitweb.dragonflybsd.org/dragonfly.git/tree/refs/heads/master:/lib/libc
[FreeBSD libc]: https://svn.freebsd.org/base/head/lib/libc/
[glibc]: https://www.gnu.org/software/libc/
[illumos libc]: https://code.illumos.org/plugins/gitiles/illumos-gate
[Libevent]: https://libevent.org/
[libffi]: https://sourceware.org/libffi/
[Boehm GC]: https://github.com/ivmai/bdwgc
[GMP]: https://gmplib.org/
[libiconv]: https://www.gnu.org/software/libiconv/
[libllvm]: https://llvm.org/
[MPIR]: https://github.com/wbhart/mpir
[PCRE2]: http://www.pcre.org/
[LibreSSL]: https://www.libressl.org/
[LibXML2]: http://xmlsoft.org/
[LibYAML]: https://pyyaml.org/wiki/LibYAML
[macOS libsystem]: https://github.com/apple-oss-distributions/Libsystem
[MSVCRT]: https://web.archive.org/web/20150630135610/https://msdn.microsoft.com/en-us/library/abx4dbyh.aspx
[musl libc]: https://musl.libc.org/
[NetBSD libc]: http://cvsweb.netbsd.org/bsdweb.cgi/src/lib/libc/?only_with_tag=MAIN
[OpenBSD libc]: http://cvsweb.openbsd.org/cgi-bin/cvsweb/src/lib/libc/
[openssl.org]: https://www.openssl.org/
[UCRT]: https://learn.microsoft.com/en-us/cpp/windows/universal-crt-deployment?view=msvc-170
[WASI]: https://wasi.dev/
[zlib]: http://zlib.net/

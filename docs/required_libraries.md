# Required libraries

This is a list of known third-party libraries required by the Crystal compiler and the standard library.

## Runtime dependencies

The following libraries are required by Crystal's runtime, and must be present when building or running any program, unless the `--prelude=empty` compiler option is passed.

| Library | Description | License |
|---------|-------------|---------|
| [PCRE][libpcre] | Perl Compatible Regular Expressions. Implements [`Regex`](https://crystal-lang.org/api/Regex.html). | [BSD](http://www.pcre.org/licence.txt)
| [Boehm GC][libgc] | The Boehm-Demers-Weiser conservative garbage collector. Performs automatic memory management. | [MIT-style](https://github.com/ivmai/bdwgc/blob/master/LICENSE)
| [Libevent][libevent] | An event notification library. Implements concurrency features such as [`Fiber`](https://crystal-lang.org/api/Fiber.html) and the event loop. | [Modified BSD](https://github.com/libevent/libevent/blob/master/LICENSE)
| [compiler-rt builtins][compiler-rt] | Provides optimized implementations for low-level routines required by code generation, such as integer multiplication. Several of these routines are ported to Crystal directly. | [MIT / UIUC][compiler-rt]

## Standard library dependencies

These libraries are required by different parts of the standard library

| Library | Description | License |
|---------|-------------|---------|
| [GMP][libgmp] | GNU multiple precision arithmetic library. Implements the `Big` types such as [`BigInt`](https://crystal-lang.org/api/BigInt.html). | [LGPL v3+ / GPL v2+](https://gmplib.org/manual/Copying)
| [LibXML2][libxml2] | XML parser developed for the Gnome project. Implements the [`XML`](https://crystal-lang.org/api/XML.html) module. | [MIT](https://gitlab.gnome.org/GNOME/libxml2/-/blob/master/Copyright)
| [LibYAML][libyaml] | YAML parser and emitter library. Implements the [`YAML`](https://crystal-lang.org/api/YAML.html) module. | [MIT](https://github.com/yaml/libyaml/blob/master/License)
| [OpenSSL][openssl] | Provides `libcrypto`, general-purpose cryptographic routines, and `libssl`, an implementation of the SSL and TLS protocols. Implements the [`OpenSSL`](https://crystal-lang.org/api/OpenSSL.html) module. May be disabled with the `-Dwithout_openssl` [compile-time flag](syntax_and_semantics/compile_time_flags.md#compiler-features). | [Apache v2 (3.0+), OpenSSL / SSLeay (1.x)](https://www.openssl.org/source/license.html)
| [LibreSSL][libressl] | A fork of OpenSSL developed by the OpenBSD project. Can be used as a drop-in replacement for OpenSSL; Crystal will automatically detect the library version and supported APIs. May be disabled with the `-Dwithout_openssl` compile-time flag. | [ISC / OpenSSL / SSLeay](https://github.com/libressl-portable/openbsd/blob/master/src/lib/libssl/LICENSE)
| [zlib][zlib] | Lossless data compression library. Implements the [`Compress`](https://crystal-lang.org/api/Compress.html) module. May be disabled with the `-Dwithout_zlib` compile-time flag. | [zlib](http://zlib.net/zlib_license.html)

## Compiler dependencies

These libraries are needed to build the compiler itself, 

| Library | Description | License |
|---------|-------------|---------|
| [LLVM][libllvm] | Target-independent code generator and optimizer. Crystal uses LLVM for compilation (but relies on an external linker). | [Apache v2 with LLVM exceptions](https://llvm.org/docs/DeveloperPolicy.html#new-llvm-project-license-framework)

[libpcre]: http://www.pcre.org/
[libgc]: https://github.com/ivmai/bdwgc
[libevent]: https://libevent.org/
[libgmp]: https://gmplib.org/
[libxml2]: http://xmlsoft.org/
[libyaml]: https://pyyaml.org/wiki/LibYAML
[zlib]: http://zlib.net/
[openssl]: https://www.openssl.org/
[libressl]: https://www.libressl.org/
[libllvm]: https://llvm.org/
[compiler-rt]: https://compiler-rt.llvm.org/

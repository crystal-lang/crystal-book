# Compile-time flags

Compile-time flags are boolean values provided through the compiler via a macro method.
They allow to conditionally include or exclude code based on compile time conditions.

There are several default flags provided by the compiler with information about compiler options and the target platform.
User-provided flags are passed to the compiler, which allow them to be used as feature flags.

## Querying flags

A flag is just a named identifier which is either set or not.
The status can be queried from code via the macro method [`flag?`](https://crystal-lang.org/api/Crystal/Macros.html#flag%3F%28name%29%3ABoolLiteral-instance-method). It receives the name of a flag as a string or symbol
literal and returns a bool literal indicating the flag's state.

The following program shows the use of compile-time flags by printing the target OS family.

```cr
{% if flag?(:unix) %}
  puts "This program is compiled for a UNIX-like operating system"
{% elsif flag?(:windows) %}
  puts "This program is compiled for Windows"
{% else %}
  # Currently, all supported targets are either UNIX or Windows platforms, so
  # this branch is practically unreachable.
  puts "Compiling for some other operating system"
{% end %}
```

There's also the macro method [`host_flag?`](https://crystal-lang.org/api/Crystal/Macros.html#host_flag%3F%28name%29%3ABoolLiteral-instance-method)
which returns whether a flag is set for the *host* platform, which can differ
from the target platform (queried by `flag?`) during cross-compilation.

## Compiler-provided flags

The compiler defines a couple of implicit flags. They describe either the target platform or compiler options.

### Target platform flags

Platform-specific flags derive from the [target triple](http://llvm.org/docs/LangRef.html#target-triple).
See [Platform Support](platform_support.md) for a list of supported target platforms.

`crystal --version` shows the default target triple of the compiler. It can be changed with the `--target` option.

The flags in each of the following tables are mutually exclusive, except for those marked as *(derived)*.

#### Architecture

The target architecture is the first component of the target triple.

| Flag name | Description |
|-----------|-------------|
| `aarch64` | AArch64 architecture
| `arm`     | ARM architecture
| `i386`    | x86 architecture (32-bit)
| `x86_64`  | x86-64 architecture
| `bits32` *(derived)*  | 32-bit architecture
| `bits64` *(derived)*  | 64-bit architecture

#### Vendor

The vendor is the second component of the target triple. This is typically unused,
so the most common vendor is `unknown`.

| Flag name | Description |
|-----------|-------------|
| `macosx`  | Apple
| `portbld` | FreeBSD variant
| `unknown` | Unknown vendor

#### Operating System

The operating system is derived from the third component of a the target triple.

| Flag name | Description |
|-----------|-------------|
| `bsd` *(derived)* | BSD family (DragonFlyBSD, FreeBSD, NetBSD, OpenBSD)
| `darwin`  | Darwin (MacOS)
| `dragonfly` | DragonFlyBSD
| `freebsd` | FreeBSD
| `linux`   | Linux
| `netbsd`  | NetBSD
| `openbsd` | OpenBSD
| `unix` *(derived)* | UNIX-like (BSD, Darwin, Linux)
| `windows` | Windows

#### ABI

The ABI is derived from the last component of the target triple.

| Flag name | Description |
|-----------|-------------|
| `android` | Android (Bionic C runtime)
| `armhf` *(derived)* | ARM EABI with hard float
| `gnu`     | GNU
| `gnueabihf` | GNU EABI with hard float
| `msvc`    | Microsoft Visual C++
| `musl`    | musl
| `win32` *(derived)* | Windows API

### Compiler options

The compiler sets these flags based on compiler configuration.

| Flag name | Description |
|-----------|-------------|
| `release` | Compiler operates in release mode (`--release` or `-O3 --single-module` CLI option)
| `debug`   | Compiler generates debug symbols (without `--no-debug` CLI option)
| `static`  | Compiler creates a statically linked executable (`--static` CLI option)
| `docs`    | Code is processed to generate API docs (`crystal docs` command)

## User-provided flags

User-provided flags are not defined automatically. They can be passed to the compiler via the `--define` or `-D` command line options.

These flags usually enable certain features which activate breaking new or legacy functionality,
a preview for a new feature, or entirely alternative behaviour (e.g. for debugging purposes).

```console
$ crystal eval -Dfoo 'puts {{ flag?(:foo) }}'
true
```

### Stdlib features

| Flag name | Description |
|-----------|-------------|
| `gc_none` | Disables garbage collection ([#5314](https://github.com/crystal-lang/crystal/pull/5314))
| `debug_raise` | Debugging flag for `raise` logic. Prints the backtrace before raising.
| `preview_mt` | Enables multithreading preview. Introduced in 0.28.0 ([#7546](https://github.com/crystal-lang/crystal/pull/7546))
| `strict_multi_assign` | Enable strict semantics for [one-to-many assignment](assignment.md#one-to-many-assignment). Introduced in 1.3.0 ([#11145](https://github.com/crystal-lang/crystal/pull/11145), [#11545](https://github.com/crystal-lang/crystal/pull/11545))
| `skip_crystal_compiler_rt` | Exclude Crystal's native `compiler-rt` implementation.
| `use_pcre2` | Use PCRE2 as regex engine (instead of legacy PCRE). Introduced in 1.7.0.
| `use_pcre` | Use PCRE as regex engine (instead of PCRE2). Introduced in 1.8.0.

### Compiler features

| Flag name | Description |
|-----------|-------------|
| `without_openssl` | Build the compiler without OpenSSL support
| `without_zlib` | Build the compiler without Zlib support
| `without_playground` | Build the compiler without playground (`crystal play`)
| `i_know_what_im_doing` | Safety guard against involuntarily building the compiler
| `no_number_autocast` | Will not [autocast](autocasting.md#number-autocasting) numeric expressions, only literals |
| `preview_dll` | Enable dynamic linking on Windows; experimental |
| `preview_win32_delay_load` | Delay-load all DLLs on Windows; experimental |

### User code features

Custom flags can be freely used in user code as long as they don't collide with compiler-provided flags
or other user-defined flags.
When using a flag specific to a shard, it's recommended to use the shard name as a prefix.

# Crystal Platform Support

The Crystal compiler runs on, and compiles to, a great number of platforms, though not all platforms are equally supported. Crystal’s support levels are organized into three tiers, each with a different set of guarantees.

Platforms are identified by their “target triple” which is the string to inform the compiler what kind of output should be produced. The columns below indicate whether the corresponding component works on the specified platform.

***

## Tier 1

Tier 1 platforms can be thought of as “guaranteed to work”. Specifically they will each satisfy the following requirements:

* Official binary releases are provided for the platform.
* Automated testing is set up to run tests for the platform.
* Documentation for how to use and how to build the platform is available.

Only maintained operating system versions are fully supported. Obsolete versions are not guaranteed to work
and drop into *Tier 2*.

| Target | Description | Supported versions | Comment |
| ------ | ----------- | ------------------ | ------- |
| `aarch64-darwin` | Aarch64 macOS<br> (Apple Silicon) | 11+ | :material-selection-marked-circle: tests<br> :material-checkbox-marked-circle: builds
| `x86_64-darwin` | x64 macOS<br> (Intel) | 11+<br> *(testing only on 11; expected to work on 10.7+)* | :material-checkbox-marked-circle: tests<br> :material-checkbox-marked-circle: builds
| `x86_64-linux-gnu` | x64 Linux | kernel 4.14+, GNU libc 2.26+<br> *(expected to work on kernel 2.6.18+)* | :material-checkbox-marked-circle: tests<br> :material-checkbox-marked-circle: builds
| `x86_64-linux-musl` | x64 Linux | kernel 4.14+, MUSL libc 1.2+<br> *(expected to work on kernel 2.6.18+)* | :material-checkbox-marked-circle: tests<br> :material-checkbox-marked-circle: builds

***

## Tier 2

Tier 2 platforms can be thought of as “expected to work”.

The requirements for *Tier 1* may be partially fulfilled, but are lacking in some way that prevents a solid gurantee.
Details are described in the *Comment* column.

| Target | Description | Supported versions | Comment |
| ------ | ----------- | ------------------ | ------- |
| `aarch64-linux-gnu` | Aarch64 Linux | GNU libc 2.26+ | :material-checkbox-marked-circle: tests<br> :material-selection-ellipse: builds
| `aarch64-linux-musl` | Aarch64 Linux | MUSL libc 1.2+ | :material-checkbox-marked-circle: tests<br> :material-selection-ellipse: builds
| `arm-linux-gnueabihf` | Aarch32 Linux<br> (hardfloat) | GNU libc 2.26+ | :material-selection-ellipse: tests<br> :material-selection-ellipse: builds
| `i386-linux-gnu` | x86 Linux | kernel 4.14+, GNU libc 2.26+<br> *(expected to work on kernel 2.6.18+)* | :material-selection-ellipse: tests<br> :material-selection-ellipse: builds
| `i386-linux-musl` | x86 Linux | kernel 4.14+, MUSL libc 1.2+<br> *(expected to work on kernel 2.6.18+)* | :material-selection-ellipse: tests<br> :material-selection-ellipse: builds
| `x86_64-openbsd` | x64 OpenBSD | 6+ | :material-selection-ellipse: tests<br> :material-selection-ellipse: builds
| `x86_64-freebsd` | x64 FreeBSD | 12+ | :material-selection-ellipse: tests<br> :material-selection-ellipse: builds

***

## Tier 3

Tier 3 platforms can be thought of as “partially works”.

The Crystal codebase has support for these platforms, but there are some major limitations.
Most typically, some parts of the standard library are not supported completely.

| Target | Description | Supported versions | Comment |
| ------ | ----------- | ------------------ | ------- |
| `x86_64-windows-msvc` | x64 Windows (MSVC ) | 7+ | :material-circle-slice-7: tests<br> :material-checkbox-marked-circle: builds |
| `aarch64-linux-android` | aarch64 Android  | Bionic C runtime, API level 24+ | :material-selection-ellipse: tests<br> :material-selection-ellipse: builds |
| `x86_64-unknown-dragonfly` | x64 DragonFlyBSD | | :material-selection-ellipse: tests<br> :material-selection-ellipse: builds |
| `x86_64-unknown-netbsd` | x64 NetBSD | | :material-selection-ellipse: tests<br> :material-selection-ellipse: builds |
| `wasm32-unknown-wasi` | WebAssembly (WASI libc) | Wasmtime 2+ | :material-circle-slice-5: tests |
| `x86_64-solaris` | Solaris/illumos | | :material-selection-ellipse: tests<br> :material-selection-ellipse: builds |

!!! info "Legend"
    <ul>
    <li>:material-selection-ellipse: means automated tests or builds are not available</li>
    <li>:material-checkbox-marked-circle: means automated tests or builds are available</li>
    <li>:material-circle-slice-5: means automated test are available, but the implementation is incomplete</li>
    </li>

!!! note
    Big thanks go to the Rust team for putting together such a clear [document on Rust's platform support](https://forge.rust-lang.org/platform-support.html)
    that we used as insipration for ours.

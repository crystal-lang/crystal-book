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

| Target | Description | Supported versions |
| ------ | ----------- | ------------------ |
| `x86_64-darwin` | x64 macOS (Intel) | 11+<br> *(testing only on 11; expected to work on 10.7+)* |
| `x86_64-linux-gnu` | x64 Linux | kernel 4.14+, GNU libc 2.26+<br> *(expected to work on kernel 2.6.18+)* |

***

## Tier 2

Tier 2 platforms can be thought of as “expected to work”.

The requirements for *Tier 1* may be partially fulfilled, but are lacking in some way that prevents a solid gurantee.
Details are described in the *Comment* column.

| Target | Description | Supported versions | Comment |
| ------ | ----------- | ------------------ | ------- |
| `aarch64-darwin` | Aarch64 macOS (Apple Silicon) | 11+ | ❌ tests ✅ builds
| `aarch64-linux-gnu` | Aarch64 Linux (hardfloat) | GNU libc 2.26+ | ✅ tests ❌ builds
| `aarch64-linux-musl` | Aarch64 Linux (hardfloat) | MUSL libc 2.26+ | ✅ tests ❌ builds
| `arm-linux-gnueabihf` | Aarch32 Linux (hardfloat) | GNU libc 2.26+ | ❌ tests ❌ builds
| `i386-linux-gnu` | x86 Linux | kernel 4.14+, GNU libc 2.26+<br> *(expected to work on kernel 2.6.18+)* | ❌ tests ❌ builds
| `i386-linux-musl` | x86 Linux | kernel 4.14+, MUSL libc 1.2+<br> *(expected to work on kernel 2.6.18+)* | ❌ tests ❌ builds
| `x86_64-linux-musl` | x64 Linux | kernel 4.14+, MUSL libc 1.2+<br> *(expected to work on kernel 2.6.18+)* | ✅ tests ✅ builds
| `x86_64-openbsd` | x64 OpenBSD | 6+ | ❌ tests ❌ builds
| `x86_64-freebsd` | x64 FreeBSD | 12+ | ❌ tests ❌ builds

***

## Tier 3

Tier 3 platforms can be though of as “partially works”.

The Crystal codebase has support for these platforms, but there are some major limitations.
Most typically, some parts of the standard library are not supported completely.

| Target | Description | Supported versions | Comment |
| ------ | ----------- | ------------------ | ------- |
| `x86_64-windows-msvc` | x64 Windows (MSVC ) | 7+ | :yellow_circle: tests<br> :white_check_mark: builds |
| `aarch64-linux-android` | aarch64 Android  | Bionic C runtime, API level 28+ | :red_circle: tests<br> :red_circle: builds |
| `x86_64-unknown-dragonfly` | x64 DragonFlyBSD | | :red_circle: tests<br> :red_circle: builds |
| `x86_64-unknown-netbsd` | x64 NetBSD | | :red_circle: tests<br> :red_circle: builds |
| `wasm32-unknown-wasi` | WebAssembly (WASI libc) | Wasmtime 2+ | :yellow_circle: tests |

!!! info "Original Unicode icons"
    * ❌ means automated tests or builds are not available
    * ✅ means automated tests or builds are available
    * 🟡 means automated test are available, but the implementation is incomplete

!!! info "Unicode icons without cross"
    * ⭕ means automated tests or builds are not available
    * ✅ means automated tests or builds are available
    * 🟡 means automated test are available, but the implementation is incomplete

!!! info "Temoji circles + checkmark"
    * :red_circle: means automated tests or builds are not available
    * :white_check_mark: means automated tests or builds are available
    * :yellow_circle: means automated test are available, but the implementation is incomplete

!!! info "Temoji circles"
    * :red_circle: means automated tests or builds are not available
    * :green_circle: means automated tests or builds are available
    * :yellow_circle: means automated test are available, but the implementation is incomplete

!!! info "Material checkbock outline"
    * :material-checkbox-blank-off-outline: means automated tests or builds are not available
    * :material-checkbox-outline: means automated tests or builds are available
    * :material-checkbox-blank-outline: means automated test are available, but the implementation is incomplete

!!! info "Material checkbox"
    * :material-checkbox-blank-off: means automated tests or builds are not available
    * :material-checkbox-marked: means automated tests or builds are available
    * :material-checkbox-blank: means automated test are available, but the implementation is incomplete

!!! info "Material circle"
    * :material-circle-outline: means automated tests or builds are not available
    * :material-circle-slice-8: means automated tests or builds are available
    * :material-circle-slice-4: means automated test are available, but the implementation is incomplete

    This allows intermediary steps: :material-circle-slice-1: :material-circle-slice-6:

!!! info "Material checkbox circle"
    * :material-checkbox-blank-circle-outline: means automated tests or builds are not available
    * :material-checkbox-marked-circle: means automated tests or builds are available
    * :material-checkbox-blank-circle: means automated test are available, but the implementation is incomplete

!!! info "Octicons circle check 16"
    * :octicons-circle-slash-16: means automated tests or builds are not available
    * :octicons-check-circle-16: means automated tests or builds are available
    * :octicons-circle-16: means automated test are available, but the implementation is incomplete

!!! info "Octicons circle check 24"
    * :octicons-circle-slash-24: means automated tests or builds are not available
    * :octicons-check-circle-24: means automated tests or builds are available
    * :octicons-circle-24: means automated test are available, but the implementation is incomplete


!!! note
    Big thanks go to the Rust team for putting together such a clear [document on Rust's platform support](https://forge.rust-lang.org/platform-support.html)
    that we used as insipration for ours.

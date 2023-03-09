# Crystal Platform Support

The Crystal compiler runs on, and compiles to, a great number of platforms, though not all platforms are equally supported. Crystal’s support levels are organized into three tiers, each with a different set of guarantees.

Platforms are identified by their “target triple” which is the string to inform the compiler what kind of output should be produced. The columns below indicate whether the corresponding component works on the specified platform.

***

## Tier 1

Tier 1 platforms can be thought of as “guaranteed to work”. Specifically they will each satisfy the following requirements:

* Official binary releases are provided for the platform.
* Automated testing is set up to run tests for the platform.
* Documentation for how to use and how to build the platform is available.

| Target | Compiler | Std | Description |
| ------ | -------- | --- | ----------- |
| x86_64-darwin | ✓ | ✓ | 64-bit OSX (10.7+, Lion+) |
| x86_64-linux-gnu | ✓ | ✓ | 64-bit Linux (kernel 2.6.18+, GNU libc) |

***

## Tier 2

Tier 2 platforms can be thought of as “expected to build”. Automated tests are not run so it’s not guaranteed to produce a working build, but platforms often work to quite a good degree and patches are always welcome!

| Target | Compiler | Std | Description |
| ------ | -------- | --- | ----------- |
| aarch64-darwin | ✓ | ✓ | ARM 64-bit OSX (Apple Silicon) |
| aarch64-linux-gnu | ✓ | ✓ | ARM 64-bit Linux (GNU libc, hardfloat) |
| aarch64-linux-musl | ✓ | ✓ | ARM 64-bit Linux (MUSL libc, hardfloat) |
| arm-linux-gnueabihf | ✓ | ✓ | ARM 32-bit Linux (GNU libc, hardfloat) |
| i386-linux-gnu | ✓ | ✓ | 32-bit Linux (kernel 2.6.18+, GNU libc) |
| i386-linux-musl | ✓ | ✓ | 32-bit Linux (MUSL libc) |
| x86_64-linux-musl | ✓ | ✓ | 64-bit Linux (MUSL libc) |
| x86_64-openbsd | ✓ | ✓ | 64-bit OpenBSD (6.x) |
| x86_64-freebsd | ✓ | ✓ | 64-bit FreeBSD (12.x) |

***

## Tier 3

Tier 3 platforms are those which the Crystal codebase has some sort of support for, but which are not built or tested automatically, and may not work. Official builds are not available.

| Target | Compiler | Std | Description |
| ------ | -------- | --- | ----------- |
| x86_64-windows-msvc |  |  | 64-bit MSVC (Windows 7+) |
| aarch64-linux-android |  |  | ARM 64-bit Android (Bionic C runtime, API level 28+) |
| x86_64-unknown-dragonfly | | | 64-bit DragonFlyBSD |
| x86_64-unknown-netbsd | | | 64-bit NetBSD |
| wasm32-unknown-wasi | | | WebAssembly (WASI libc) |

Note: big thanks go to the Rust team for putting together such a clear doc on Rust's platform support. We felt it was so close to what we were needing in Crystal, that we basically copied many chunks of their document. See https://forge.rust-lang.org/platform-support.html.

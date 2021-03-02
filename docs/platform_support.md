IMPORTANT: this is a draft, see related discussion here: (link issue once open). Initially this page will work as a target spec for the Jenkins-based CI infrastructure we're working on. Once we make them match, it'll become documentation about the current reality of platform support in Crystal.

# Crystal Platform Support

The Crystal compiler runs on, and compiles to, a great number of platforms, though not all platforms are equally supported. Crystal’s support levels are organized into three tiers, each with a different set of guarantees.

Platforms are identified by their “target triple” which is the string to inform the compiler what kind of output should be produced. The columns below indicate whether the corresponding component works on the specified platform.

Note: big thanks go to the Rust team for putting together such a clear doc on Rust's platform support. We felt it was so close to what we were needing in Crystal, that we basically copied many chunks of their document. See https://forge.rust-lang.org/platform-support.html.

***

## Tier 1

Tier 1 platforms can be thought of as “guaranteed to work”. Specifically they will each satisfy the following requirements:

* Official binary releases are provided for the platform.
* Automated testing is set up to run tests for the platform.
* Documentation for how to use and how to build the platform is available.

| Target | Compiler | Std | Description |
| ------ | -------- | --- | ----------- |
| x86_64-darwin | ✓ | ✓ | 64-bit OSX (10.7+, Lion+) |
| x86_64-linux-gnu | ✓ | ✓ | 64-bit Linux (2.6.18+) |
| i386-linux-gnu | ✓ | ✓ | 32-bit Linux (2.6.18+) |

***

## Tier 2

Tier 2 platforms can be thought of as “expected to build”. Automated tests are not run so it’s not guaranteed to produce a working build, but platforms often work to quite a good degree and patches are always welcome!

| Target | Compiler | Std | Description |
| ------ | -------- | --- | ----------- |
| aarch64-linux-gnu | ✓ | ✓ | ARM 64-bit Linux (GNU, hardfloat) |
| aarch64-linux-musl | ✓ | ✓ | ARM 64-bit Linux (MUSL, hardfloat) |
| arm-linux-gnueabihf | ✓ | ✓ | ARM 32-bit Linux (GNU, hardfloat) |
| i386-linux-musl | ✓ | ✓ | 32-bit Linux (MUSL) |
| x86_64-linux-musl | ✓ | ✓ | 64-bit Linux (MUSL) |
| x86_64-openbsd | ✓ | ✓ | 64-bit OpenBSD (6.x) |
| x86_64-freebsd | ✓ | ✓ | 64-bit FreeBSD (11.x) |

***

## Tier 3

Tier 3 platforms are those which the Crystal codebase has some sort of support for, but which are not built or tested automatically, and may not work. Official builds are not available.

| Target | Compiler | Std | Description |
| ------ | -------- | --- | ----------- |
| x86_64-windows-msvc |  |  | 64-bit MSVC (Windows 7+) |
| aarch64-darwin | | | ARM 64-bit OSX (Apple Silicon) |
| x86_64-unknown-dragonfly | | | 64-bit DragonFlyBSD |
| x86_64-unknown-netbsd | | | 64-bit NetBSD |

***

## Other

This is a list of other platforms that currently have no support that we're aware of. You can contribute by adding platforms that are not listed in the whole wiki page so that they get into the radar of the community. If you think any of the platforms listed below actually belongs in Tier 1, 2 or 3, kindly open an issue to let us know. Note however that this is not a roadmap, it's just a map. The fact that a target appears here doesn't mean that we're going to eventually provide any level of support for it in the future.

| Target | Compiler | Std | Description | Status notes |
| ------ | -------- | --- | ----------- | ------------ |
| i686-apple-darwin  ||| 32-bit OSX (10.7+, Lion+) ||
| i686-pc-windows-gnu ||| 32-bit MinGW (Windows 7+) ||
| i686-pc-windows-msvc ||| 32-bit MSVC (Windows 7+) ||
| x86_64-pc-windows-gnu ||| 64-bit MinGW (Windows 7+) ||
| aarch64-apple-ios ||| ARM64 iOS ||
| arm-linux-androideabi ||| ARMv7 Android ||
| arm-linux-musleabi ||| ARMv6 Linux with MUSL ||
| arm-linux-musleabihf ||| ARMv6 Linux, MUSL, hardfloat ||
| armv7-apple-ios ||| ARMv7 iOS, Cortex-a8 ||
| armv7-linux-musleabihf ||| ARMv7 Linux with MUSL ||
| armv7s-apple-ios ||| ARMv7 iOS, Cortex-a9 ||
| asmjs-unknown-emscripten ||| asm.js via Emscripten ||
| i386-apple-ios ||| 32-bit x86 iOS ||
| i586-pc-windows-msvc ||| 32-bit Windows w/o SSE ||
| mips-linux-gnu ||| MIPS Linux ||
| mips-linux-musl ||| MIPS Linux with MUSL ||
| mipsel-linux-gnu ||| MIPS (LE) Linux ||
| mipsel-linux-musl ||| MIPS (LE) Linux with MUSL ||
| mips64-linux-gnuabi64 ||| MIPS64 Linux, n64 ABI ||
| mips64el-linux-gnuabi64 ||| MIPS64 (LE) Linux, n64 ABI ||
| powerpc-linux-gnu ||| PowerPC Linux ||
| powerpc64-linux-gnu ||| PPC64 Linux ||
| powerpc64le-linux-gnu ||| PPC64LE Linux ||
| s390x-linux-gnu ||| S390x Linux ||
| wasm32-unknown-emscripten ||| WebAssembly via Emscripten ||
| x86_64-apple-ios ||| 64-bit x86 iOS ||
| x86_64-rumprun-netbsd ||| 64-bit NetBSD Rump Kernel ||
| aarch64-linux-android ||| ARM64 Android ||
| aarch64-unknown-fuchsia ||| Fuchsia OS ||
| armv5te-unknown-linux-gnueabi ||| ARMv5TE ||
| armv7-linux-androideabi ||| ARMv7a Android ||
| i586-unknown-linux-gnu ||| 32-bit Linux w/o SSE ||
| i686-linux-android ||| 32-bit x86 Android ||
| i686-pc-windows-msvc (XP) ||| Windows XP support ||
| i686-unknown-freebsd ||| 32-bit FreeBSD ||
| i686-unknown-haiku ||| 32-bit Haiku ||
| le32-unknown-nacl ||| PNaCl sandbox ||
| mips-unknown-linux-uclibc ||| MIPS Linux with uClibc ||
| mipsel-unknown-linux-uclibc ||| MIPS (LE) Linux with uClibc ||
| msp430-none-elf ||| 16-bit MSP430 microcontrollers ||
| sparc64-unknown-linux-gnu ||| SPARC Linux ||
| sparc64-unknown-netbsd ||| SPARC NetBSD ||
| thumbv6m-none-eabi ||| Bare Cortex-M0, M0+, M1 ||
| thumbv7em-none-eabi ||| Bare Cortex-M4, M7 ||
| thumbv7em-none-eabihf ||| Bare Cortex-M4F, M7F, FPU, hardfloat ||
| thumbv7m-none-eabi ||| Bare Cortex-M3 ||
| x86_64-pc-windows-msvc (XP) ||| Windows XP support ||
| x86_64-sun-solaris ||| 64-bit Solaris/SunOS ||
| x86_64-unknown-bitrig ||| 64-bit Bitrig ||
| x86_64-unknown-fuchsia ||| Fuchsia OS ||
| x86_64-unknown-haiku ||| 64-bit Haiku ||
| x86_64-unknown-redox ||| Redox OS ||

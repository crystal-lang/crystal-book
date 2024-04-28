# Use zig cc as an alternative linker

This approach was originally verified by @luislavena and first posted [here](https://forum.crystal-lang.org/t/a-github-action-template-for-do-release-assets-when-push-a-tag-it-should-fitable-for-any-shards/4635/5), [here](https://forum.crystal-lang.org/t/a-github-action-template-for-do-release-assets-when-push-a-tag-it-should-fitable-for-any-shards/4635/8) and [here](https://forum.crystal-lang.org/t/does-anyone-deploy-crystal-app-on-arm-based-linux-server-what-is-the-deployment-process-like/5588/5), big thanks to him for proving this solution work, and he showed a little bit of this in following videos:

[Building CLIs with Crystal - Quick cross-compilation - Part 1](https://www.youtube.com/watch?v=ij7alYEvfTg)
[Building CLIs with Crystal - Quick cross-compilation - Part 2](https://www.youtube.com/watch?v=LdVNqdf_kBI)

Here are some links explain how `zig cc` link work:

[`zig cc`: a Powerful Drop-In Replacement for GCC/Clang](https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html)

[How Uber Uses Zig](https://jakstys.lt/2022/how-uber-uses-zig/)


# What are the benefits?

You can use a `system-independent` way to generate (static) bianry for the following platforms.

```sh
╰─ $  zig targets | jq .libc
[
  "aarch64_be-linux-gnu",
  "aarch64_be-linux-musl",
  "aarch64_be-windows-gnu",
  "aarch64-linux-gnu",
  "aarch64-linux-musl",
  "aarch64-windows-gnu",
  "aarch64-macos-none",
  "aarch64-macos-none",
  "aarch64-macos-none",
  "armeb-linux-gnueabi",
  "armeb-linux-gnueabihf",
  "armeb-linux-musleabi",
  "armeb-linux-musleabihf",
  "armeb-windows-gnu",
  "arm-linux-gnueabi",
  "arm-linux-gnueabihf",
  "arm-linux-musleabi",
  "arm-linux-musleabihf",
  "thumb-linux-gnueabi",
  "thumb-linux-gnueabihf",
  "thumb-linux-musleabi",
  "thumb-linux-musleabihf",
  "arm-windows-gnu",
  "csky-linux-gnueabi",
  "csky-linux-gnueabihf",
  "x86-linux-gnu",
  "x86-linux-musl",
  "x86-windows-gnu",
  "m68k-linux-gnu",
  "m68k-linux-musl",
  "mips64el-linux-gnuabi64",
  "mips64el-linux-gnuabin32",
  "mips64el-linux-musl",
  "mips64-linux-gnuabi64",
  "mips64-linux-gnuabin32",
  "mips64-linux-musl",
  "mipsel-linux-gnueabi",
  "mipsel-linux-gnueabihf",
  "mipsel-linux-musl",
  "mips-linux-gnueabi",
  "mips-linux-gnueabihf",
  "mips-linux-musl",
  "powerpc64le-linux-gnu",
  "powerpc64le-linux-musl",
  "powerpc64-linux-gnu",
  "powerpc64-linux-musl",
  "powerpc-linux-gnueabi",
  "powerpc-linux-gnueabihf",
  "powerpc-linux-musl",
  "riscv64-linux-gnu",
  "riscv64-linux-musl",
  "s390x-linux-gnu",
  "s390x-linux-musl",
  "sparc-linux-gnu",
  "sparc64-linux-gnu",
  "wasm32-freestanding-musl",
  "wasm32-wasi-musl",
  "x86_64-linux-gnu",
  "x86_64-linux-gnux32",
  "x86_64-linux-musl",
  "x86_64-windows-gnu",
  "x86_64-macos-none",
  "x86_64-macos-none",
  "x86_64-macos-none"
]
```

Uber donation for this solution(not programming use zig, just use `zig cc` for link C++ code for linux-arm64/macOS) since 2022 January, and started using zig cc for all their C++ projects since H2 2022.

Check [Bazel zig cc toolchain](https://sr.ht/~motiejus/bazel-zig-cc/)

# show case

All following code running on my laptop (Arch linux x86_64 Linux 6.7.0-arch3-1 with AMD Ryzen 7 7840HS)

In addition to the Crystal build toolchain, you need install zig use whatever package mananger you know, or build from source code, check https://ziglang.org/download.

For Arch, it just `pacman -S zig`, check https://github.com/ziglang/zig/wiki/Install-Zig-from-a-Package-Manager

The current version of zig is 0.11.0

```sh
 ╰─ $ zig version
0.11.0
```

## reproduces the example in the post `zig cc: a Powerful Drop-In Replacement for GCC/Clang`, but use the latest version of zig.

generate a `hello.exe` can running on Win10 on my linux machine.

```sh
 ╰─ $ \cat hello.c
#include <stdio.h>

int main(int argc, char **argv) {
    fprintf(stderr, "Hello, World!\n");
    return 0;
}

 ╰─ $ zig cc -o hello.exe hello.c -target x86_64-windows-gnu

 ╰─ $ 1  file hello.exe
hello.exe: PE32+ executable (console) x86-64, for MS Windows, 7 sections
```

--------------------

generate luagit aarch64-linux-musl static binary on my linux machine.

```sh
 ╰─ $ git clone https://github.com/LuaJIT/LuaJIT
Cloning into 'LuaJIT'...

 ╰─ $ cd LuaJIT/

  ╰─ $ make CC="zig cc -target aarch64-linux-musl" HOST_CC="zig cc" TARGET_STRIP="echo" LDFLAGS='-lunwind'
==== Building LuaJIT 2.1 ====
make -C src
make[1]: Entering directory '/home/common/Git/LuaJIT/src'
HOSTCC    host/minilua.o
HOSTCC    host/buildvm_asm.o
HOSTCC    host/buildvm_peobj.o
HOSTCC    host/buildvm_lib.o
HOSTCC    host/buildvm_fold.o
CC        lj_assert.o
CC        lj_gc.o
CC        lj_char.o
CC        lj_buf.o
CC        lj_obj.o
CC        lj_str.o
CC        lj_func.o
CC        lj_tab.o
CC        lj_udata.o
CC        lj_meta.o
CC        lj_debug.o
LLD Link... LLD Link... LLD Link... LLD Link... CC        lj_prng.o
CC        lj_vmevent.o
LLD Link... LLD Link... CC        lj_vmmath.o
CC        lj_strscan.o
LLD Link... CC        lj_strfmt.o
CC        lj_strfmt_num.o
LLD Link... CC        lj_serialize.o
CC        lj_api.o
LLD Link... CC        lj_lex.o
LLD Link... CC        lj_parse.o
LLD Link... LLD Link... CC        lj_bcread.o
CC        lj_bcwrite.o
CC        lj_load.o
CC        lj_ir.o
CC        lj_opt_mem.o
LLD Link... CC        lj_opt_narrow.o
CC        lj_opt_dce.o
LLD Link... LLD Link... CC        lj_opt_loop.o
CC        lj_opt_split.o
CC        lj_opt_sink.o
CC        lj_mcode.o
LLD Link... LLD Link... LLD Link... CC        lj_snap.o
CC        lj_asm.o
LLD Link... LLD Link... LLD Link... CC        lj_trace.o
LLD Link... CC        lj_gdbjit.o
CC        lj_ctype.o
CC        lj_cdata.o
CC        lj_cconv.o
LLD Link... CC        lj_ccall.o
LLD Link... CC        lj_ccallback.o
LLD Link... CC        lj_carith.o
CC        lj_clib.o
CC        lj_cparse.o
LLD Link... LLD Link... CC        lj_lib.o
CC        lj_alloc.o
CC        lib_aux.o
LLD Link... LLD Link... CC        lib_package.o
CC        lib_init.o
HOSTLINK  host/minilua
VERSION   luajit.h
DYNASM    host/buildvm_arch.h
CC        lj_profile.o
CC        lj_state.o
CC        luajit.o
HOSTCC    host/buildvm.o
HOSTLINK  host/buildvm
BUILDVM   lj_bcdef.h
BUILDVM   lj_ffdef.h
BUILDVM   lj_libdef.h
BUILDVM   lj_folddef.h
BUILDVM   lj_vm.S
BUILDVM   lj_recdef.h
BUILDVM   jit/vmdef.lua
CC        lj_err.o
CC        lj_dispatch.o
CC        lj_bc.o
CC        lj_record.o
CC        lj_crecord.o
CC        lj_ffrecord.o
CC        lib_base.o
CC        lib_math.o
CC        lib_string.o
CC        lib_bit.o
CC        lib_table.o
CC        lib_io.o
CC        lib_os.o
CC        lib_debug.o
LLD Link... CC        lib_jit.o
LLD Link... LLD Link... LLD Link... CC        lib_ffi.o
LLD Link... CC        lib_buffer.o
LLD Link... ASM       lj_vm.o
CC        lj_opt_fold.o
AR        libluajit.a
DYNLINK   libluajit.so
LLD Link... In file included from /usr/lib/zig/libc/musl/crt/rcrt1.c:3:
/usr/lib/zig/libc/musl/crt/../ldso/dlstart.c:146:20: warning: a function declaration without a prototype is deprecated in all versions of C and is treated as a zero-parameter prototype in C2x, conflicting with a subsequent definition [-Wdeprecated-non-prototype]
        GETFUNCSYM(&dls2, __dls2, base+dyn[DT_PLTGOT]);
                          ^
/usr/lib/zig/libc/musl/crt/rcrt1.c:11:13: note: conflicting prototype is here
hidden void __dls2(unsigned char *base, size_t *sp)
            ^
1 warning generated.
libluajit.so
LINK      luajit
LLD Link... In file included from /usr/lib/zig/libc/musl/crt/rcrt1.c:3:
/usr/lib/zig/libc/musl/crt/../ldso/dlstart.c:146:20: warning: a function declaration without a prototype is deprecated in all versions of C and is treated as a zero-parameter prototype in C2x, conflicting with a subsequent definition [-Wdeprecated-non-prototype]
        GETFUNCSYM(&dls2, __dls2, base+dyn[DT_PLTGOT]);
                          ^
/usr/lib/zig/libc/musl/crt/rcrt1.c:11:13: note: conflicting prototype is here
hidden void __dls2(unsigned char *base, size_t *sp)
            ^
1 warning generated.
luajit
OK        Successfully built LuaJIT
make[1]: Leaving directory '/home/common/Git/LuaJIT/src'
==== Successfully built LuaJIT 2.1 ====

  ╰─ $ file src/luajit
src/luajit: ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), static-pie linked, with debug_info, not stripped

  ╰─ $ qemu-aarch64 src/luajit
LuaJIT 2.1.1703358377 -- Copyright (C) 2005-2023 Mike Pall. https://luajit.org/
JIT: ON fold cse dce fwd dse narrow loop abc sink fuse
> 

```

## build a crystal aarch64 binary use zig cc

We will build `shards` binary for `aarch64-linux-musl` target.

### Step 1. Build app use Crystal --cross-compile and --target=aarch64-linux-musl option.

```
 ╰─ $ git clone https://github.com/crystal-lang/shards
Cloning into 'shards'...

 ╰─ $ git checkout v0.17.4
git checkout v0.17.4
HEAD is now at 29123fc Add CHANGELOG for 0.17.4 (#605)

 ╰─ $ shards build --production --static --release --no-debug --cross-compile --target=aarch64-linux-musl --link-flags=-s
Resolving dependencies
Fetching https://github.com/crystal-lang/crystal-molinillo.git
Installing molinillo (0.2.0)
Building: shards
cc /home/zw963/Crystal/crystal-lang/shards/bin/shards.o -o /home/zw963/Crystal/crystal-lang/shards/bin/shards -s -rdynamic -static -L/home/zw963/Crystal/bin/../lib/crystal -lyaml -lpcre2-8 -lgc -lpthread -ldl -levent

```

So far we have seen that the compiler outputs the linker command using CC like this:

cc bin/shards.o -o bin/shards -s -rdynamic -static -L/home/zw963/Crystal/bin/../lib/crystal -lyaml -lpcre2-8 -lgc -lpthread -ldl -levent

Usually we need linking it on the target platform, in our case, a ARM64 machine, 

Now with `zig cc` magic, we will link it directly on host platfrom instead, but we still need following static link libraries:

```
yaml-static
libevent-static
pcre2-dev
gc-dev
```

### Step 2. Prepare dependency libraries file.

You can download both of them from https://dl-cdn.alpinelinux.org/alpine/v3.18/main/aarch64/, but thanks @@luislavena again, There is a [ruby gem](https://github.com/luislavena/magic-haversack) help us for this.

You need config ruby correctly to use this tool.

```sh
 ╰─ $ git clone https://github.com/luislavena/magic-haversack

 ╰─ $ cd magic-haversack
 
 ╰─ $ rake -T
rake clean                       # Remove any temporary products
rake clobber                     # Remove any generated files
rake clobber_package             # Remove package products
rake fetch:aarch64-apple-darwin  # Fetch all for 'aarch64-apple-darwin'
rake fetch:aarch64-linux-musl    # Fetch all for 'aarch64-linux-musl'
rake fetch:all                   # Fetch all
rake fetch:x86_64-apple-darwin   # Fetch all for 'x86_64-apple-darwin'
rake fetch:x86_64-linux-musl     # Fetch all for 'x86_64-linux-musl'
rake package                     # Build all the packages
rake repackage                   # Force a rebuild of the package files

 ╰─ $ rake fetch:all
 ...
 
```

After done `rake fetch:all`, all required (same version for different target) static library download into `lib` folder and ready to use.

```sh
 ╰─ $ eza -T -L2 lib
lib
├── aarch64-apple-darwin
│  ├── libcrypto.a
│  ├── libevent.a
│  ├── libevent_pthreads.a
│  ├── libgc.a
│  ├── libgmp.a
│  ├── libpcre.a
│  ├── libpcre2-8.a
│  ├── libsodium.a
│  ├── libsqlite3.a
│  ├── libssl.a
│  ├── libyaml.a
│  ├── libz.a
│  └── pkgconfig
├── aarch64-linux-musl
│  ├── libcrypto.a
│  ├── libevent.a
│  ├── libevent_pthreads.a
│  ├── libgc.a
│  ├── libgmp.a
│  ├── libpcre.a
│  ├── libpcre2-8.a
│  ├── libsodium.a
│  ├── libsqlite3.a
│  ├── libssl.a
│  ├── libyaml.a
│  ├── libz.a
│  └── pkgconfig
├── x86_64-apple-darwin
│  ├── libcrypto.a
│  ├── libevent.a
│  ├── libevent_pthreads.a
│  ├── libgc.a
│  ├── libgmp.a
│  ├── libpcre.a
│  ├── libpcre2-8.a
│  ├── libsodium.a
│  ├── libsqlite3.a
│  ├── libssl.a
│  ├── libyaml.a
│  ├── libz.a
│  └── pkgconfig
└── x86_64-linux-musl
   ├── libcrypto.a
   ├── libevent.a
   ├── libevent_pthreads.a
   ├── libgc.a
   ├── libgmp.a
   ├── libpcre.a
   ├── libpcre2-8.a
   ├── libsodium.a
   ├── libsqlite3.a
   ├── libssl.a
   ├── libyaml.a
   ├── libz.a
   └── pkgconfig
```

As of current version, only 4 targets and some of the most useful packages supported.

Check details on [libs.yml](https://github.com/luislavena/magic-haversack/blob/main/libs.yml)

You can copy those file into whatever folder you wish, I copied it to `~/Crystal/static_libraries` personally.

```
 ╰─ $ ls ~/Crystal/static_libraries
aarch64-apple-darwin/  aarch64-linux-musl/  x86_64-apple-darwin/  x86_64-linux-musl/
```

### Step 3: linking use `zig cc`

We will continue the linking process in Step 1

If try running the outputed link command on local X86_64 machine, it not work obviously.

```
 ╰─ $ cd ~/Crystal/crystal-lang/shards
 
 ╰─ $ file bin/shards.o
bin/shards.o: ELF 64-bit LSB relocatable, ARM aarch64, version 1 (SYSV), not stripped

 ╰─ $ cc bin/shards.o -o bin/shards -s -rdynamic -static -L/home/zw963/Crystal/bin/../lib/crystal -lyaml -lpcre2-8 -lgc -lpthread -ldl -levent
/usr/sbin/ld: bin/shards.o: Relocations in generic ELF (EM: 183)
/usr/sbin/ld: bin/shards.o: Relocations in generic ELF (EM: 183)
/usr/sbin/ld: bin/shards.o: Relocations in generic ELF (EM: 183)
/usr/sbin/ld: bin/shards.o: Relocations in generic ELF (EM: 183)
/usr/sbin/ld: bin/shards.o: Relocations in generic ELF (EM: 183)
/usr/sbin/ld: bin/shards.o: Relocations in generic ELF (EM: 183)
/usr/sbin/ld: bin/shards.o: error adding symbols: file in wrong format
collect2: error: ld returned 1 exit status

```

Now the magic show begins, if use `zig cc` instead `cc`, it works! with only trivial steps:


1.  `cc` replace with `zig cc --target aarch64-linux-musl`
2. `-L/home/zw963/Crystal/bin/../lib/crystal` replace with `/home/zw963/Crystal/static_libraries/aarch64-linux-musl`
3. append a ` -lunwind` into link command is necessary, as mention by @luislavena in [this video](https://youtu.be/ij7alYEvfTg?si=YSfGlPssV3E-DY-h&t=521), which is something Crystal used to do backtrace.


So. the new linker command is:

```sh
 ╰─ $ zig cc --target=aarch64-linux-musl bin/shards.o -o bin/shards -s -rdynamic -static -L/home/zw963/Crystal/static_libraries/aarch64-linux-musl -lyaml -lpcre2-8 -lgc -lpthread -ldl -levent -lunwind
LLD Link... In file included from /usr/lib/zig/libc/musl/crt/rcrt1.c:3:
/usr/lib/zig/libc/musl/crt/../ldso/dlstart.c:146:20: warning: a function declaration without a prototype is deprecated in all versions of C and is treated as a zero-parameter prototype in C2x, conflicting with a subsequent definition [-Wdeprecated-non-prototype]
        GETFUNCSYM(&dls2, __dls2, base+dyn[DT_PLTGOT]);
                          ^
/usr/lib/zig/libc/musl/crt/rcrt1.c:11:13: note: conflicting prototype is here
hidden void __dls2(unsigned char *base, size_t *sp)
            ^
1 warning generated.

 ╰─ $ file bin/shards
bin/shards: ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), static-pie linked, stripped

 ╰─ $ qemu-aarch64 bin/shards --version
Shards 0.17.4 ()

```

It works!

built a binary for macOS is bascially same as above process, only two concerns

1. you need compile-time tag `-Duse_libiconv` to allow developers to opt for libiconv variant instead of the built-in iconv support of their platform, check [Allow explicit usage of libiconv](https://github.com/crystal-lang/crystal/pull/11876) for more details.
2. the zig cc supported target name not same as Crystal. you need change it manually.

# An bash script to automate the use of `zig cc` as the linker

We assume that all static library files are stored in ~/Crystal/static_libraries, like this:

```
 ╰─ $ eza -T -L 1 ~/Crystal/static_libraries
/home/zw963/Crystal/static_libraries
├── aarch64-apple-darwin
├── aarch64-linux-musl
├── x86_64-apple-darwin
└── x86_64-linux-musl
```

Following is the script, we name it as `shards`, and rename orignal shards binary to `shards.binary`.

You need at least BASH 4.0 to running this script, and some basic tools, grep, sed, tee, those should out of box on any linux distro, also install zig too.


```sh
#!/usr/bin/env bash

if [ "$1" == "build" ]; then
if echo "$*" |grep -F -qs -e '--target='; then
        # use hash map bash 4.0 is requried.
        declare -A zig_target_map=(
            ["x86_64-linux-musl"]="x86_64-linux-musl"
            ["aarch64-linux-musl"]="aarch64-linux-musl"
            ["x86_64-darwin"]="x86_64-macos-none"
            ["aarch64-darwin"]="aarch64-macos-none"
        )

        declare -A libname_map=(
            ["x86_64-linux-musl"]="x86_64-linux-musl"
            ["aarch64-linux-musl"]="aarch64-linux-musl"
            ["x86_64-darwin"]="x86_64-apple-darwin"
            ["aarch64-darwin"]="aarch64-apple-darwin"
        )

        tmp_file="$(mktemp -d)/$$"

        cr_target=$(echo $* |sed 's#.*--target=\([a-z0-9_-]*\).*#\1#')

        if [[ "$cr_target" =~ -darwin ]]; then
            build_args="${@:2} -Duse_libiconv"
        else
            build_args="${@:2}"
        fi
		
	    build_args=${build_args//--progress/}

        shards.binary build ${build_args} |
            grep '^cc ' |
            sed "s#^cc#zig cc -target ${zig_target_map[$cr_target]}#" |
            sed "s#-L[^ ]*#-L$HOME/Crystal/static_libraries/${libname_map[$cr_target]}#" |
            sed "s#.*#& -lunwind#" |
            tee $tmp_file
        chmod +x $tmp_file && bash $tmp_file
    else
        shards.binary build "${@:2}"
    fi
else
    exec -a shards shards.binary "$@"
fi
```

## show case

```sh
 ╰─ $ cd ~/Crystal/crystal-lang/shards
 
  ╰─ $ git clean -fdx && shards build --production --static --no-debug --cross-compile --target=aarch64-linux-musl --link-flags=-s
Removing bin/shards
Removing bin/shards.o
Removing lib/
zig cc -target aarch64-linux-musl /home/zw963/Crystal/crystal-lang/shards/bin/shards.o -o /home/zw963/Crystal/crystal-lang/shards/bin/shards -s -rdynamic -static -L/home/zw963/Crystal/static_libraries/aarch64-linux-musl -lyaml -lpcre2-8 -lgc -lpthread -ldl -levent -lunwind
 
 ╰─ $ file bin/shards
bin/shards: ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), static-pie linked, stripped

 ╰─ $ git clean -fdx && shards build --production --static --no-debug --cross-compile --target=x86_64-linux-musl --link-flags=-s
Removing bin/shards
Removing bin/shards.o
Removing lib/
zig cc -target x86_64-linux-musl /home/zw963/Crystal/crystal-lang/shards/bin/shards.o -o /home/zw963/Crystal/crystal-lang/shards/bin/shards -s -rdynamic -static -L/home/zw963/Crystal/static_libraries/x86_64-linux-musl -lyaml -lpcre2-8 -lgc -lpthread -ldl -levent -lunwind

 ╰─ $ file bin/shards
bin/shards: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), static-pie linked, stripped

 ╰─ $ git clean -fdx && shards build --production --static --no-debug --cross-compile --target=x86_64-darwin --link-flags=-s
Removing bin/shards
Removing bin/shards.o
Removing lib/
zig cc -target x86_64-macos-none /home/zw963/Crystal/crystal-lang/shards/bin/shards.o -o /home/zw963/Crystal/crystal-lang/shards/bin/shards -s -rdynamic -static -L/home/zw963/Crystal/static_libraries/x86_64-apple-darwin21.0 -lyaml -lpcre2-8 -lgc -lpthread -ldl -levent -liconv -lunwind

 ╰─ $ file bin/shards
bin/shards: Mach-O 64-bit x86_64 executable, flags:<NOUNDEFS|DYLDLINK|TWOLEVEL|PIE|HAS_TLV_DESCRIPTORS>

 ╰─ $ git clean -fdx && shards build --production --static --no-debug --cross-compile --target=aarch64-darwin --link-flags=-s
Removing bin/shards
Removing bin/shards.o
Removing lib/
zig cc -target aarch64-macos-none /home/zw963/Crystal/crystal-lang/shards/bin/shards.o -o /home/zw963/Crystal/crystal-lang/shards/bin/shards -s -rdynamic -static -L/home/zw963/Crystal/static_libraries/aarch64-apple-darwin21.0 -lyaml -lpcre2-8 -lgc -lpthread -ldl -levent -liconv -lunwind

 ╰─ $ file bin/shards
bin/shards: Mach-O 64-bit arm64 executable, flags:<NOUNDEFS|DYLDLINK|TWOLEVEL|PIE|HAS_TLV_DESCRIPTORS>
```

# Caveats

As described in [this forum](https://forum.crystal-lang.org/t/does-anyone-deploy-crystal-app-on-arm-based-linux-server-what-is-the-deployment-process-like/5588/5):

OpenSSL is a issue, but it exists for any static-linking solution.

[quote="luislavena, post:5, topic:5588"]
Multi-threading is a bit flaky at this stage (`-Dpreview_mt`), I don’t have concrete examples, but encountered random errors that are hard to reproduce.
[/quote]

This also needs more explanation from @luislavena.

----------

There are some other concerns:

1. The llvm version used by the Crystal compiler not matched with static libraries(e.g. libgc-dev)?
2. build windows binary? it should be possible, as the `hello.exe` showcase.



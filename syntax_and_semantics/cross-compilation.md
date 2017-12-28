# Cross-compilation

Crystal supports a basic form of [cross compilation](http://en.wikipedia.org/wiki/Cross_compiler).

## Preparation

Cross-compilation will depend on `libcrystal` being present on the target system.  It can be built by following these steps:
* Download the Crystal source code on the target machine.
* Install the LLVM/compiler toolchain. (e.g. `sudo apt-get install clang` on Ubuntu)
* Install the [required libraries](https://github.com/crystal-lang/crystal/wiki/All-required-libraries) for building Crystal.
* Run `make deps` in the source directory.

These steps will produce `libcrystal.a` within the `ext/src/` directory.


## Compiling

The compiler executable provides two flags:

* `--cross-compile`: When given enables cross compilation mode
* `--target`: the [LLVM Target Triple](http://llvm.org/docs/LangRef.html#target-triple) to use and set the default [compile-time flags](compile_time_flags.html) from

The `--target` flags can be determined by executing `llvm-config --host-target` on the target system. (e.g. 'x86_64-unknown-linux-gnu')

Any compile-time flags not set implicitly through `--target`, can be specified with the `-D` command line flag.

Using these two flags, it is possible to compile a program on a Mac that will run on Linux, like this:

```bash
crystal build your_program.cr --cross-compile --target "x86_64-unknown-linux-gnu"
```

This will generate a `.o` ([Object file](http://en.wikipedia.org/wiki/Object_file)) and will print a line with a command to execute on the target system. For example:

```bash
cc your_program.o -o your_program -lpcre -lgc /local/crystal/src/ext/libcrystal.a
```

The command above can be executed on the target system, once the `.o` file has been copied over.  The reference to `libcrystal.a` may need to be adjusted to match the location that `libcrystal` was compiled to, as per the preparation step.

This procedure is usually done with the compiler itself to port it to new platforms where a compiler is not yet available. Because in order to compile a Crystal compiler, an older Crystal compiler is required, the only two ways to generate a compiler for a system where there is no compiler yet are:
* Checkout the latest version of the compiler written in Ruby, then use that compiler to compile all subsequent versions of the compiler until the current version is reached.
* Create a `.o` file for the target system, and use it to create a compiler.

The first alternative is long and cumbersome, while the second one is much easier.

Cross-compiling can be done for other executables, but its main target is the compiler. If Crystal is not available in some system, it can theoretically be cross-compiled for that system.


## Troubleshooting libraries

The cross-compilation step will generate a command with numerous flags, many of these refer to the libraries that need to be included when compiling a program.
If the libraries are not present on the target system, the compilation will fail and complain about the respective flags, which are not always descriptive.

The following command may be helpful:

```bash
ld -lgc --verbose
```

The output gives more descriptive names (and even paths) for the libraries that cannot be loaded.  These libraries can then be installed and compilation may be retried.

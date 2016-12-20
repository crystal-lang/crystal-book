# From sources

If you want to contribute then you might want to install Crystal from sources. But Crystal is written in Crystal itself! So you first need to use one of the previous described methods to have a running compiler.

You will also need LLVM 3.5 or 3.6 present in the path. If you are using Mac and the Homebrew formula, this will be automatically configured for you if you install Crystal adding `--with-llvm` flag.


1. Make sure to install [all the required libraries](https://github.com/crystal-lang/crystal/wiki/All-required-libraries). You might also want to read the [contributing guide](https://github.com/crystal-lang/crystal/blob/master/CONTRIBUTING.md).

2. Clone the repository:

```
git clone https://github.com/crystal-lang/crystal.git
```

3. Run `make` to build your own version of the compiler
4. Run `make spec` to ensure all specs pass, and you've installed everything correctly.
5. Use `bin/crystal` to run your crystal files

If you would like more information about the new `bin/crystal`, check out the [using the compiler](https://crystal-lang.org/docs/using_the_compiler/) documentation.

Note: The actual binary is built in to `.build/crystal`, but the `bin/crystal` wrapper script is what you should use to run crystal.


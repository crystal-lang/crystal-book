# From sources

If you want to contribute then you might want to install Crystal from sources. But Crystal is written in Crystal itself! So you first need to use one of the previous described methods to have a running compiler.

You will also need LLVM 3.8, 3.9 or 4.0 present in the path. If you are using Mac and the Homebrew formula, this will be automatically configured for you if you install Crystal adding `--with-llvm` flag.


1. [Install the latest Crystal release](https://crystal-lang.org/docs/installation). To compile Crystal, you need Crystal :).

2. Make sure to install [all the required libraries](https://github.com/crystal-lang/crystal/wiki/All-required-libraries). You might also want to read the [contributing guide](https://github.com/crystal-lang/crystal/blob/master/CONTRIBUTING.md). You will also need to have a released version of Crystal already installed.

3. Clone the repository:

```
git clone https://github.com/crystal-lang/crystal.git
```

4. Run `make` to build your own version of the compiler
5. Run `make spec` to ensure all specs pass, and you've installed everything correctly.
6. Use `bin/crystal` to run your crystal files

If you would like more information about the new `bin/crystal`, check out the [using the compiler](https://crystal-lang.org/docs/using_the_compiler/) documentation.

Note: The actual binary is built in to `.build/crystal`, but the `bin/crystal` wrapper script is what you should use to run crystal.


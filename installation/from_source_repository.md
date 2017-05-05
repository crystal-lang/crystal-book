# From sources

If you want to contribute then you might want to install Crystal from sources.

1. [Install the latest Crystal release](https://crystal-lang.org/docs/installation). To compile Crystal, you need Crystal :).

2. Make sure a supported LLVM version is present in the path. Currently, Crystal supports LLVM 3.8, 3.9 and 4.0. When possible, use the latest one. If you are using Mac and the Homebrew formula, this will be automatically configured for you if you install Crystal adding `--with-llvm` flag.

3. Make sure to install [all the required libraries](https://github.com/crystal-lang/crystal/wiki/All-required-libraries). You might also want to read the [contributing guide](https://github.com/crystal-lang/crystal/blob/master/CONTRIBUTING.md).

4. Clone the repository:

```
git clone https://github.com/crystal-lang/crystal.git
```

5. Run `make` to build your own version of the compiler
6. Run `make spec` to ensure all specs pass, and you've installed everything correctly.
7. Use `bin/crystal` to run your crystal files

If you would like more information about the new `bin/crystal`, check out the [using the compiler](https://crystal-lang.org/docs/using_the_compiler/) documentation.

Note: The actual binary is built in to `.build/crystal`, but the `bin/crystal` wrapper script is what you should use to run crystal.

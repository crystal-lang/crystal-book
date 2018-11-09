# On Linux using Linuxbrew

To easily install Crystal on a Linux distribution you can use [Linuxbrew](http://linuxbrew.sh/).

```
brew update
brew install crystal-lang
```

If you're planning to contribute to the language itself you might find useful to install LLVM as well. So replace the last line with:

```
brew install crystal-lang --with-llvm
```

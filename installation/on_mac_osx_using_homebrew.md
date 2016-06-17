# 在 Mac OSX 環境中安裝

我們可以在 Mac 中使用 [Homebrew](http://brew.sh/) 來進行安裝：

```
brew update
brew install crystal-lang
```

如果打算貢獻這個專案，那麼我們也可以同時安裝 LLVM，這是很有幫助的。只要用下面的指令來替換最後一行：

```
brew install crystal-lang --with-llvm
```

## Troubleshooting on OSX 10.11 (El Capitan)

If you get an error like:

```
ld: library not found for -levent
```

you need to reinstall the command line tools and then select the default active toolchain:

```
$ xcode-select --install
$ xcode-select --switch /Library/Developer/CommandLineTools
```

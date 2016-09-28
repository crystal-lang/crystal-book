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

## 疑難排解

### Mac OS X 10.11 (El Capitan)

* 出現 `ld: library not found for -levent` 錯誤

請嘗試重新安裝 Xcode 命令列工具並指定預設 Toolchain：

```
$ xcode-select --install
$ xcode-select --switch /Library/Developer/CommandLineTools
```

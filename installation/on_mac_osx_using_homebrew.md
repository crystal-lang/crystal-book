# 在 Mac OSX 環境中安裝

你可以在 Mac 中使用 [Homebrew](http://brew.sh/) 來進行安裝:

```
brew update
brew install crystal-lang
```

如果你打算貢獻這個專案，那麼你會發現同時安裝 LLVM 是很有幫助的。只要用下面的指令來替換最後一行：

```
brew install crystal-lang --with-llvm
```

# 使用原始碼安裝

如果你想貢獻 Crystal 那你可能會想使用原始碼進行安裝，但是 Crystal 就是用 Crystal 寫的 ! 所以你必須使用前述的方法先取得一個可以執行的編譯器。

該路徑中也必須存在 LLVM 3.5 或 3.6，如果是使用 MAC 中 Homebrew 的套件( formula )，只要在安裝時加上 `--with-llvm` 參數，LLVM 就會被自動配置。

然後複製 repository:

```
git clone https://github.com/manastech/crystal.git
```

然後你就可以開始 hacking 了

使用`make`來建立你自己版本的編譯器。新的編譯器會被放在`.build/crystal`。

確認你已經安裝了 [全部所需的函式庫](https://github.com/manastech/crystal/wiki/All-required-libraries)。 你可能也會想要看看 [貢獻指南](https://github.com/manastech/crystal/blob/master/Contributing.md).

在 repository　中你可以在　`bin/crystal`　找到包裝器腳本( wrapper script)。
這個腳本會執行已經安裝的公用編譯器，或是你剛編譯的編譯器（如果存在）。

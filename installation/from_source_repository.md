# 從原始碼安裝

如果想貢獻 Crystal，那我們可能會選擇從原始碼進行安裝。

1. [Install the latest Crystal release](https://crystal-lang.org/docs/installation). To compile Crystal, you need Crystal :).

2. Make sure a supported LLVM version is present in the path. Currently, Crystal supports LLVM 3.8, 3.9 and 4.0. When possible, use the latest one. If you are using Mac and the Homebrew formula, this will be automatically configured for you if you install Crystal adding `--with-llvm` flag.

在 $PATH 中也必須提供 LLVM 3.5 或 3.6，如果是使用 Mac 中的 Homebrew 套件<small>(Formula)</small>，只要在安裝時加上 `--with-llvm` 參數，LLVM 的路徑就會自動被設定。

3. 請確認我們已經安裝了[全部所需的函式庫](https://github.com/crystal-lang/crystal/wiki/All-required-libraries)。當然，我們也可以先來看看[貢獻指南](https://github.com/crystal-lang/crystal/blob/master/Contributing.md)。

4. 複製 Crystal 的 Git 儲存庫<small>(Repository)</small>：

	```
	git clone https://github.com/crystal-lang/crystal.git
	```

5. 透過 `make` 來建置自己版本的編譯器。

6. Run `make spec` to ensure all specs pass, and you've installed everything correctly.

7. Use `bin/crystal` to run your crystal files

If you would like more information about the new `bin/crystal`, check out the [using the compiler](https://crystal-lang.org/docs/using_the_compiler/) documentation.

Note: The actual binary is built in to `.build/crystal`, but the `bin/crystal` wrapper script is what you should use to run crystal.

# 從原始碼安裝

如果想貢獻 Crystal，那我們可能會選擇從原始碼進行安裝。

1. [安裝最新版本的 Crystal](/installation/)。 我們需要 Crystal 來編譯 Crystal :)

2. 確認支援的 LLVM 版本已在 `$PATH` 中。（目前 Crystal 支援 LLVM 3.8 、 3.9 、 4.0 以及 5.0 ，請儘可能的使用最新的版本。）

    * 如果是使用 Mac 中的 Homebrew 套件<small>(Formula)</small>，只要在安裝時加上 `--with-llvm` 參數，LLVM 的路徑就會自動被設定。

3. 請確認已安裝[全部所需的函式庫](https://github.com/crystal-lang/crystal/wiki/All-required-libraries)。在等待的時候我們也可以先來看看[貢獻指南](https://github.com/crystal-lang/crystal/blob/master/Contributing.md)。

4. 複製 Crystal 的 Git 儲存庫<small>(Repository)</small>：

	```
	git clone https://github.com/crystal-lang/crystal
	```

5. 透過 `make` 來建置自己版本的編譯器。

6. 執行 `make spec` 以確認環境及建置好的編譯器會通過所有測試。

7. 使用 `bin/crystal` 來執行剛建置好的編譯器。

如果想瞭解更多關於編譯器的訊息，請參閱[使用編譯器](/using_the_compiler/)一章。

注意：真正的編譯器其實存放在 `.build/crystal`，但我們需要一個 Wrapper 腳本（`bin/crystal`）來執行。

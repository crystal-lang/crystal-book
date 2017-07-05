# Crystal 程式語言

這裡是 Crystal 語言的教學文件，由 [Crystal-TW](http://crystal-tw.github.io) 翻譯，原文連接[在此](http://crystal-lang.org/docs)。

Crystal 是一個程式語言語言，並嘗試完成以下目標：

* Ruby 風格語法（但不會完全相容 Ruby）
* 自動型別推導以及靜態型別檢查
* 容易撰寫 C 函式庫綁紮<small>(Binding)</small>
* 編譯時期展開巨集並產生最佳化程式碼
* 產生高效原生碼

## 協助翻譯

若內容中有任何錯誤或對於某些章節需要更多說明，
歡迎您一起來貢獻這份中文文件，只需要提交 Pull Request 至以下專案：

https://github.com/crystal-tw/docs

另外，目前所有的討論都會在 [GitHub Issue Tracker](https://github.com/crystal-tw/docs/issues) 以及 [Gitter](https://gitter.im/crystal-tw/crystal-tw.github.io) 上進行。

雖然目前沒有強制規範的規則，但為了確保閱讀順暢，翻譯前請先閱讀已經翻譯好的部分以熟悉慣例，部分規則可以參考[中文文案排版指北](https://github.com/sparanoid/chinese-copywriting-guidelines)。

### 如何建置

本文件使用 Markdown 語法編寫，並使用 [GitBook Toolchain](http://toolchain.gitbook.com) 輸出 HTML（請先安裝 [Node.js](https://nodejs.org) 及 [npm](https://www.npmjs.com)）。

Markdown 語法及規則可以參考 [Markdown 文件](http://markdown.tw)。

```
$ git clone https://github.com/crystal-lang/crystal-book.git
$ cd crystal-book
$ npm install -g gitbook-cli@2.3.0
$ npm install
$ gitbook serve
Live reload server started on port: 35729
Press CTRL+C to quit ...

info: 8 plugins are installed
info: loading plugin "ga"... OK
...
Starting server ...
Serving book on http://localhost:4000

```

產生的 HTML 將放置於 `_book` 目錄下。

There is also a docker environment to avoid installing dependencies globally:

```
$ docker-compose up
...
gitbook_1  | Starting server ...
gitbook_1  | Serving book on http://localhost:4000
gitbook_1  | Restart after change in file node_modules/.bin
...
```

### 已知慣例

雖然慣例僅僅只是慣例，但這邊還是整理出一些大家比較容易掌握的要點：

* 文字中若需補充原文可以使用 `<small>` 標籤，如：

```
# 字串 <small>String</small>
```

* 儘量避免使用第二人稱，將 `You` 改以第一人稱複數表達，如：

```
In type restrictions, generic type arguments and other places where a type is expected, **you** can use a shorter syntax, as explained in the type:
```

會翻譯成：

```
當使用在型別限制時，於任何泛型型別參數或是其他需要填寫型別的地方，「我們」也可以使用簡短的語法來表示序組的型別，這在型別語法一章中會解釋：
```

* 使用相對路徑以及 .md 後綴來建立不同章節之間的連接。


十分感謝您的參與 <(\_ \_)>


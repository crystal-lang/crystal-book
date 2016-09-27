# Crystal 程式語言

這裡是 Crystal 語言的教學文件，由 [Crystal-TW](http://crystal-tw.github.io) 翻譯，原文連接[在此](http://crystal-lang.org/docs)。

Crystal 是一個程式語言語言，並嘗試完成以下目標：

* Ruby 風格語法（但不會完全相容 Ruby）
* 自動型別推導以及靜態型別檢查
* 容易撰寫 C 函式庫綁紮<small>(Binding)</small>
* 編譯時期展開巨集並產生最佳化程式碼
* 產生高效原生碼

## 建置

本文件使用 Markdown 語法編寫，並使用 GitBook 輸出 HTML。

```
$ npm install -g gitbook-cli
$ gitbook build --gitbook=2.3.2
```

產生的 HTML 將放置於 `_book` 目錄下。

## 如何貢獻

若內容中有任何錯誤或對於某些章節需要更多說明，
歡迎您一起來貢獻這份中文文件，只需要提交 Pull Request 至以下專案：

https://github.com/crystal-tw/docs


十分感謝您的參與 <(\_ \_)>

# 字元

字元（[Char](http://crystal-lang.org/api/Char.html)）表達一個[萬國碼<small>(Unicode)</small>](http://zh.wikipedia.org/wiki/Unicode)的[編碼位置<small>(Code point)</small>](https://zh.wikipedia.org/wiki/碼位)。以二進位表達時佔用 32 位元。

以一對單引號（`'`）來括住一個 UTF-8 文字來表達一個字元常值：

```crystal
'a'
'z'
'0'
'_'
'あ'
```

我們可以使用反斜線（`\`）表示某些特殊字元：

```crystal
'\'' # 單引號
'\\' # 反斜線
'\a' # 蜂鳴器警報
'\b' # 退格
'\e' # 跳脫
'\f' # 換頁
'\n' # 換行
'\r' # 回車
'\t' # tab
'\v' # 垂直 tab
'\uNNNN' # 十六進位萬國碼字元
'\u{NNNN...}' # 十六進位萬國碼字元
```

我們可以使用反斜線搭配一個 *u* 來表達萬國碼碼位。可以後面跟著 4 個十六進位數字或是使用大括號（`{}`）括住*最多 6 個*十六進位數字（從 0 到 10FFFF）來表達：

```crystal
'\u0041' # => 'A'
'\u{41}' # => 'A'
'\u{1F52E}' # => '&#x1F52E;'
```

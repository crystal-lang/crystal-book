# 字元

字元（[Char](http://crystal-lang.org/api/Char.html)）表達一個[萬國碼<small>(Unicode)</small>](http://zh.wikipedia.org/wiki/Unicode)的[編碼位置<small>(Code point)</small>](https://zh.wikipedia.org/wiki/碼位)。以二進位表達時佔用 32 位元。

以一對單引號來括住一個 UTF-8 文字來表達一個字元常值：

```crystal
'a'
'z'
'0'
'_'
'あ'
```

我們可以使用反斜線（`\`）表示某些字元：

```crystal
'\'' # 單引號
'\\' # 反斜線
'\e' # 跳脫
'\f' # 換頁
'\n' # 換行
'\r' # 回車
'\t' # tab
'\v' # 垂直tab
```

我們可以使用反斜線搭配*最多 3 個*數字表達 8 進位編碼的字元：

```crystal
'\101' # == 'A'
'\123' # == 'S'
'\12'  # == '\n'
'\1'   # 編碼位置 1
```

我們可以使用反斜線搭配一個 *u* 跟著 4 個十六進位數字來表達一個萬國碼碼位：

```crystal
'\u0041' # == 'A'
```

或者，也可以用大括號（`{}`）括住*最多 6 個*十六進位數字（從 0 到 10FFFF）來表達：

```crystal
'\u{41}'    # == 'A'
'\u{1F52E}' # == '🔮'
```

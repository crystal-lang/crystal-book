# 字元

[字元(Char)](http://crystal-lang.org/api/Char.html) 表達一個 [萬國碼(Unicode)](http://zh.wikipedia.org/wiki/Unicode) [編碼位置(code point)](https://zh.wikipedia.org/wiki/碼位)。
它佔用 32 位元。

它是由被單引號所夾住的 UTF-8 字元所創造。

```crystal
'a'
'z'
'0'
'_'
'あ'
```

你可以使用反斜線(backslash)表示某些字元:

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

你可以使用反斜線搭配最多3個數字表達8進位編碼的字元:

```crystal
'\101' # == 'A'
'\123' # == 'S'
'\12'  # == '\n'
'\1'   # 編碼位置 1
```

你可以使用反斜線搭配一個 *u* 還有4個十六進位字元表達萬國碼編碼:

```crystal
'\u0041' # == 'A'
```

或者你可以用大括號夾住指定的最多6個十六進位數字(0 到 10FFFF):

```crystal
'\u{41}'    # == 'A'
'\u{1F52E}' # == '🔮'
```

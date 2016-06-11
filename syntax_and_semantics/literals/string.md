# 字串 <small>String</small>

字串（[String](http://crystal-lang/api/String.html)）相當於一組不可變<small>(Immutable)</small>的 UTF-8 字元序列。

字串通常由字串常值來表達——即由一對雙引號(`"`)括住數個 UTF-8 字元：

```crystal
"hello world"
```

如同[字元](./char.md)，反斜線(`\`)也可以拿來表達一些特定的字元：

```crystal
"\"" # 雙引號
"\\" # 反斜線
"\e" # 跳脫
"\f" # 換頁
"\n" # 換行
"\r" # 輸入鍵 (Enter)
"\t" # Tab
"\v" # 垂直 Tab
```

你也可以使用反斜線搭配*最多 3 個*數字表達 8 進位編碼的字元：

```crystal
"\101" # == "A"
"\123" # == "S"
"\12"  # == "\n"
"\1"   # 包含一個編碼位置 1 之字元的字串
```

你還可以使用反斜線搭配一個 *u* 跟著 4 個十六進位數字來表達一個萬國碼碼位：

```crystal
"\u0041" # == "A"
```

當然，你也可以用大括號（`{}`）括住*最多 6 個*十六進位數字（從 0 到 10FFFF）來表達一個萬國碼碼位：

```crystal
"\u{41}"    # == "A"
"\u{1F52E}" # == "🔮"
```

字串能夠橫跨多行文字：

```crystal
"hello
      world" # 相當於 "hello\n      world"
```

注意上面的例子中，我們可以看到產生的字串中包含了換行以及空白。

如果想要避免產生換行及空白，但還是想要將字串切割成好幾行表達的話，可以使用反斜線來串聯各個部分：

```crystal
"hello " \
"world, " \
"no newlines" # 相當於 "hello world, no newlines"
```

或是你也可以將反斜線直接插在字串裡面：

```crystal
"hello \
     world, \
     no newlines" # 相當於 "hello world, no newlines"
```

在這個範例中，我們可以看到行首空白是**不會**被包含在字串中的。

如果你需要在字串中大量的使用雙引號時，可以改用括號來表達字串：

```crystal
# 支援在字串中直接使用雙引號以及嵌套的小括號
%(hello ("world")) # 相當於 "hello (\"world\")"

# 支援在字串中直接使用雙引號以及嵌套的中括號
%[hello ["world"]] # 相當於 "hello [\"world\"]"

# 支援在字串中直接使用雙引號以及嵌套的大括號
%{hello {"world"}} # 相當於 "hello {\"world\"}"

# 支援在字串中直接使用雙引號以及嵌套的角括號
%<hello <"world">> # 相當於 "hello <\"world\">"
```

## Heredoc

你也可以使用「[Heredoc](https://zh.wikipedia.org/zh-tw/Here文檔)」來建立字串：

```crystal
<<-XML
<parent>
  <child />
</parent>
XML
```

一個 Heredoc 起始於 `<<-IDENT`，`IDENT` 是一個標識符（由字母開頭且只包含字母與數字），並結束於開頭為 `IDENT` 的某行（略過行首空白）。

與結束標識符之相同數量的行首空白將自動被忽略。如：

```crystal
# 相當於 "  Hello\n    world"
<<-STRING
  Hello
    world
STRING

# 相當於 "Hello\n  world"
<<-STRING
  Hello
    world
  STRING

# 相當於 "  Hello\n    world"
<<-STRING
    Hello
      world
  STRING
```

## 內插表達式

建立字串時，你可以使用內插表達式來混合並嵌入表達式。

```crystal
a = 1
b = 2
"sum = #{a + b}"        # "sum = 3"
```

每個內插表達式（`#{...}`）內的的值都會被呼叫 `Object#to_s(IO)` 來取得要填入的字串。

## 忽略跳脫字元以及內插表達式

你也可以使用 `%q` 來建立不執行跳脫字元以及內插表達式的字串：

```crystal
%q(hello \n #{world}) # => "hello \\n \#{world}"
```

所使用的括號也可以替換成 `{}`、`[]` 以及 `<>`。

同時，只要將 Heredoc 的標識符用單引號（`'`）括起就能不執行跳脫及內插：

```crystal
# 相當於 "hello \\n \#{world}"
<<-'HERE'
hello \n #{world}
HERE
```

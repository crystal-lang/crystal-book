# 字串 <small>String</small>

字串（[String](http://crystal-lang/api/String.html)）相當於一組不可變<small>(Immutable)</small>的 UTF-8 字元序列。

字串通常由字串常值來表達——即由一對雙引號（`"`）括住數個 UTF-8 字元：

```crystal
"hello world"
```

## 跳脫字元

如同[字元](./char.md)，反斜線（`\`）也可以拿來表達一些特定的字元：

```crystal
"\"" # 雙引號
"\\" # 反斜線
"\a" # 蜂鳴器警報
"\b" # 退格
"\e" # 跳脫
"\f" # 換頁
"\n" # 換行
"\r" # 輸入鍵 (Enter)
"\t" # Tab
"\v" # 垂直 Tab
"\NNN" # 八進位 ASCII 字元
"\xNN" # 十六進位 ASCII 字元
"\uNNNN" # 十六進位萬國碼字元
"\u{NNNN...}" # 十六進位萬國碼字元
```

其他接在反斜線後方的跳脫字元都表示該字元本身。

我們也可以使用反斜線搭配*最多 3 個*數字表達 8 進位編碼的字元：

```crystal
"\101" # => "A"
"\123" # => "S"
"\12"  # => "\n"
"\1"   # 包含一個編碼位置 1 之字元的字串
```

我們還可以使用反斜線搭配一個 *u* 來表達萬國碼碼位。後面跟著 4 個十六進位數字或是使用大括號（`{}`）括住*最多 6 個*十六進位數字（從 0 到 10FFFF）來表達：

```crystal
"\u0041"    # => "A"
"\u{41}"    # => "A"
"\u{1F52E}" # => "&#x1F52E;"
```

同時，使用大括號的時候可以同時表達多個文字：

```crystal
"\u{48 45 4C 4C 4F}" # => "HELLO"
```

## 內插表達式

建立字串時，你可以使用內插表達式來混合並嵌入表達式。

```crystal
a = 1
b = 2
"sum: #{a} + #{b} = #{a + b}" # => "sum: 1 + 2 = 3"
```

字串也可以透過 [String#%](https://crystal-lang.org/api/master/String.html#%25%28other%29-instance-method) 方法來執行插值。

任何表達式都可以被放置於插值區塊中，但儘量保持插值表達式越短越能夠能保持可讀性。

我們可以透過跳脫 `#` 符號來避免被插值，或是使用 `%q()` 也可以避免被插值。

```crystal
"\#{a + b}"  # => "#{a + b}"
%q(#{a + b}) # => "#{a + b}"
```

內插表達式以 [String::Builder](http://crystal-lang.org/api/String/Builder.html) 實作，每個表達式（`#{...}`）內的的值都會呼叫 `Object#to_s(IO)` 來取得要填入的字串。
表達式 `"sum: #{a} + #{b} = #{a + b}"` 等義於：

```crystal
String.build do |io|
  io << "sum: "
  io << a
  io << " + "
  io << b
  io << " = "
  io << a + b
end
```

# 百分比字串常值表示法

除了使用雙引號來表達字串以外，Crystal 亦支援使用百分比符號（`%`）及成對的符號相夾來表示。
合法的符號為小括號（`()`）、中括號（`[]`）、大括號（`{}`）、角括號（`<>`）以及垂直條（`|`）。
除了垂直條，其他的符號都可以在字串中成對使用而不會結束字串。

字串中需要使用雙引號時，就可以使用這個方法來避免使用跳脫字元：

```crystal
%(hello ("world")) # => "hello (\"world\")"
%[hello ["world"]] # => "hello [\"world\"]"
%{hello {"world"}} # => "hello {\"world\"}"
%<hello <"world">> # => "hello <\"world\">"
%|hello "world"|   # => "hello \"world\""
```

此外，使用 `%q` 可以避免字串被插值或跳脫，而 `%Q` 與 `%` 等義。

```crystal
name = "world"
%q(hello \n #{name}) # => "hello \\n \#{name}"
%Q(hello \n #{name}) # => "hello \n world"
```

## 多行字串

字串能夠橫跨多行文字：

```crystal
"hello
      world" # => "hello\n      world"
```

注意上面的例子中，我們可以看到產生的字串中包含了換行以及空白。

如果想要避免產生換行及空白，但還是想要將字串切割成好幾行表達的話，可以使用反斜線來串聯各個部分：

```crystal
"hello " \
"world, " \
"no newlines" # => "hello world, no newlines"
```

或是我們也可以將反斜線直接插在字串裡面：

```crystal
"hello \
     world, \
     no newlines" # => "hello world, no newlines"
```

在這個範例中，我們可以看到行首空白是**不會**被包含在字串中的。

## Heredoc

當建立多行字串的時候，我們也可以使用「[Heredoc](https://zh.wikipedia.org/zh-tw/Here文檔)」來協助我們。
一個 Heredoc 起始於 `<<-IDENT`，`IDENT` 是一個標識符（由字母開頭且只包含字母與數字），並結束於開頭為 `IDENT` 的某行（略過行首空白）。
後方可以直接接著非字母的字元（如 `.`, `)`）來方便對 Heredoc 呼叫方法或用來關閉成對的括號。

```crystal
<<-XML
<parent>
  <child />
</parent>
XML
```

與結束標識符之相同數量的行首空白將自動被忽略。如：

```crystal
<<-STRING
  Hello
    world
STRING # => "Hello\n  world"

<<-STRING
    Hello
      world
  STRING # => "  Hello\n    world"
```

我們可以在 Heredoc 結束後直接呼叫方法，或是將其置於括號中：

```crystal
<<-SOME
hello
SOME.upcase # => "HELLO"

def upcase(string)
  string.upcase
end

upcase(<<-SOME
  hello
  SOME) # => "HELLO"
```

在 Heredoc 中亦支援跳脫及內插表達式。

同時，只要將 Heredoc 的標識符用單引號（`'`）括起就能不執行跳脫及內插：

```crystal
<<-'HERE'
  hello \n #{world}
  HERE # => "hello \n #{world}"
```

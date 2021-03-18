# String

A [String](https://crystal-lang.org/api/latest/String.html) represents an immutable sequence of UTF-8 characters.

A String is typically created with a string literal enclosing UTF-8 characters in double quotes (`"`):

```crystal
"hello world"
```

## Escaping

A backslash denotes a special character inside a string, which can either be a named escape sequence or a numerical representation of a unicode codepoint.

Available escape sequences:

```crystal
"\""                  # double quote
"\\"                  # backslash
"\a"                  # alert
"\b"                  # backspace
"\e"                  # escape
"\f"                  # form feed
"\n"                  # newline
"\r"                  # carriage return
"\t"                  # tab
"\v"                  # vertical tab
"\377"                # octal ASCII character
"\xFF"                # hexadecimal ASCII character
"\uFFFF"              # hexadecimal unicode character
"\u{0}".."\u{10FFFF}" # hexadecimal unicode character
```

Any other character following a backslash is interpreted as the character itself.

A backslash followed by at most three digits ranging from 0 to 7 denotes a code point written in octal:

```crystal
"\101" # => "A"
"\123" # => "S"
"\12"  # => "\n"
"\1"   # string with one character with code point 1
```

A backslash followed by a `u` denotes a unicode codepoint. It can either be followed by exactly four hexadecimal characters representing the unicode bytes (`\u0000` to `\uFFFF`) or a number of one to six hexadecimal characters wrapped in curly braces (`\u{0}` to `\u{10FFFF}`.

```crystal
"\u0041"    # => "A"
"\u{41}"    # => "A"
"\u{1F52E}" # => "&#x1F52E;"
```

One curly brace can contain multiple unicode characters each separated by a whitespace.

```crystal
"\u{48 45 4C 4C 4F}" # => "HELLO"
```

## Interpolation

A string literal with interpolation allows to embed expressions into the string which will be expanded at runtime.

```crystal
a = 1
b = 2
"sum: #{a} + #{b} = #{a + b}" # => "sum: 1 + 2 = 3"
```

String interpolation is also possible with [String#%](https://crystal-lang.org/api/latest/String.html#%25%28other%29-instance-method).

Any expression may be placed inside the interpolated section, but it’s best to keep the expression small for readability.

Interpolation can be disabled by escaping the `#` character with a backslash or by using a non-interpolating string literal like `%q()`.

```crystal
"\#{a + b}"  # => "#{a + b}"
%q(#{a + b}) # => "#{a + b}"
```

Interpolation is implemented using a [String::Builder](https://crystal-lang.org/api/latest/String/Builder.html) and invoking `Object#to_s(IO)` on each expression enclosed by `#{...}`. The expression `"sum: #{a} + #{b} = #{a + b}"` is equivalent to:

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

## Percent string literals

Besides double-quotes strings, Crystal also supports string literals indicated by a percent sign (`%`) and a pair of delimiters. Valid delimiters are parentheses `()`, square brackets `[]`, curly braces `{}`, angles `<>` and pipes `||`. Except for the pipes, all delimiters can be nested meaning a start delimiter inside the string escapes the next end delimiter.

These are handy to write strings that include double quotes which would have to be escaped in double-quoted strings.

```crystal
%(hello ("world")) # => "hello (\"world\")"
%[hello ["world"]] # => "hello [\"world\"]"
%{hello {"world"}} # => "hello {\"world\"}"
%<hello <"world">> # => "hello <\"world\">"
%|hello "world"|   # => "hello \"world\""
```

A literal denoted by `%q` does not apply interpolation nor escapes while `%Q` has the same meaning as `%`.

```crystal
name = "world"
%q(hello \n #{name}) # => "hello \\n \#{name}"
%Q(hello \n #{name}) # => "hello \n world"
```

### Percent string array literal

Besides the single string literal, there is also a percent literal to create an [Array](https://crystal-lang.org/api/latest/Array.html) of strings. It is indicated by `%w` and a pair of delimiters. Valid delimiters are as same as [percent string literals](#percent-string-literals).

```crystal
%w(foo bar baz)  # => ["foo", "bar", "baz"]
%w(foo\nbar baz) # => ["foo\\nbar", "baz"]
%w(foo(bar) baz) # => ["foo(bar)", "baz"]
```

Note that literal denoted by `%w` does not apply interpolation nor escapes except spaces. Since strings are separated by a single space character (` `) which must be escaped to use it as a part of a string.

```crystal
%w(foo\ bar baz) # => ["foo bar", "baz"]
```

## Multiline strings

Any string literal can span multiple lines:

```crystal
"hello
      world" # => "hello\n      world"
```

Note that in the above example trailing and leading spaces, as well as newlines,
end up in the resulting string. To avoid this a string can be split into multiple lines
by joining multiple literals with a backslash:

```crystal
"hello " \
"world, " \
"no newlines" # same as "hello world, no newlines"
```

Alternatively, a backslash followed by a newline can be inserted inside the string literal:

```crystal
"hello \
     world, \
     no newlines" # same as "hello world, no newlines"
```

In this case, leading whitespace is not included in the resulting string.

## Heredoc

A *here document* or *heredoc* can be useful for writing strings spanning over multiple lines.
A heredoc is denoted by `<<-` followed by an heredoc identifier which is an alphanumeric sequence starting with a letter (and may include underscores). The heredoc starts in the following line and ends with the next line that contains *only* the heredoc identifier, optionally preceeded by whitespace.

```crystal
<<-XML
<parent>
  <child />
</parent>
XML
```

Leading whitespace is removed from the heredoc contents according to the number of whitespace in the last line before the heredoc identifier.

```crystal
<<-STRING # => "Hello\n  world"
  Hello
    world
  STRING

<<-STRING # => "  Hello\n    world"
    Hello
      world
  STRING
```

After the heredoc identifier, and in that same line, anything that follows continues the original expression that came before the heredoc. It's as if the end of the starting heredoc identifier is the end of the string. However, the string contents come in subsequent lines until the ending heredoc idenfitier which must be on its own line.

```crystal
<<-STRING.upcase # => "HELLO"
hello
STRING

def upcase(string)
  string.upcase
end

upcase(<<-STRING) # => "HELLO WORLD"
  Hello World
  STRING
```

If multiple heredocs start in the same line, their bodies are read sequentially:

```crystal
print(<<-FIRST, <<-SECOND) # prints "HelloWorld"
  Hello
  FIRST
  World
  SECOND
```

A heredoc generally allows interpolation and escapes.

To denote a heredoc without interpolation or escapes, the opening heredoc identifier is enclosed in single quotes:

```crystal
<<-'HERE' # => "hello \\n \#{world}"
  hello \n #{world}
  HERE
```

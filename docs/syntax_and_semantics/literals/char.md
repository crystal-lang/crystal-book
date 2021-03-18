# Char

A [Char](https://crystal-lang.org/api/latest/Char.html) represents a 32-bit [Unicode](http://en.wikipedia.org/wiki/Unicode) [code point](http://en.wikipedia.org/wiki/Code_point).

It is typically created with a char literal by enclosing an UTF-8 character in single quotes.

```crystal
'a'
'z'
'0'
'_'
'あ'
```

A backslash denotes a special character, which can either be a named escape sequence or a numerical representation of a unicode codepoint.

Available escape sequences:

```crystal
'\''         # single quote
'\\'         # backslash
'\a'         # alert
'\b'         # backspace
'\e'         # escape
'\f'         # form feed
'\n'         # newline
'\r'         # carriage return
'\t'         # tab
'\v'         # vertical tab
'\uFFFF'     # hexadecimal unicode character
'\u{10FFFF}' # hexadecimal unicode character
```

A backslash followed by a `u` denotes a unicode codepoint. It can either be followed by exactly four hexadecimal characters representing the unicode bytes (`\u0000` to `\uFFFF`) or a number of one to six hexadecimal characters wrapped in curly braces (`\u{0}` to `\u{10FFFF}`.

```crystal
'\u0041'    # => 'A'
'\u{41}'    # => 'A'
'\u{1F52E}' # => '&#x1F52E;'
```

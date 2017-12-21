# Char

A [Char](http://crystal-lang.org/api/Char.html) represents a [Unicode](http://en.wikipedia.org/wiki/Unicode) [code point](http://en.wikipedia.org/wiki/Code_point).
It occupies 32 bits.

It is created by enclosing an UTF-8 character in single quotes.

```crystal
'a'
'z'
'0'
'_'
'あ'
```

You can use a backslash to denote some special characters:

```crystal
'\'' # single quote
'\\' # backslash
'\e' # escape
'\f' # form feed
'\n' # newline
'\r' # carriage return
'\t' # tab
'\v' # vertical tab
```

You can use a backslash followed by a *u* and four hexadecimal characters to denote a unicode codepoint written:

```crystal
'\u0041' # == 'A'
```

Or you can use curly braces and specify up to six hexadecimal numbers (0 to 10FFFF):

`'\u{41}'` equals `A` and `'\u{1F52E}'` equals &#x1F52E;.

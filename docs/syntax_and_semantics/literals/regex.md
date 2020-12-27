# Regular Expressions

Regular expressions are represented by the [Regex](http://crystal-lang.org/api/Regex.html) class.

A Regex is typically created with a regex literal using [PCRE](http://pcre.org/pcre.txt) syntax. It consists of a string of UTF-8 characters enclosed in forward slashes (`/`):

```crystal
/foo|bar/
/h(e+)llo/
/\d+/
/あ/
```

## Escaping

Regular expressions support the same [escape sequences as String literals](./string.md).

```crystal
/\//         # slash
/\\/         # backslash
/\b/         # backspace
/\e/         # escape
/\f/         # form feed
/\n/         # newline
/\r/         # carriage return
/\t/         # tab
/\v/         # vertical tab
/\NNN/       # octal ASCII character
/\xNN/       # hexadecimal ASCII character
/\x{FFFF}/   # hexadecimal unicode character
/\x{10FFFF}/ # hexadecimal unicode character
```

The delimiter character `/` must be escaped inside slash-delimited regular expression literals.
Note that special characters of the PCRE syntax need to be escaped if they are intended as literal characters.

## Interpolation

Interpolation works in regular expression literals just as it does in [string literals](./string.md). Be aware that using this feature will cause an exception to be raised at runtime, if the resulting string results in an invalid regular expression.

## Modifiers
The closing delimiter may be followed by a number of optional modifiers to adjust the matching behaviour of the regular expression.

* `i`: case-insensitive matching (`PCRE_CASELESS`):  Unicode letters in the pattern match both upper and lower case letters in the subject string.
* `m`: multiline matching (`PCRE_MULTILINE`): The *start of line* (`^`) and *end of line* (`$`) metacharacters match immediately following or immediately before internal newlines in the subject string, respectively, as well as at the very start and end.
* `x`: extended whitespace matching (`PCRE_EXTENDED`): Most white space characters in the pattern are totally ignored except when ignore or inside a character class. Unescaped hash characters `#` denote the start of a comment ranging to the end of the line.

```crystal
/foo/i.match("FOO")         # => #<Regex::MatchData "FOO">
/foo/m.match("bar\nfoo")    # => #<Regex::MatchData "foo">
/foo /x.match("foo")        # => #<Regex::MatchData "foo">
/foo /imx.match("bar\nFOO") # => #<Regex::MatchData "FOO">
```

## Percent regex literals

Besides slash-delimited literals, regular expressions may also be expressed as a percent literal indicated by `%r` and a pair of delimiters. Valid delimiters are parentheses `()`, square brackets `[]`, curly braces `{}`, angles `<>` and pipes `||`. Except for the pipes, all delimiters can be nested; meaning a start delimiter inside the literal escapes the next end delimiter.

These are handy to write regular expressions that include slashes which would have to be escaped in slash-delimited literals.

```crystal
%r((/)) # => /(\/)/
%r[[/]] # => /[\/]/
%r{{/}} # => /{\/}/
%r<</>> # => /<\/>/
%r|/|   # => /\//
```

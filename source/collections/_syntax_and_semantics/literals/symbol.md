---
title: Symbol
---

A [Symbol](http://crystal-lang.org/api/Symbol.html) represents a unique name inside the entire source code.

Symbols are interpreted at compile time and cannot be created dynamically. The only way to create a Symbol is by using a symbol literal, denoted by a colon (`:`) followed by an identifier. The identifier may optionally be enclosed in double quotes (`"`).

```crystal
:unquoted_symbol
:"quoted symbol"
:"a" # identical to :a
```

A double-quoted identifier can contain any unicode character including white spaces and accepts the same escape sequences as a [string literal](./string.html), yet no interpolation.

For an unquoted identifier the same naming rules apply as for methods. It can contain alphanumeric characters, underscore (`_`) or characters with a code point greater than `159`(`0x9F`). It must not start with a number and may end with an exclamation mark (`!`) or question mark (`?`).

```crystal
:question?
:exclamation!
```

All [Crystal operators](../operators.html) can be used as symbol names unquoted:
```crystal
:+
:-
:*
:/
:%
:&
:|
:^
:**
:>>
:<<
:==
:!=
:<
:<=
:>
:>=
:<=>
:===
:[]
:[]?
:[]=
:!
:~
:!~
:=~
```

Internally, symbols are implemented as constants with a numeric value of type `Int32`.

## Percent symbol array literal

Besides the single symbol literal, there is also a percent literal to create an [Array](https://crystal-lang.org/api/Array.html) of symbols. It is indicated by `%i` and a pair of delimiters. Valid delimiters are parentheses `()`, square brackets `[]`, curly braces `{}`, angles `<>` and pipes `||`. Except for the pipes, all delimiters can be nested; meaning a start delimiter inside the string escapes the next end delimiter.

```crystal
%i(foo bar baz) # => [:foo, :bar, :baz]
%i(foo\nbar baz) # => [:"foo\nbar", :baz]
%i(foo(bar) baz) # => [:"foo(bar)", :baz]
```

Identifiers may contain any unicode characters. Individual symbols are separated by a single space character (` `) which must be escaped to use it as a part of an identifier.

```crystal
%i(foo\ bar baz) # => [:"foo bar", :baz]
```

# Symbol

A [Symbol](http://crystal-lang.org/api/Symbol.html) represents a unique name inside the entire source code.
It is internally implemented as a constant with a numeric value of type `Int32`.

Symbols are interpreted at compile time and cannot be created dynamically. The only way to create a Symbol is by using a symbol literal, denoted by a colon (`:`) followed by an identifier. The identifier may be enclosed in double quotes (`"`).

An unquoted identifier can contain alphanumeric characters, underscore (`_`) or characters with a code point greater than `159`(`0x9F`). It must not start with a number and may end with an exclamation mark (`!`) or question mark (`?`).

A double-quoted identifier can contain any unicode character including white spaces and accepts the same escape sequences as a [string literal](./string.html), yet no interpolation.


```crystal
:hello
:good_bye

# With spaces and symbols
:"symbol with spaces"

# Ending with question and exclamation marks
:question?
:exclamation!

# For the operators
:+
:-
:*
:/
:==
:<
:<=
:>
:>=
:!
:!=
:=~
:!~
:&
:|
:^
:~
:**
:>>
:<<
:%
:[]
:[]?
:[]=
:<=>
:===
```

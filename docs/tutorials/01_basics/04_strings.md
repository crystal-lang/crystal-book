# String Operations

In the previous lessons we have already made an acquaintance with a major building block
of most programs: strings. Let's recapitulate the basic properties:

A [string](https://en.wikipedia.org/wiki/String_(computer_science)) is a sequence of [Unicode](https://en.wikipedia.org/wiki/Unicode) characters encoded in [UTF-8](https://en.wikipedia.org/wiki/UTF-8).
A string is [immutable](https://en.wikipedia.org/wiki/Immutable_object):
If you apply a modification to a string, you actually get a new string with the
modified content. The original string stays the same.

Strings are written as literals typically enclosed in double quote characters (`"`).

## Interpolation

String interpolation is a convenient method for combining strings: `#{...}` inside a string literal inserts the value of the expression between the curly braces at this position of the string.

```{.crystal .crystal-play}
name = "Crystal"
puts "Hello #{name}"
```

The expression inside an interpolation should be kept short to either a variable or a simple method call. More complex expressions reduce code readability.

The value of the expression doesn't need to be a string. Any type will do and it gets converted to a string representation by calling the `#to_s` method. This method is defined for any object. Let's try with a number:

```{.crystal .crystal-play}
name = 6
puts "Hello #{name}!"
```

!!! note
    An alternative to interpolation is concatenation. Instead of `"Hello #{name}!"` you could write `"Hello " + name + "!"`. But that's bulkier and has some gotchas with non-string types. Interpolation is generally preferred over concatenation.

## Escaping

Some characters can't be written directly in string literals. For example a double quote: If used inside a string, the compiler would interpret it as the end delimiter.

The solution to this problem is escaping: If a double quote is preceded by a backslash (`\`), it's interpreted as an escape sequence and both characters together encode a double quote character.

```{.crystal .crystal-play}
puts "I say: \"Hello World!\""
```

There are other escape sequences: For example non printable characters such as a line break (`\n`) or a tabulator (`\t`). If you want to write a literal backslash, the escape sequence is a double backslash (`\\`). The null character (codepoint `0`) is a regular character in Crystal strings. In some programming languages this character denotes the end of a string, but in Crystal it's only determined by its `#size` property.

```{.crystal .crystal-play}
puts "I say: \"Hello \\\n\tWorld!\""
```

!!! tip
    You can find more info on available escape sequences in the [string literal reference](../../syntax_and_semantics/literals/string.md#escaping).

### Alternative Delimiters

Some string literals may contain a lot of double quotes – think of HTML tags with quoted argument values for example. It would be cumbersome to have to escape each one with a backslash. Alternative literal delimiters are a convenient alternative. `%(...)` is equivalent to `"..."` except that the delimiters are denoted by parentheses (`(` and `)`) instead of double quotes.

```{.crystal .crystal-play}
puts %(I say: "Hello World!")
```

Escape sequences and interpolation still works the same way.

!!! tip
    You can find more info on alternative delimiters in the [string literal reference](../../syntax_and_semantics/literals/string.md#percent-string-literals).

## Unicode

Unicode is an international standard for representing text in many different writing systems. Besides letters of the latin alphabet used by English and many other languages, it includes several other character sets. Not just for plain text, but the Unicode standard also includes emojis and icons.

The following example uses the unicode character [`U+1F310` (*Globe with Meridians*)](https://codepoints.net/U+1F310) to address the world:

```{.crystal .crystal-play}
puts "Hello 🌐"
```

Working with unicode symbols can be a bit tricky sometimes. Some characters may not be supported by your editor font, some characters are not even printable. As an alternative, Unicode characters can be expressed as an escape sequence. A backslash followed by the letter `u` denotes a Unicode codepoint. The codepoint value is written as hexadecimal digits enclosed in curly braces. The curly braces can be omitted if the codepoint has exactly four digits.

```{.crystal .crystal-play}
puts "Hello \u{1F310}"
```

## Transformation

Consider you want to change something about a string. Maybe scream the message and make it all uppercase?
The method `String#upcase` converts all lower case characters to their upper case equivalent.
The opposite is `String#downcase`. There are a couple more similar methods, which let us express our message in different
styles:

```{.crystal .crystal-play}
message = "Hello World! Greetings from Crystal."

puts "normal: #{message}"
puts "upcased: #{message.upcase}"
puts "downcased: #{message.downcase}"
puts "camelcased: #{message.camelcase}"
puts "capitalized: #{message.capitalize}"
puts "reversed: #{message.reverse}"
puts "titleized: #{message.titleize}"
puts "underscored: #{message.underscore}"
```

The methods `#camelcased` and `#underscored` don't change our string, but try them with `"snake_cased"` or `"CamelCased"`.

## Information

Let's look a bit more detailed at a string and what we can know about it. First of all, a string
has a length, i.e. the number of characters it contains. This value is available as `String#size`.


```{.crystal .crystal-play}
message = "Hello World! Greetings from Crystal."

p! message.size
```

To determine if a string is empty, you can check if the size is zero, or just use the short hand `String#empty?`:

```{.crystal .crystal-play}
empty_string = ""

p! empty_string.size == 0,
   empty_string.empty?
```

The method `String#blank?` returns `true` if the string is empty or if it contains only of whitespace characters. A related method is `String#presence` which returns `nil` if the string is blank, otherwise the string itself.

```{.crystal .crystal-play}
blank_string = ""

p! blank_string.blank?,
   blank_string.presence
```

## Parts of a string



## Dissection

## Comparison

## Regex (?)

## Iteration (?)

!!! tip
    You can find more detailed info in the [string literal reference](../../syntax_and_semantics/literals/string.md) and [String API docs](https://crystal-lang.org/api/latest/String.html).

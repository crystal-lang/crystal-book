# Strings

In the previous lessons, we have already made an acquaintance with a major building block
of most programs: strings. Let's recapitulate the basic properties:

A [string](https://en.wikipedia.org/wiki/String_(computer_science)) is a sequence of [Unicode](https://en.wikipedia.org/wiki/Unicode) characters encoded in [UTF-8](https://en.wikipedia.org/wiki/UTF-8).
A string is [immutable](https://en.wikipedia.org/wiki/Immutable_object):
If you apply a modification to a string, you actually get a new string with the
modified content. The original string stays the same.

Strings are written as literals typically enclosed in double-quote characters (`"`).

## Interpolation

String interpolation is a convenient method for combining strings: `#{...}` inside a string literal inserts the value of the expression between the curly braces at this position of the string.

```crystal-play
name = "Crystal"
puts "Hello #{name}"
```

The expression inside an interpolation should be kept short to either a variable or a simple method call. More complex expressions reduce code readability.

The value of the expression doesn't need to be a string. Any type will do and it gets converted to a string representation by calling the `#to_s` method. This method is defined for any object. Let's try with a number:

```crystal-play
name = 6
puts "Hello #{name}!"
```

NOTE:
An alternative to interpolation is concatenation. Instead of `"Hello #{name}!"` you could write `"Hello " + name + "!"`. But that's bulkier and has some gotchas with non-string types. Interpolation is generally preferred over concatenation.

## Escaping

Some characters can't be written directly in string literals. For example a double quote: If used inside a string, the compiler would interpret it as the end delimiter.

The solution to this problem is escaping: If a double quote is preceded by a backslash (`\`), it's interpreted as an escape sequence and both characters together encode a double quote character.

```crystal-play
puts "I say: \"Hello World!\""
```

There are other escape sequences: For example non-printable characters such as a line break (`\n`) or a tabulator (`\t`). If you want to write a literal backslash, the escape sequence is a double backslash (`\\`). The null character (codepoint `0`) is a regular character in Crystal strings. In some programming languages, this character denotes the end of a string. But in Crystal, it's only determined by its `#size` property.

```crystal-play
puts "I say: \"Hello \\\n\tWorld!\""
```

TIP: You can find more info on available escape sequences in the [string literal reference](../../syntax_and_semantics/literals/string.md#escaping).

### Alternative Delimiters

Some string literals may contain a lot of double quotes – think of HTML tags with quoted argument values for example. It would be cumbersome to have to escape each one with a backslash. Alternative literal delimiters are a convenient alternative. `%(...)` is equivalent to `"..."` except that the delimiters are denoted by parentheses (`(` and `)`) instead of double quotes.

```crystal-play
puts %(I say: "Hello World!")
```

Escape sequences and interpolation still work the same way.

TIP: You can find more info on alternative delimiters in the [string literal reference](../../syntax_and_semantics/literals/string.md#percent-string-literals).

## Unicode

Unicode is an international standard for representing text in many different writing systems. Besides letters of the latin alphabet used by English and many other languages, it includes many other character sets. Not just for plain text, but the Unicode standard also includes emojis and icons.

The following example uses the Unicode character [`U+1F310` (*Globe with Meridians*)](https://codepoints.net/U+1F310) to address the world:

```crystal-play
puts "Hello 🌐"
```

Working with Unicode symbols can be a bit tricky sometimes. Some characters may not be supported by your editor font, some characters are not even printable. As an alternative, Unicode characters can be expressed as an escape sequence. A backslash followed by the letter `u` denotes a Unicode codepoint. The codepoint value is written as hexadecimal digits enclosed in curly braces. The curly braces can be omitted if the codepoint has exactly four digits.

```crystal-play
puts "Hello \u{1F310}"
```

## Transformation

Let's say you want to change something about a string. Maybe scream the message and make it all uppercase?
The method `String#upcase` converts all lower case characters to their upper case equivalent.
The opposite is `String#downcase`. There are a couple more similar methods, which let us express our message in different
styles:

```crystal-play
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

The methods `#camelcase` and `#underscore` don't change this particular string, but try them with the inputs `"snake_cased"` or `"CamelCased"`.

## Information

Let's take a more detailed look at a string and what we can know about it. First of all, a string
has a length, i.e. the number of characters it contains. This value is available as `String#size`.


```crystal-play
message = "Hello World! Greetings from Crystal."

p! message.size
```

To determine if a string is empty, you can check if the size is zero, or just use the shorthand `String#empty?`:

```crystal-play
empty_string = ""

p! empty_string.size == 0,
  empty_string.empty?
```

The method `String#blank?` returns `true` if the string is empty or if it only contains whitespace characters. A related method is `String#presence` which returns `nil` if the string is blank, otherwise the string itself.

```crystal-play
blank_string = ""

p! blank_string.blank?,
  blank_string.presence
```

## Equality and Comparison

You can test two strings for equality with the equality operator (`==`) and compare them with the
comparison operator (`<=>`). Both compare the strings strictly character by character.
Remember, `<=>` returns an integer indicating the relationship between both operands,
and `==` returns `true` if the comparison results in `0`, i.e. both values compare equally.

There is however also a `#compare` method that offers case insensitive comparison.

```crystal-play
message = "Hello World!"

p! message == "Hello World",
  message == "Hello Crystal",
  message == "hello world",
  message.compare("hello world", case_insensitive: false),
  message.compare("hello world", case_insensitive: true)
```

## Partial Components

Sometimes it's not important to know whether a string matches another exactly, and you just want to
know if one string contains another. For example, let's check if the message is about Crystal using the
`#includes?` method.

```crystal-play
message = "Hello World!"

p! message.includes?("Crystal"),
  message.includes?("World")
```

Sometimes the beginning or end of a string are of particular interest. That's where the methods `#starts_with?` and `#ends_with?`
come into play.

```crystal-play
message = "Hello World!"

p! message.starts_with?("Hello"),
  message.starts_with?("Bye"),
  message.ends_with?("!"),
  message.ends_with?("?")
```

## Indexing Substrings

We can get even more detailed information on the position of a substring with the `#index` method.
It returns the index of the first character in the substring's first appearance.
The result `0` means the same as `starts_with?`.

```crystal-play
p! "Crystal is awesome".index("Crystal"),
  "Crystal is awesome".index("s"),
  "Crystal is awesome".index("aw")
```

The method has an optional `offset` argument that can be used to start searching from a different
position than the beginning of the string. This is useful when the substring may appear multiple times.

```crystal-play
message = "Crystal is awesome"

p! message.index("s"),
  message.index("s", offset: 4),
  message.index("s", offset: 10)
```

The method `#rindex` works the same, but it searches from the end of the string instead.

```crystal-play
message = "Crystal is awesome"

p! message.rindex("s"),
  message.rindex("s", 13),
  message.rindex("s", 8)
```

In case the substring is not found, the result is a special value called `nil`.
It means "no value". Which makes sense when the substring has no index.

Looking at the return type of `#index` we can see that it returns either `Int32` or `Nil`.

```crystal-play
a = "Crystal is awesome".index("aw")
p! a, typeof(a)
b = "Crystal is awesome".index("meh")
p! b, typeof(b)
```

TIP: We'll cover `nil` more deeply in the next lesson.

## Extracting Substrings

A substring is a part of a string. If you want to extract parts of the string,
there are several ways to do that.

The index accessor `#[]` allows referencing a substring by character index and size. Character
indices start at `0` and reach to length (i.e. the value of `#size`) minus one.
The first argument specifies the index of the first character that is supposed to be in the substring,
and the second argument specifies the length of the substring. `message[6, 5]` extracts a substring
of five characters long, starting at index six.

```crystal-play
message = "Hello World!"

p! message[6, 5]
```

Let's assume we have established that the string starts with `Hello` and ends with `!` and want to extract what's in
between.
If the message was `Hello Crystal`, we wouldn't get the entire word `Crystal` because it's longer than five characters.

A solution is to calculate the length of the substring from the length of the entire string minus the lengths of beginning and end.

```crystal-play
message = "Hello World!"

p! message[6, message.size - 6 - 1]
```

There's an easier way to do that: The index accessor can be used with a [`Range`](https://crystal-lang.org/api/Range.html)
of character indices. A range literal consists of a start value and an end value, connected by two dots (`..`).
The first value indicates the start index of the substring, as before, but the second is the end index (as opposed to the length).
Now we don't need to repeat the start index in the calculation because the end index is just the size minus two
(one for the end index, and one for excluding the last character).

It can be even easier: Negative index values automatically relate to the end of the string, so we don't need to calculate
the end index from the string size explicitly.

```crystal-play
message = "Hello World!"

p! message[6..(message.size - 2)],
  message[6..-2]
```

## Substitution

In a very similar manner, we can modify a string. Let's make sure we properly greet Crystal and nothing else.
Instead of accessing a substring, we call `#sub`. The first argument is again a range to indicate the location
that gets replaced by the value of the second argument.

```crystal-play
message = "Hello World!"

p! message.sub(6..-2, "Crystal")
```

The `#sub` method is very versatile and can be used in different ways. We could also pass a search string as the first argument
and it replaces that substring with the value of the second argument.

```crystal-play
message = "Hello World!"

p! message.sub("World", "Crystal")
```

`#sub` only replaces the first instance of a search string. Its big brother `#gsub` applies to all instances.

```crystal-play
message = "Hello World! How are you, World?"

p! message.sub("World", "Crystal"),
  message.gsub("World", "Crystal")
```

TIP: You can find more detailed info in the [string literal reference](../../syntax_and_semantics/literals/string.md) and [String API docs](https://crystal-lang.org/api/String.html).

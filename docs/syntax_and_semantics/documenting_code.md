# Documenting code

Documentation for API features can be written in code comments directly
preceding the definition of the respective feature.

By default, all public methods, macros, types and constants are
considered part of the API documentation.

TIP:
The compiler command [`crystal docs`](../man/crystal/README.md#crystal-docs)
automatically extracts the API documentation and generates a website to
present it.

## Association

Doc comments must be positioned directly above the definition of the
documented feature. Consecutive comment lines are combined into a single comment
block. Any empty line breaks the association to the documented feature.

```crystal
# This comment is not associated with the class.

# First line of documentation for class Unicorn.
# Second line of documentation for class Unicorn.
class Unicorn
end
```

## Format

Doc comments support [Markdown](https://daringfireball.net/projects/markdown/) formatting.

The first paragraph of a doc comment is considered its summary. It should concisely
define the purpose and functionality.

Supplementary details and usages instructions should follow in subsequent paragraphs.

For instance:

```crystal
# Returns the number of horns this unicorn has.
#
# Always returns `1`.
def horns
  1
end
```

TIP:
It is generally advised to use descriptive, third person present tense:
`Returns the number of horns this unicorn has` (instead of an imperative `Return the number of horns this unicorn has`).

## Markup

### Linking

References to other API features can be enclosed in single backticks. They are
automatically resolved and converted into links to the respective feature.

```crystal
class Unicorn
  # Creates a new `Unicorn` instance.
  def initialize
  end
end
```

The same lookup rules apply as in Crystal code. Features in the currently
documented namespace can be accessed with relative names:

* Instance methods are referenced with a hash prefix: `#horns`.
* Class methods are referenced with a dot prefix: `.new`.
* Constants and types are referenced by their name: `Unicorn`.

Features in other namespaces are referenced with the fully-qualified type path: `Unicorn#horns`, `Unicorn.new`, `Unicorn::CONST`.

Different overloads of a method can be identified by the full signature `.new(name)`, `.new(name, age)`.

### Parameters

When referring to parameters, it is recommended to write their name *italicized* (`*italicized*`):

```crystal
# Creates a unicorn with the specified number of *horns*.
def initialize(@horns = 1)
  raise "Not a unicorn" if @horns != 1
end
```

### Code Examples

Code examples can be placed in Markdown code blocks.
If no language tag is given, the code block is considered to be Crystal code.

```crystal
# Example:
# ```
# unicorn = Unicorn.new
# unicorn.horns # => 1
# ```
class Unicorn
end
```

To designate a code block as plain text, it must be explicitly tagged.

```crystal
# Output:
# ```plain
# "I'm a unicorn"
# ```
def say
  puts "I'm a unicorn"
end
```

Other language tags can also be used.

To show the value of an expression inside code blocks, use `# =>`.

```crystal
1 + 2             # => 3
Unicorn.new.speak # => "I'm a unicorn"
```

### Admonitions

Several admonition keywords are supported to visually highlight problems, notes and/or possible issues.

* `BUG`
* `DEPRECATED`
* `EXPERIMENTAL`
* `FIXME`
* `NOTE`
* `OPTIMIZE`
* `TODO`
* `WARNING`

Admonition keywords must be the first word in their respective line and must be in all caps. An optional trailing colon is preferred for readability.

```crystal
# Makes the unicorn speak to STDOUT
#
# NOTE: Although unicorns don't normally talk, this one is special
# TODO: Check if unicorn is asleep and raise exception if not able to speak
# TODO: Create another `speak` method that takes and prints a string
def speak
  puts "I'm a unicorn"
end

# Makes the unicorn talk to STDOUT
#
# DEPRECATED: Use `speak`
def talk
  puts "I'm a unicorn"
end
```

The compiler implicitly adds some admonitions to doc comments:

* The [`@[Deprecated]`](https://crystal-lang.org/api/Deprecated.html) annotation
  adds a `DEPRECATED` admonition.
* The [`@[Experimental]`](https://crystal-lang.org/api/Experimental.html) annotation
  adds an `EXPERIMENTAL` admonition.

## Directives

Directives tell the documentation generator how to treat documentation for a
specific feature.

### `ditto`

If two consecutively defined features have the same documentation, `:ditto:`
can be used to copy the same doc comment from the previous definition.

```crystal
# Returns the number of horns.
def horns
  horns
end

# :ditto:
def number_of_horns
  horns
end
```

The directive needs to be on a separate line but further documentation can be
added in other lines. The `:ditto:` directive is simply replaced by the content
of the previous doc comment.

### `nodoc`

Public features can be hidden from the API docs with the `:nodoc:` directive.
Private and protected features are always hidden.

```crystal
# :nodoc:
class InternalHelper
end
```

This directive needs to be the first line in a doc comment. Leading whitespace is
optional.
Following comment lines can be used for internal documentation.

### `inherit`

See [*Inheriting Documentation*](#Inheriting Documentation).

## Inheriting Documentation

When an instance method has no doc comment, but a method with the same signature exists in a parent type, the documentation is inherited from the parent method.

For example:

```crystal
abstract class Animal
  # Returns the name of `self`.
  abstract def name : String
end

class Unicorn < Animal
  def name : String
    "unicorn"
  end
end
```

The documentation for `Unicorn#name` would be:

```
Description copied from class `Animal`

Returns the name of `self`.
```

The child method can use `:inherit:` to explicitly copy the parent's documentation, without the `Description copied from ...` text.  `:inherit:` can also be used to inject the parent's documentation into additional documentation on the child.

For example:

```crystal
abstract class Parent
  # Some documentation common to every *id*.
  abstract def id : Int32
end

class Child < Parent
  # Some documentation specific to *id*'s usage within `Child`.
  #
  # :inherit:
  def id : Int32
    -1
  end
end
```

The documentation for `Child#id` would be:

```
Some documentation specific to *id*'s usage within `Child`.

Some documentation common to every *id*.
```

NOTE: Inheriting documentation only works on *instance*, non-constructor methods.

## A Complete Example

```crystal
# A unicorn is a **legendary animal** (see the `Legendary` module) that has been
# described since antiquity as a beast with a large, spiraling horn projecting
# from its forehead.
#
# To create a unicorn:
#
# ```
# unicorn = Unicorn.new
# unicorn.speak
# ```
#
# The above produces:
#
# ```text
# "I'm a unicorn"
# ```
#
# Check the number of horns with `#horns`.
class Unicorn
  include Legendary

  # Creates a unicorn with the specified number of *horns*.
  def initialize(@horns = 1)
    raise "Not a unicorn" if @horns != 1
  end

  # Returns the number of horns this unicorn has
  #
  # ```
  # Unicorn.new.horns # => 1
  # ```
  def horns
    @horns
  end

  # :ditto:
  def number_of_horns
    horns
  end

  # Makes the unicorn speak to STDOUT
  def speak
    puts "I'm a unicorn"
  end

  # :nodoc:
  class Helper
  end
end
```

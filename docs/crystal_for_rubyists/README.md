# Crystal for Rubyists

Although Crystal has a Ruby-like syntax, Crystal is a different language, not another Ruby implementation. For this reason, and mostly because it's a compiled, statically typed language, the language has some big differences when compared to Ruby.

## Crystal as a compiled language

### Using the `crystal` command

If you have a program `foo.cr`:

```crystal
# Crystal
puts "Hello world"
```

When you execute one of these commands, you will get the same output:

```console
$ crystal foo.cr
Hello world
$ ruby foo.cr
Hello world
```

It looks like `crystal` interprets the file, but what actually happens is that the file `foo.cr` is first compiled to a temporary executable and then this executable is run. This behaviour is very useful in the development cycle as you normally compile a file and want to immediately execute it.

If you just want to compile it you can use the `build` command:

```console
$ crystal build foo.cr
```

This creates a `foo` executable, which you can then run with `./foo`.

Note that this creates an executable that is not optimized. To optimize it, pass the `--release` flag:

```console
$ crystal build foo.cr --release
```

When writing benchmarks or testing performance, always remember to compile in release mode.

You can check other commands and flags by invoking `crystal` without arguments, or `crystal` with a command and no arguments (for example `crystal build` will list all flags that can be used with that command). Alternatively, you can read [the manual](../man/crystal/README.md).

## Types

### Bool

`true` and `false` are of type [`Bool`](https://crystal-lang.org/api/Bool.html) rather than instances of classes `TrueClass` or `FalseClass`.

### Integers

For Ruby's `Fixnum` type, use one of Crystal's integer types `Int8`, `Int16`, `Int32`, `Int64`, `UInt8`, `UInt16`, `UInt32`, or `UInt64`.

If any operation on a Ruby `Fixnum` exceeds its range, the value is automatically converted to a `Bignum`.
Crystal will instead raise an `OverflowError` on overflow. For example:

```crystal
x = 127_i8 # An Int8 type
x          # => 127
x += 1     # Unhandled exception: Arithmetic overflow (OverflowError)
```

Crystal's standard library provides number types with arbitrary size and precision: [`BigDecimal`](https://crystal-lang.org/api/BigDecimal.html), [`BigFloat`](https://crystal-lang.org/api/BigFloat.html), [`BigInt`](https://crystal-lang.org/api/BigInt.html), [`BigRational`](https://crystal-lang.org/api/BigRational.html).

See the language reference on [Integers](../syntax_and_semantics/literals/integers.md).

### Regex

Global variables ``$` `` and `$'` are not supported (yet `$~` and `$1`, `$2`, ... are present). Use `$~.pre_match` and `$~.post_match`. [Read more](https://github.com/crystal-lang/crystal/issues/1202#issuecomment-136526633).

## Pared-down instance methods

In Ruby where there are several methods for doing the same thing, in Crystal there may be only one.
Specifically:

| Ruby Method               | Crystal Method        |
|---------------------------|-----------------------|
| `Enumerable#detect`       | `Enumerable#find`     |
| `Enumerable#collect`      | `Enumerable#map`      |
| `Object#respond_to?`      | `Object#responds_to?` |
| `length`, `size`, `count` | `size`                |

## Omitted Language Constructs

Where Ruby has a a couple of alternative constructs, Crystal has one.

* trailing `while`/`until` are missing. Note however that [if as a suffix](../syntax_and_semantics/as_a_suffix.md) is still available
* `and` and `or`: use `&&` and `||` instead with suitable parentheses to indicate precedence
* Ruby has `Kernel#proc`, `Kernel#lambda`, `Proc#new` and `->`, while Crystal uses `Proc(*T, R).new` and `->` (see [this](../syntax_and_semantics/blocks_and_procs.md) for reference).
* For `require_relative "foo"` use `require "./foo"`

## No autosplat for arrays and enforced maximum block arity

```cr
[[1, "A"], [2, "B"]].each do |a, b|
  pp a
  pp b
end
```

will generate an error message like

```text
    in line 1: too many block arguments (given 2, expected maximum 1)
```

However omitting unneeded arguments is fine (as it is in Ruby), ex:

```cr
[[1, "A"], [2, "B"]].each do # no arguments
  pp 3
end
```

Or

```cr
def many
  yield 1, 2, 3
end

many do |x, y| # ignoring value passed in for "z" is OK
  puts x + y
end
```

There is autosplat for tuples:

```cr
[{1, "A"}, {2, "B"}].each do |a, b|
  pp a
  pp b
end
```

will return the result you expect.

You can also explicitly unpack to get the same result as Ruby's autosplat:

```cr
[[1, "A"], [2, "B"]].each do |(a, b)|
  pp a
  pp b
end
```

Following code works as well, but prefer former.

```cr
[[1, "A"], [2, "B"]].each do |e|
  pp e[0]
  pp e[1]
end
```

## `#each` returns nil

In Ruby `.each` returns the receiver for many built-in collections like `Array` and `Hash`, which allows for chaining methods off of that, but that can lead to some performance and codegen issues in Crystal, so that feature is not supported. Alternately, one can use `.tap`.

Ruby:

```ruby
[1, 2].each { "foo" } # => [1, 2]
```

Crystal:

```crystal
[1, 2].each { "foo" }       # => nil
[1, 2].tap &.each { "foo" } # => [1, 2]
```

[Reference](https://github.com/crystal-lang/crystal/pull/3815#issuecomment-269978574)

## Reflection and Dynamic Evaluation

`Kernel#eval()` and the weird `Kernel#autoload()` are omitted. Object and class introspection methods `Object#kind_of?()`, `Object#methods`, `Object#instance_methods`, and `Class#constants`, are omitted as well.

In some cases [macros](../syntax_and_semantics/macros/README.md) can be used for reflection.

## Semantic differences

### Single versus double-quoted strings

In Ruby, string literals can be delimited with single or double quotes. A double-quoted string in Ruby is subject to variable interpolation inside the literal, while a single-quoted string is not.

In Crystal, string literals are delimited with double quotes only. Single quotes act as character literals just like say C-like languages. As with Ruby, there is variable interpolation inside string literals.

In sum:

```ruby
X = "ho"
puts '"cute"' # Not valid in crystal, use "\"cute\"", %{"cute"}, or %("cute")
puts "Interpolate #{X}"  # works the same in Ruby and Crystal.
```

Triple quoted strings literals of Ruby or Python are not supported, but string literals can have newlines embedded in them:

```ruby
"""Now,
what?""" # Invalid Crystal use:
"Now,
what?"  # Valid Crystal
```

Crystal supports many [percent string literals](../syntax_and_semantics/literals/string.md#percent-string-literals), though.

### The `[]` and `[]?` methods

In Ruby the `[]` method generally returns `nil` if an element by that index/key is not found. For example:

```ruby
# Ruby
a = [1, 2, 3]
a[10] #=> nil

h = {a: 1}
h[1] #=> nil
```

In Crystal an exception is thrown in those cases:

```crystal
# Crystal
a = [1, 2, 3]
a[10] # => raises IndexError

h = {"a" => 1}
h[1] # => raises KeyError
```

The reason behind this change is that it would be very annoying to program in this way if every `Array` or `Hash` access could return `nil` as a potential value. This wouldn't work:

```crystal
# Crystal
a = [1, 2, 3]
a[0] + a[1] # => Error: undefined method `+` for Nil
```

If you do want to get `nil` if the index/key is not found, you can use the `[]?` method:

```crystal
# Crystal
a = [1, 2, 3]
value = a[4]? # => return a value of type Int32 | Nil
if value
  puts "The number at index 4 is : #{value}"
else
  puts "No number at index 4"
end
```

The `[]?` is just a regular method that you can (and should) define for a container-like class.

Another thing to know is that when you do this:

```crystal
# Crystal
h = {1 => 2}
h[3] ||= 4
```

the program is actually translated to this:

```crystal
# Crystal
h = {1 => 2}
h[3]? || (h[3] = 4)
```

That is, the `[]?` method is used to check for the presence of an index/key.

Just as `[]` doesn't return `nil`, some `Array` and `Hash` methods also don't return nil and raise an exception if the element is not found: `first`, `last`, `shift`, `pop`, etc. For these a question-method is also provided to get the `nil` behaviour: `first?`, `last?`, `shift?`, `pop?`, etc.

***

The convention is for `obj[key]` to return a value or else raise if `key` is missing (the definition of "missing" depends on the type of `obj`) and for `obj[key]?` to return a value or else nil if `key` is missing.

For other methods, it depends. If there's a method named `foo` and another `foo?` for the same type, it means that `foo` will raise on some condition while `foo?` will return nil in that same condition. If there's just the `foo?` variant but no `foo`, it returns a truthy or falsey value (not necessarily `true` or `false`).

Examples for all of the above:

* `Array#[](index)` raises on out of bounds, `Array#[]?(index)` returns nil in that case.
* `Hash#[](key)` raises if the key is not in the hash, `Hash#[]?(key)` returns nil in that case.
* `Array#first` raises if the array is empty (there's no "first", so "first" is missing), while `Array#first?` returns nil in that case. Same goes for pop/pop?, shift/shift?, last/last?
* There's `String#includes?(obj)`, `Enumerable#includes?(obj)` and `Enumerable#all?`, all of which don't have a non-question variant. The previous methods do indeed return true or false, but that is not a necessary condition.

### `for` loops

`for` loops are not supported. Instead, we encourage you to use `Enumerable#each`. If you still want a `for`, you can add them via macro:

```crystal
macro for(expr)
  {{expr.args.first.args.first}}.each do |{{expr.name.id}}|
    {{expr.args.first.block.body}}
  end
end

for i ∈ [1, 2, 3] do # You can replace ∈ with any other word or character, just not `in`
  puts i
end
# note the trailing 'do' as block-opener!
```

### Methods

In ruby, the following will raise an argument error:

```ruby
def process_data(a, b)
  # do stuff...
end

process_data(b: 2, a: "one")
```

This is because, in ruby, `process_data(b: 2, a: "one")` is syntax sugar for `process_data({b: 2, a: "one"})`.

In crystal, the compiler will treat `process_data(b: 2, a: "one")` as calling `process_data` with the named arguments `b: 2` and `a: "one"`, which is the same as `process_data("one", 2)`.

### Properties

The ruby `attr_accessor`, `attr_reader` and `attr_writer` methods are replaced by macros with different names:

| Ruby Keyword    | Crystal    |
|-----------------|------------|
| `attr_accessor` | `property` |
| `attr_reader`   | `getter`   |
| `attr_writer`   | `setter`   |

Example:

```crystal
getter :name, :bday
```

In addition, Crystal added accessor macros for nilable or boolean instance variables. They have a question mark (`?`) in the name:

| Crystal     |
|-------------|
| `property?` |
| `getter?`   |

Example:

```crystal
class Person
  getter? happy = true
  property? sad = true
end

p = Person.new

p.sad = false

puts p.happy?
puts p.sad?
```

Even though this is for booleans, you can specify any type:

```crystal
class Person
  getter? feeling : String = "happy"
end

puts Person.new.feeling?
# => happy
```

Read more about [getter?](https://crystal-lang.org/api/Object.html#getter?(*names,&block)-macro) and/or [property?](https://crystal-lang.org/api/Object.html#property?(*names,&block)-macro) in the documentation.

### Consistent dot notation

For example `File::exists?` in Ruby becomes `File.exists?` in Crystal.

### Crystal keywords

Crystal added some new keywords, these can still be used as method names, but need to be called explicitly with a dot: e.g. `self.select { |x| x > "good" }`.

#### Available keywords

```text
abstract   do       if                nil?           select          union
alias      else     in                of             self            unless
as         elsif    include           out            sizeof          until
as?        end      instance_sizeof   pointerof      struct          verbatim
asm        ensure   is_a?             private        super           when
begin      enum     lib               protected      then            while
break      extend   macro             require        true            with
case       false    module            rescue         type            yield
class      for      next              responds_to?   typeof
def        fun      nil               return         uninitialized
```

### Private methods

Crystal requires each private method to be prefixed with the `private` keyword:

```crystal
private def method
  42
end
```

### Hash syntax from Ruby to Crystal

Crystal introduces a data type that is not available in Ruby, the Tuple.

Typically in Ruby you can define a hash with several syntaxes:

```ruby
# A valid ruby hash declaration
{ 
  key1: "some value",
  some_key2: "second value"
}

# This syntax in ruby is shorthand for the hash rocket => syntax
{
  :key1 => "some value",
  :some_key2 => "second value"
}
```

In Crystal, this is not the case. The hash rocket `=>` syntax is required to declare a hash in Crystal.

```crystal
# Creates a valid hash in Crystal
{
  :key1 => "some value",
  :some_key2 => "second value"
}

# Creates a NamedTuple in Crystal
{ 
  key1: "some value",
  some_key2: "second value"
}
```

However, the hash shorthand syntax in Ruby creates a [NamedTuple](https://crystal-lang.org/api/latest/NamedTuple.html) in Crystal.

Tuples are a fixed size, so these are best used for data structures that are known at compile time.

### Pseudo Constants

Crystal provides a few pseudo-constants which provide reflective data about the source code being executed.

> [Read more about Pseudo Constants in the Crystal documentation.](../syntax_and_semantics/constants.md#pseudo-constants)

| Crystal | Ruby | Description |
| ------- | ---- | ----------- |
| `__FILE__` | `__FILE__` | The full path to the currently executing crystal file. |
| `__DIR__` | `__dir__` | The full path to the directory where the currently executing crystal file is located. |
| `__LINE__` | `__LINE__` | The current line number in the currently executing crystal file. |
| `__END_LINE__` | - | The line number of the end of the calling block. Can only be used as a default value to a method parameter. |

> TIP: Further reading about `__DIR__` vs. `__dir__`:
>
> * [Add an alias for `__dir__` [to Crystal]?](https://github.com/crystal-lang/crystal/issues/8546#issuecomment-561245178)
> * [Stack Overflow: Why is `__FILE__` uppercase and `__dir__` lowercase [in Ruby]?](https://stackoverflow.com/questions/15190700/why-is-file-uppercase-and-dir-lowercase)

## Crystal Shards for Ruby Gems

Many popular Ruby gems have been ported or rewritten in Crystal. [Here are some of the equivalent Crystal Shards for Ruby Gems](https://github.com/crystal-lang/crystal/wiki/Crystal-Shards-for-Ruby-Gems).

***

For other questions regarding differences between Ruby and Crystal, visit the [FAQ](https://github.com/crystal-lang/crystal/wiki/FAQ).

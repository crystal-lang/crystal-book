Although Crystal has a Ruby-like syntax, Crystal is a different language, not another Ruby implementation. For this reason, and mostly because it's a compiled, statically typed language, the language has some big differences when compared to Ruby.

## Crystal as a compiled language

### Using the `crystal` program

If you have a program `foo.cr`:

```crystal
# Crystal
puts "Hello world"
```

When you execute one of these commands:

```
crystal foo.cr
ruby foo.cr
```

You will get this output:

```
Hello world
```

It looks like `crystal` interprets the file, but what actually happens is that the file `foo.cr` is first compiled to a temporary executable and then this executable is run. This behaviour is very useful in the development cycle as you normally compile a file and want to immediately execute it.

If you just want to compile it you can use the `build` command:

```
crystal build foo.cr
```

This will create a `foo` executable, which you can then run with `./foo`.

Note that this creates an executable that is not optimized. To optimize it, pass the `--release` flag:

```
crystal build foo.cr --release
```

When writing benchmarks or testing performance, always remember to compile in release mode.

You can check other commands and flags by invoking `crystal` without arguments, or `crystal` with a command and no arguments (for example `crystal build` will list all flags that can be used with that command).

## Types

### Bool

`true` and `false` are values in the _Bool_ class rather than values in classes _TrueClass_ or _FalseClass_.

### Integers

For Ruby's `Fixnum` type, use one of Crystal's Integer types `Int8`, `Int16`, `Int32`, `Int64`, `UInt8`, `UInt16`, `UInt32`, or `UInt64`.

If any operation on a Ruby `Fixnum` exceeds its range, the value is automatically converted to a Bignum. Crystal will use modular arithmatic on overflow. For example:

```crystal
x = 127_i8  # An Int8 type
puts x # 127
x += 1 # -128
x += 1 # -127
```

See [Integers](http://crystal-lang.org/docs/syntax_and_semantics/literals/integers.html)

### Regex

Global variables ``$` `` and `$'` are missing (yet `$~` and `$1`, `$2`, ... are present). Use `$~.pre_match` and `$~.post_match`. [read more](https://github.com/manastech/crystal/issues/1202#issuecomment-136526633)

## Paired-down instance methods

In Ruby where there are several methods for doing the same thing, in Crystal there may be only one.
Specifically:

    Ruby Method          Crystal Method
    -----------------    --------------
    Enumerable#detect    Enumerable#find
    Enumerable#collect   Enumerable#map
    Object#respond_to?   Object#responds_to?
    length, size, count  size

## Omitted Language Constructs

Where Ruby has a a couple of alternative constructs, Crystal has one.

* [[trailing while/until | FAQ#why-trailing-whileuntil-is-not-supported-unlike-ruby]]. Note however that [if as a suffix](http://crystal-lang.org/docs/syntax_and_semantics/as_a_suffix.html) is still available
* `and` and `or` : use `&&` and `||` instead with suitable parenthesis to indicate precedence
* Ruby has `Kernel#proc`, `Kernel#lambda`, `Proc#new` and `->`, while Crystal uses just `->`
* For `require_relative "foo"` use `require "./foo"`

## No autosplat for arrays and enforced maximum block arity

```cr
[[1, "A"], [2, "B"]].each do |a, b|
  pp a
  pp b
end
```

will generate an error message like

    in line 1: too many block arguments (given 2, expected maximum 1)

However omitting unneeded arguments is fine.

There is autosplat for tuples:

```cr
[{1, "A"}, {2, "B"}].each do |a, b|
  pp a
  pp b
end
```

will return the result you expect.

## Reflection and Dynamic Evaluation

_Kernel#eval()_ and the weird _Kernel#autoload()_ are omitted. Object and class introspection methods _Object#kind_of?()_, _Object#methods_, _Object#instance_..., and _Class#constants_, are omitted.

In some cases [macros](http://crystal-lang.org/docs/syntax_and_semantics/macros.html) can be used for reflection.

## Semantic differences
### single- versus double-quoted strings

In Ruby, string literals can be delimited with single or double quotes. A double-quoted string in Ruby is subject to variable interpolation inside the literal, while a single-quoted string is not.

In Crystal, strings literals are delimited with double quotes only. Single quotes act as character literals the same as say C-like languages. As with Ruby, there is variable interpolation inside string literals.

In sum:

```ruby
X = "ho"
puts '"cute"' # Not valid in crystal use "\"cute\"", %{"cute"}, or %("cute")
puts "Interpolate #{X}"  # works the same in Ruby and Crystal.
```
Triple quoted strings literals of Ruby or Python are not supported, but string literals can have newlines embedded in them:

```rb
"""Now,
what?""" # Invalid Crystal use:
"Now,
what?"  # Valid Crystal
```

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
a[10] #=> raises IndexOutOfBounds

h = {a: 1}
h[1] #=> raises MissingKey
```

The reason behind this change is that it would be very annoying to program in this way if every Array or Hash access could return `nil` as a potential value. This wouldn't work:

```crystal
# Crystal
a = [1, 2, 3]
a[0] + a[1] #=> Error: undefined method `+` for Nil
```

If you do want to get `nil` if the index/key is not found, you can use the `[]?` method:

```crystal
# Crystal
a = [1, 2, 3]
value = a[4]? #=> return a value of type Int32 | Nil
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

Just as `[]` doesn't return `nil`, some Array and Hash methods also don't return nil and raise an exception if the element is not found: `first`, `last`, `shift`, `pop`, etc. For these a question-method is also provided to get the `nil` behaviour: `first?`, `last?`, `shift?`, `pop?`, etc.

***

The convention is for `obj[key]` to return a value or else raise if `key` is missing (the definition of "missing" depends on the type of `obj`) and for `obj[key]?` to return a value or else nil if `key` is missing.

For other methods, it depends. If there's a method named `foo` and another `foo?` for the same type, it means that `foo` will raise on some condition while `foo?` will return nil in that same condition. If there's just the `foo?` variant but no `foo`, it returns a truthy or falsey value (not necessarily `true` or `false`).

Examples for all of the above:

* `Array#[](index)` raises on out of bounds, `Array#[]?(index)` returns nil in that case.
* `Hash#[](key)` raises if the key is not in the hash, `Hash#[]?(key)` returns nil in that case.
* `Array#first` raises if the Array is empty (there's no "first", so "first" is missing), while `Array#first?` returns nil in that case. Same goes for pop/pop?, shift/shift?, last/last?
* There's `String#includes?(obj)`, `Enumerable#includes?(obj)` and `Enumerable#all?`, all of which don't have a non-question variant. The previous methods do indeed return true or false, but that is not a necessary condition.

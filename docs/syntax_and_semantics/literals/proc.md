# Proc

A [Proc](https://crystal-lang.org/api/Proc.html) represents a function pointer with an optional context (the closure data). It is typically created with a proc literal:

```crystal
# A proc without parameters
->{ 1 } # Proc(Int32)

# A proc with one parameter
->(x : Int32) { x.to_s } # Proc(Int32, String)

# A proc with two parameters
->(x : Int32, y : Int32) { x + y } # Proc(Int32, Int32, Int32)
```

The types of the parameters are mandatory, except when directly sending a proc literal to a lib `fun` in C bindings.

The return type is inferred from the proc's body, but can also be provided explicitly:

```crystal
# A proc returning an Int32 or String
-> : Int32 | String { 1 } # Proc(Int32 | String)

# A proc with one parameter and returning Nil
->(x : Array(String)) : Nil { x.delete("foo") } # Proc(Array(String), Nil)

# The return type must match the proc's body
->(x : Int32) : Bool { x.to_s } # Error: expected Proc to return Bool, not String
```

A `new` method is provided too, which creates a `Proc` from a [captured block](../capturing_blocks.md). This form is mainly useful with [aliases](../alias.md):

```crystal
Proc(Int32, String).new { |x| x.to_s } # Proc(Int32, String)

alias Foo = Int32 -> String
Foo.new { |x| x.to_s } # same proc as above
```

## The Proc type

To denote a Proc type you can write:

```crystal
# A Proc accepting a single Int32 argument and returning a String
Proc(Int32, String)

# A proc accepting no arguments and returning Nil
Proc(Nil)

# A proc accepting two arguments (one Int32 and one String) and returning a Char
Proc(Int32, String, Char)
```

In type restrictions, generic type arguments and other places where a type is expected, you can use a shorter syntax, as explained in the [type](../type_grammar.md):

```crystal
# An array of Proc(Int32, String, Char)
Array(Int32, String -> Char)
```

## Invoking

To invoke a Proc, you invoke the `call` method on it. The number of arguments must match the proc's type:

```crystal
proc = ->(x : Int32, y : Int32) { x + y }
proc.call(1, 2) # => 3
```

## From methods

A Proc can be created from an existing method:

```crystal
def one
  1
end

proc = ->one
proc.call # => 1
```

If the method has parameters, you must specify their types:

```crystal
def plus_one(x)
  x + 1
end

proc = ->plus_one(Int32)
proc.call(41) # => 42
```

A proc can optionally specify a receiver:

```crystal
str = "hello"
proc = ->str.count(Char)
proc.call('e') # => 1
proc.call('l') # => 2
```

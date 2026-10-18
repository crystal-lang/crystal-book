# Proc

A [Proc](https://crystal-lang.org/api/Proc.html) is a first-class, typed callable object representing an anonymous function or a method reference. Unlike [blocks](../blocks_and_procs.md), a `Proc` can be stored in variables, passed to methods, and returned as a value. A [captured block](../capturing_blocks.md) is also converted into a `Proc`.

Internally, a `Proc` consists of a function pointer and optional [closured data](../closures.md), which holds the shared local variables accessed by the proc and allocated on the GC heap by the compiler. When passed to C libraries, as described in [C bindings: Callbacks](../c_bindings/callbacks.md), a `Proc` can only be used if it has no closured data.

Procs are typically created with a proc literal:

```crystal
# A proc without parameters
-> { 1 } # Proc(Int32)

# A proc with one parameter
->(x : Int32) { x.to_s } # Proc(Int32, String)

# A proc with two parameters
->(x : Int32, y : Int32) { x + y } # Proc(Int32, Int32, Int32)
```

The types of parameters are mandatory, except when directly passing a proc literal to a lib `fun` in [C bindings](../c_bindings/fun.md).

The return type is inferred from the proc's body, but can also be provided explicitly:

```crystal
# A proc returning an Int32 or String
-> : Int32 | String { 1 } # Proc(Int32 | String)

# A proc with one parameter and returning Nil
->(x : Array(String)) : Nil { x.delete("foo") } # Proc(Array(String), Nil)

# The return type must match the proc's body
->(x : Int32) : Bool { x.to_s } # Error: expected Proc to return Bool, not String
```

## The `Proc` type

To denote a `Proc` type you can write:

```crystal
# A Proc accepting a single Int32 argument and returning a String
Proc(Int32, String)

# A proc accepting no arguments and returning Nil
Proc(Nil)

# A proc accepting two arguments (one Int32 and one String) and returning a Char
Proc(Int32, String, Char)
```

In type restrictions, generic type arguments, and other places where a type is expected, you can use a shorter syntax, as explained in the [type grammar](../type_grammar.md):

```crystal
# An array of Proc(Int32, String, Char)
Array(Int32, String -> Char)
```

## `Proc.new`

A constructor method is available. It creates a `Proc` from a [captured block](../capturing_blocks.md):

```crystal
Proc(Int32, String).new { |x| x.to_s } # Proc(Int32, String)
```

This form is mainly useful with [aliases](../alias.md), where `Foo.new` is identical to `Proc(Int32, String).new`:

```crystal
alias Foo = Int32 -> String
Foo.new { |x| x.to_s } # Proc(Int32, String)
```

## Invoking a proc

To invoke a `Proc`, call the `#call` method or its index shorthand `[]`. The number and types of arguments must match the proc's type:

```crystal
proc = ->(x : Int32, y : Int32) { x + y }
proc.call(1, 2) # => 3
proc[1, 2]      # => 3
```

## From methods

A `Proc` can be created from an existing method:

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

# Proc

A [Proc](https://crystal-lang.org/api/latest/Proc.html) represents a function pointer with an optional context (the closure data). It is typically created with a proc literal:

```crystal
# A proc without parameters
->{ 1 } # Proc(Int32)

# A proc with one parameters
->(x : Int32) { x.to_s } # Proc(Int32, String)

# A proc with two parameters
->(x : Int32, y : Int32) { x + y } # Proc(Int32, Int32, Int32)
```

The types of the parameters are mandatory, except when directly sending a proc literal to a lib `fun` in C bindings.

The return type is inferred from the proc's body.

A special `new` method is provided too:

```crystal
Proc(Int32, String).new { |x| x.to_s } # Proc(Int32, String)
```

This form allows you to specify the return type and to check it against the proc's body.

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

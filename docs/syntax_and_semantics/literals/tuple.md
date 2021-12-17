# Tuple

A [Tuple](https://crystal-lang.org/api/Tuple.html) is typically created with a tuple literal:

```crystal
tuple = {1, "hello", 'x'} # Tuple(Int32, String, Char)
tuple[0]                  # => 1       (Int32)
tuple[1]                  # => "hello" (String)
tuple[2]                  # => 'x'     (Char)
```

To create an empty tuple use [Tuple.new](https://crystal-lang.org/api/Tuple.html#new%28%2Aargs%3A%2AT%29-class-method).

To denote a tuple type you can write:

```crystal
# The type denoting a tuple of Int32, String and Char
Tuple(Int32, String, Char)
```

In type restrictions, generic type arguments and other places where a type is expected, you can use a shorter syntax, as explained in the [type grammar](../type_grammar.md):

```crystal
# An array of tuples of Int32, String and Char
Array({Int32, String, Char})
```

## Splat Expansion

The splat operator can be used inside tuple literals to unpack multiple values at once. The splatted value must be another tuple.

```crystal
tuple = {1, *{"hello", 'x'}, 2} # => {1, "hello", 'x', 2}
typeof(tuple)                   # => Tuple(Int32, String, Char, Int32)

tuple = {3.5, true}
tuple = {*tuple, *tuple} # => {3.5, true, 3.5, true}
typeof(tuple)            # => Tuple(Float64, Bool, Float64, Bool)
```

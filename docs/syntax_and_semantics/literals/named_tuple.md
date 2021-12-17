# NamedTuple

A [NamedTuple](https://crystal-lang.org/api/NamedTuple.html) is typically created with a named tuple literal:

```crystal
tuple = {name: "Crystal", year: 2011} # NamedTuple(name: String, year: Int32)
tuple[:name]                          # => "Crystal" (String)
tuple[:year]                          # => 2011      (Int32)
```

To denote a named tuple type you can write:

```crystal
# The type denoting a named tuple of x: Int32, y: String
NamedTuple(x: Int32, y: String)
```

In type restrictions, generic type arguments and other places where a type is expected, you can use a shorter syntax, as explained in the [type grammar](../type_grammar.md):

```crystal
# An array of named tuples of x: Int32, y: String
Array({x: Int32, y: String})
```

A named tuple key can also be a string literal:

```crystal
{"this is a key": 1}
```

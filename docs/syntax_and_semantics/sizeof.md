# sizeof

The `sizeof` expression returns an `Int32` with the size in bytes of a given type. For example:

```crystal
sizeof(Int32) # => 4
sizeof(Int64) # => 8
```

For [Reference](https://crystal-lang.org/api/latest/Reference.html) types, the size is the same as the size of a pointer:

```crystal
# On a 64 bits machine
sizeof(Pointer(Int32)) # => 8
sizeof(String)         # => 8
```

This is because a Reference's memory is allocated on the heap and a pointer to it is passed around. To get the effective size of a class, use [instance_sizeof](instance_sizeof.md).

The argument to sizeof is a [type](type_grammar.md) and is often combined with [typeof](typeof.md):

```crystal
a = 1
sizeof(typeof(a)) # => 4
```

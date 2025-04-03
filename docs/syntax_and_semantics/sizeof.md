# sizeof

The `sizeof` expression returns an `Int32` with the size in bytes of a given type. For example:

```crystal
sizeof(Int32) # => 4
sizeof(Int64) # => 8
```

For [Reference](https://crystal-lang.org/api/Reference.html) types, the size is the same as the size of a pointer:

```crystal
# On a 64-bit machine
sizeof(Pointer(Int32)) # => 8
sizeof(String)         # => 8
```

This is because `Reference`'s memory is allocated on the heap and a pointer to it is passed around. To get the effective size of a class, use [instance_sizeof](instance_sizeof.md).

The argument to sizeof is a [type](type_grammar.md) and is often combined with [typeof](typeof.md):

```crystal
a = 1
sizeof(typeof(a)) # => 4
```

`sizeof` can be used in the macro language, but only on types with stable size and alignment. See the API docs of [`sizeof`](https://crystal-lang.org/api/Crystal/Macros.html#sizeof(type):NumberLiteral-instance-method) for details.

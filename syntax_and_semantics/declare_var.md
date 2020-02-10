# Uninitialized variable declaration

Crystal allows declaring uninitialized variables:

```crystal
x = uninitialized Int32
x # => some random value, garbage, unreliable
```

This is [unsafe](unsafe.html) code and is almost always used in low-level code for declaring uninitialized [StaticArray](http://crystal-lang.org/api/StaticArray.html) buffers without a performance penalty:

```crystal
buffer = uninitialized UInt8[256]
```

The buffer is allocated on the stack, avoiding a heap allocation.

The type after the `uninitialized` keyword follows the [type grammar](type_grammar.html).


# Array

An [Array](http://crystal-lang.org/api/Array.html) is an ordered and integer-indexed generic collection of elements of a specific type `T`.

Arrays are typically created with an array literal denoted by square brackets (`[]`) and individual elements separated by a comma (`,`).

```crystal
[1, 2, 3]
```

## Generic Type Argument

The array's generic type argument `T` is inferred from the types of the elements inside the literal. When all elements of the array have the same type, `T` equals to that. Otherwise it will be a union of all element types.

```crystal
[1, 2, 3]         # => Array(Int32)
[1, "hello", 'x'] # => Array(Int32 | String | Char)
```

An explicit type can be specified by immediately following the closing bracket with `of` and a type, each separated by whitespace. This overwrites the inferred type and can be used for example to create an array that holds only some types initially but can accept other types later.

```crystal
array_of_float_or_int = [1, 2, 3] of Float64 | Int32  # => Array(Float64 | Int32)
array_of_float_or_int << 0.5                          # => [1, 2, 3, 0.5]


array_of_int_or_string = [1, 2, 3] of Int32 | String  # => Array(Int32 | String)
array_of_int_or_string << "foo"                       # => [1, 2, 3, "foo"]
```

Empty array literals always need a type specification:

```crystal
[] of Int32 # => Array(Int32).new
```

## Percent Array Literals

[Arrays of strings](./string.html#Percent String Array Literal) and [arrays of symbols](./symbol.html#Percent Symbol Array Literal) can be created with percent array literals:

```crystal
%w(one two three) # => ["one", "two", "three"]
%i(one two three) # => [:one, :two, :three]
```

## Array-like Type Literal

Crystal supports an additional literal for arrays and array-like types. It consists of the name of the type followed by a list of elements enclosed in curly braces (`{}`) and individual elements separated by a comma (`,`).

```crystal
Array{1, 2, 3}
```

This literal can be used with any type as long as it has an argless constructor and responds to `<<`.

```crystal
IO::Memory{1, 2, 3}
Set{1, 2, 3}
```

For a non-generic type like `IO::Memory`, this is equivalent to:

```crystal
array_like = IO::Memory.new
array_like << 1
array_like << 2
array_like << 3
```

For a generic type like `Set`, the generic type `T` is inferred from the types of the elements in the same way as with the array literal. The above is equivalent to:

```crystal
array_like = Set(typeof(1, 2, 3)).new
array_like << 1
array_like << 2
array_like << 3
```

The type arguments can be explicitly specified as part of the type name:

```crystal
Set(Int32) {1, 2, 3}
```

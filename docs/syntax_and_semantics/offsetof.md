# offsetof

An `offsetof` expression returns the byte offset of a subobject in an instance of a class or struct.

There are two forms of `offsetof` expressions. The first form accepts any type as first argument and an instance variable name prefixed by an `@` as second argument:

```crystal
# x : Type
offsetof(Type, @ivar) # the byte offset of x.@ivar relative to x
```

The second form accepts any tuple type as first argument and an integer literal index as second argument:

```crystal
# x : {Types, ...}
offsetof({Types, ...}, 123) # the byte offset of x[123] relative to x
```

This is a low-level primitive and only useful if a C API needs to directly interface with the data layout of a Crystal type.

Example:

```crystal
struct Foo
  @x = 0_i64
  @y = 34_i32
end

offsetof(Foo, @y)                # => 8
offsetof(Tuple(Int64, Int32), 1) # => 8
```

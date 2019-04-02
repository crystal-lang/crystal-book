# offsetof

The `offsetof` instruction returns the byte offset of an instance variable in a struct or class type. It accepts the type as first argument and the instance variable name prefixed by an `@` as second argument:

```cr
offsetof(Type, @ivar)
```

This is a low-level primitive and only useful if a C API needs to directly interface with the data layout of a Crystal type.
It returns the value of [`LLVMOffsetOfElement`](http://llvm.org/doxygen/group__LLVMCTarget.html#ga9971347f4072d348862519bbacbd71a7).

Example:
```cr
struct Foo
  @x = 0_i64
  @y = 34_i32
end

foo = Foo.new

offsetof(typeof(foo), @y) # => 8
```

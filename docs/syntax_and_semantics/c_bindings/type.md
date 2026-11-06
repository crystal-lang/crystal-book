# type

A `type` declaration inside a `lib` declares a kind of C `typedef`, but stronger:

```crystal
lib X
  type MyInt = Int32
end
```

Unlike C, `Int32` and `MyInt` are not interchangeable:

```crystal
lib X
  type MyInt = Int32

  fun some_fun(value : MyInt)
end

X.some_fun 1 # Error: argument 'value' of 'X#some_fun' must be X::MyInt, not Int32
```

Thus, a `type` declaration is useful for opaque types that are created by the C library you are wrapping. An example of this is the C `FILE*` handle, which you can obtain with `fopen` and pass to `fclose`. Whether the C type is an opaque pointer such as `typedef void *MyType` or a pointer to a struct whose fields Crystal does not need to access, it can be represented as `Void*` because the C library allocates and manages the underlying memory and Crystal only passes the pointer around:

```crystal
lib LibC
  type File = Void*

  fun fopen(filename : Char*, mode : Char*) : File
  fun fclose(stream : File) : Int32
end

file = LibC.fopen("test.txt", "r")
LibC.fclose(file)

ptr = Pointer(Void).malloc(1)
LibC.fclose(ptr) # Error: argument 'stream' of 'LibC#fclose' must be LibC::File, not Pointer(Void)
```

Using `type` instead of [`alias`](./alias.md) restricts the pointer type in Crystal's type system. An `alias` would make `File` interchangeable with `Void*` and accept any `Void*` pointer.

Refer to the [type grammar](../type_grammar.md) for the notation used in typedef types.

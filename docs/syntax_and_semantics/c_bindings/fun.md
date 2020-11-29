# fun

A `fun` declaration inside a `lib` binds to a C function.

```crystal
lib C
  # In C: double cos(double x)
  fun cos(value : Float64) : Float64
end
```

Once you bind it, the function is available inside the `C` type as if it was a class method:

```crystal
C.cos(1.5) # => 0.0707372
```

You can omit the parentheses if the function doesn't have arguments (and omit them in the call as well):

```crystal
lib C
  fun getch : Int32
end

C.getch
```

If the return type is void you can omit it:

```crystal
lib C
  fun srand(seed : UInt32)
end

C.srand(1_u32)
```

You can bind to variadic functions:

```crystal
lib X
  fun variadic(value : Int32, ...) : Int32
end

X.variadic(1, 2, 3, 4)
```

Note that there are no implicit conversions (except `to_unsafe`, which is explained later) when invoking a C function: you must pass the exact type that is expected. For integers and floats you can use the various `to_...` methods.

## Function names

Function names in a `lib` definition can start with an upper case letter. That's different from methods and function definitions outside a `lib`, which must start with a lower case letter.

Function names in Crystal can be different from the C name. The following example shows how to bind the C function name `SDL_Init` as `LibSDL.init` in Crystal.

```crystal
lib LibSDL
  fun init = SDL_Init(flags : UInt32) : Int32
end
```

The C name can be put in quotes to be able to write a name that is not a valid identifier:

```crystal
lib LLVMIntrinsics
  fun ceil_f32 = "llvm.ceil.f32"(value : Float32) : Float32
end
```

This can also be used to give shorter, nicer names to C functions, as these tend to be long and are usually prefixed with the library name.

## Types in C Bindings

The valid types to use in C bindings are:

* Primitive types (`Int8`, ..., `Int64`, `UInt8`, ..., `UInt64`, `Float32`, `Float64`)
* Pointer types (`Pointer(Int32)`, which can also be written as `Int32*`)
* Static arrays (`StaticArray(Int32, 8)`, which can also be written as `Int32[8]`)
* Function types (`Function(Int32, Int32)`, which can also be written as `Int32 -> Int32`)
* Other `struct`, `union`, `enum`, `type` or `alias` declared previously.
* `Void`: the absence of a return value.
* `NoReturn`: similar to `Void`, but the compiler understands that no code can be executed after that invocation.
* Crystal structs marked with the `@[Extern]` attribute

Refer to the [type grammar](../type_grammar.md) for the notation used in fun types.

The standard library defines the [LibC](https://github.com/crystal-lang/crystal/blob/master/src/lib_c.cr) lib with aliases for common C types, like `int`, `short`, `size_t`. Use them in bindings like this:

```crystal
lib MyLib
  fun my_fun(some_size : LibC::SizeT)
end
```

!!! note
    The C `char` type is `UInt8` in Crystal, so a `char*` or a `const char*` is `UInt8*`. The `Char` type in Crystal is a unicode codepoint so it is represented by four bytes, making it similar to an `Int32`, not to an `UInt8`. There's also the alias `LibC::Char` if in doubt.

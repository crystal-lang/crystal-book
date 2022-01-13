# Type autocasting

At function calls, Crystal transparently casts elements of certain types when there is no ambiguity.

## Number autocasting

When passing a number to a function, values of a type are autocasted to a larger one if no precision is lost:

```crystal
def foo(x : Int32) : Int32
  x
end

def bar(x : Float32) : Float32
  x
end

def bar64(x : Float64) : Float64
  x
end

foo 0xFFFF_u16 # OK, an UInt16 always fit an Int32
foo 0xFFFF_u64 # OK, this particular Int64 fit in an Int32
bar(foo 1)     # Fails, casting an Int32 to a Float32 might lose precision
bar64(bar 1)   # OK, a Float32 can be autocasted to a Float64
```

Number literals are always casted when the actual value of the literal fits the target type, despite of its type. Expressions are casted too (like in the last example above), unless the flag `no_number_autocast` is passed to the compiler (see [Compiler features](compile_time_flags.md#compiler-features)).

If there is ambiguity, for instance, because there is more than one option, the compiler throws an error:

```crystal
def foo(x : Int64)
  x
end

def foo(x : Int128)
  x
end

bar = 1_i32
foo bar # Error: ambiguous call, implicit cast of Int32 matches all of Int64, Int128
```


## Symbol autocasting

Symbols are autocasted as enum members, therefore enabling to write them more succinctly:

```crystal
enum TwoValues
  A
  B
end

def foo(v : TwoValues)
  case v
  in TwoValues::A
    p "A"
  in TwoValues::B
    p "B"
  end
end

foo :a # autocasted to TwoValues::A
```

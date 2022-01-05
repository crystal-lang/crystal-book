# Type autocasting

Crystal transparently casts elements of certain types when there is no ambiguity.

## Number autocasting

If needed, values of numeric type are autocasted to a larger one if no precision is lost:

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
bar 0xFFFF_u16 # OK, an UInt16 always fit an Float32
bar(foo 1)     # Fails, casting an Int32 to a Float32 might lose precision
bar64(bar 1)   # OK, a Float32 can be autocasted to a Float64
```

Number literals are always casted. Expression are casted too (like in the last example above), unless the flag `no_number_autocast` is passed to the compiler (see [Compiler features](compile_time_flags.md#compiler-features)).

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

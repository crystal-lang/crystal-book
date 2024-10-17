# Type autocasting

Crystal transparently casts elements of certain types when there is no ambiguity.

## Number autocasting

Values of a numeric type autocast to a larger one if no precision is lost:

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
foo 0xFFFF_u64 # OK, this particular Uint64 fit in an Int32
bar(foo 1)     # Fails, casting an Int32 to a Float32 might lose precision
bar64(bar 1)   # OK, a Float32 can be autocasted to a Float64
```

Number literals are always casted when the actual value of the literal fits the target type, despite of its type.

Expressions are casted (like in the last example above), unless the flag `no_number_autocast` is passed to the compiler (see [Compiler features](compile_time_flags.md#compiler-features)).

If there is ambiguity, for instance, because there is more than one option, the compiler throws an error:

```crystal
def foo(x : Int64)
  x
end

def foo(x : Int128)
  x
end

foo 1_i32 # Error: ambiguous call, implicit cast of Int32 matches all of Int64, Int128
```

Autocasting at the moment works only in two scenarios: at function calls, as shown so far, and at class/instance variable initialization. The following example shows an example of two situations for an instance variable: casting at initialization works, but casting at an assignment doesn't:

```crystal
class Foo
  @x : Int64 = 10 # OK, 10 fits in an Int64

  def set_x(y)
    @x = y
  end
end

Foo.new.set_x 1 # Error: "at line 5: instance variable '@x' of Foo must be Int64, not Int32"
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

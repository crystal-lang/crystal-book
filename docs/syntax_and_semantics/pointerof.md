# pointerof

The `pointerof` expression returns a [Pointer](https://crystal-lang.org/api/Pointer.html) that points to the contents of a variable or constant.

An example with a local variable:

```crystal
a = 1

ptr = pointerof(a)
ptr.value = 2

a # => 2
```

An example with an instance variable:

```crystal
class Point
  def initialize(@x : Int32, @y : Int32)
  end

  def x
    @x
  end

  def x_ptr
    pointerof(@x)
  end
end

point = Point.new 1, 2

ptr = point.x_ptr
ptr.value = 10

point.x # => 10
```

In a nested structure, variable names can be chained in the same manner as accessing nested variables:

```crystal
record Foo, bar : Bar
record Bar, baz : String

foo = Foo.new(Bar.new("baz"))

pointerof(foo.@bar.@baz).value # => "baz"

pointerof(foo.@bar.@baz).value = "qux"
foo.bar.baz # => "qux"
```

An example with a constant:

```cr
FOO = 1

pointerof(FOO).value # => 1
```

It's not possible to change the value of a constant via pointer assignment because a constant's memory is read-only.

Because `pointerof` involves pointers, it is considered [unsafe](unsafe.md).

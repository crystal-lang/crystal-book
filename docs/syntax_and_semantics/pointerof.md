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

Because `pointerof` involves pointers, it is considered [unsafe](unsafe.md).

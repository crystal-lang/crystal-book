# instance_sizeof

The `instance_sizeof` expression returns an `Int32` with the instance size of a given class.

Unlike [`sizeof`](sizeof.md) which would return the size of the reference
(pointer) to the allocated object, `instance_sizeof` returns the size of
the allocated object itself.

For example:

```crystal
class Point
  def initialize(@x, @y)
  end
end

Point.new 1, 2

# 2 x Int32 = 2 x 4 = 8
instance_sizeof(Point) # => 12
```

Even though the instance has two `Int32` fields, the compiler always includes an extra `Int32` field for the type id of the object. That's why the instance size ends up being 12 and not 8.

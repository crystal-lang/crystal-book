# Structs

Instead of defining a type with `class` you can do so with `struct`:

```crystal
struct Point
  property x, y

  def initialize(@x : Int32, @y : Int32)
  end
end
```

## Passing

A struct is [passed by value](http://crystal-lang.org/api/Value.html) while a class is passed by reference.

```crystal
class Klass
  property array = ["str"]
end

struct Strukt
  property array = ["str"]
end

def modify(object)
  object.array << "foo"
  object.array = ["new"]
  object.array << "bar"
end

strukt = Strukt.new
klass = Klass.new
modify strukt
modify klass
puts strukt.array #=> ["str", "foo"]
puts klass.array  #=> ["new", "bar"]
```

Explanation:
- `array` is an `Array` class, thus passed by reference
- the `array` object can be modified - elements inside it can be added/removed/modified
- `object.array = ["new"]` replace the `object.array` reference by a new array - `object.array << "bar"` appends to the newly created array
- `Strukt` is a struct, and immutable - the `array` object can't be replaced, and remains `["str", "foo"]`
- `Klass` is a class, everything is passed by reference - all values can be replaced no matter the scope

## Allocation

Invoking `new` on a struct [allocates it on the stack](https://en.wikipedia.org/wiki/Stack-based_memory_allocation) instead of the heap.

A struct is mostly used for performance reasons to avoid lots of small memory allocations when passing small copies might be more efficient.

For more details, see the [performance guide](https://crystal-lang.org/docs/guides/performance.html#use-structs-when-possible).

## Inheritance

* A struct implicitly inherits from [Struct](http://crystal-lang.org/api/Struct.html), which inherits from [Value](http://crystal-lang.org/api/Value.html). A class implicitly inherits from [Reference](http://crystal-lang.org/api/Reference.html).
* A struct cannot inherit a non-abstract struct.

The last point has a reason to it: a struct has a very well defined memory layout. For example, the above `Point` struct occupies 8 bytes. If you have an array of points the points are embedded inside the array's buffer:

```crystal
# The array's buffer will have 8 bytes dedicated to each Point
ary = [] of Point
```

If `Point` is inherited, an array of such type must also account for the fact that other types can be inside it, so the size of each element must grow to accommodate that. That is certainly unexpected. So, non-abstract structs can't be inherited. Abstract structs, on the other hand, will have descendants, so it's expected that an array of them will account for the possibility of having multiple types inside it.

A struct can also include modules and can be generic, just like a class.

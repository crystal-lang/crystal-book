# Structs

Instead of defining a type with `class` you can do so with `struct`:

```crystal
struct Point
  property x, y

  def initialize(@x : Int32, @y : Int32)
  end
end
```

Structs inherit from [Value](https://crystal-lang.org/api/Value.html) so they are allocated on the stack and passed by value: when passed to methods, returned from methods or assigned to variables, a copy of the value is actually passed (while classes inherit from [Reference](https://crystal-lang.org/api/Reference.html), are allocated on the heap and passed by reference).

Therefore structs are mostly useful for immutable data types and/or stateless wrappers of other types, usually for performance reasons to avoid lots of small memory allocations when passing small copies might be more efficient (for more details, see the [performance guide](https://crystal-lang.org/docs/guides/performance.html#use-structs-when-possible)).

Mutable structs are still allowed, but you should be careful when writing code involving mutability if you want to avoid surprises that are described below.

## Passing by value

A struct is _always_ passed by value, even when you return `self` from the method of that struct:

```crystal
struct Counter
  def initialize(@count : Int32)
  end

  def plus
    @count += 1
    self
  end
end

counter = Counter.new(0)
counter.plus.plus # => Counter(@x=2)
puts counter      # => Counter(@x=1)
```

Notice that the chained calls of `plus` return the expected result, but only the first call to it modifies the variable `counter`, as the second call operates on the _copy_ of the struct passed to it from the first call, and this copy is discarded after the expression is executed.

You should also be careful when working on mutable types inside of the struct:

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

klass = Klass.new
puts modify(klass) # => ["new", "bar"]
puts klass.array   # => ["new", "bar"]

strukt = Strukt.new
puts modify(strukt) # => ["new", "bar"]
puts strukt.array   # => ["str", "foo"]
```

What happens with the `strukt` here:
- `Array` is passed by reference, so the reference to `["str"]` is stored in the property of `strukt`
- when `strukt` is passed to `modify`, a _copy_ of the `strukt` is passed with the reference to array inside it
- the array referenced by `array` is modified (element inside it is added) by `object.array << "foo"`
- this is also reflected in the original `strukt` as it holds reference to the same array
- `object.array = ["new"]` replaces the reference in the _copy_ of `strukt` with the reference to the new array
- `object.array << "bar"` appends to this newly created array
- `modify` returns the reference to this new array and its content is printed
- the reference to this new array was held only in the _copy_ of `strukt`, but not in the original, so that's why the original `strukt` only retained the result of the first statement, but not of the other two statements

`Klass` is a class, so it is passed by reference to `modify`, and `object.array = ["new"]` saves the reference to the newly created array in the original `klass` object, not in the copy as it was with the `strukt`.


## Inheritance

* A struct implicitly inherits from [Struct](http://crystal-lang.org/api/Struct.html), which inherits from [Value](http://crystal-lang.org/api/Value.html). A class implicitly inherits from [Reference](http://crystal-lang.org/api/Reference.html).
* A struct cannot inherit from a non-abstract struct.

The second point has a reason to it: a struct has a very well defined memory layout. For example, the above `Point` struct occupies 8 bytes. If you have an array of points the points are embedded inside the array's buffer:

```crystal
# The array's buffer will have 8 bytes dedicated to each Point
ary = [] of Point
```

If `Point` is inherited, an array of such type should also account for the fact that other types can be inside it, so the size of each element should grow to accommodate that. That is certainly unexpected. So, non-abstract structs can't be inherited from. Abstract structs, on the other hand, will have descendants, so it is expected that an array of them will account for the possibility of having multiple types inside it.

A struct can also include modules and can be generic, just like a class.

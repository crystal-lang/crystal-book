# Type restrictions

Type restrictions are applied to method parameters to restrict the types accepted by that method.

```crystal
def add(x : Number, y : Number)
  x + y
end

# Ok
add 1, 2

# Error: no overload matches 'add' with types Bool, Bool
add true, false
```

Note that if we had defined `add` without type restrictions, we would also have gotten a compile time error:

```crystal
def add(x, y)
  x + y
end

add true, false
```

The above code gives this compile error:

```
Error in foo.cr:6: instantiating 'add(Bool, Bool)'

add true, false
^~~

in foo.cr:2: undefined method '+' for Bool

  x + y
    ^
```

This is because when you invoke `add`, it is instantiated with the types of the arguments: every method invocation with a different type combination results in a different method instantiation.

The only difference is that the first error message is a little more clear, but both definitions are safe in that you will get a compile time error anyway. So, in general, it's preferable not to specify type restrictions and almost only use them to define different method overloads. This results in more generic, reusable code. For example, if we define a class that has a `+` method but isn't a `Number`, we can use the `add` method that doesn't have type restrictions, but we can't use the `add` method that has restrictions.

```crystal
# A class that has a + method but isn't a Number
class Six
  def +(other)
    6 + other
  end
end

# add method without type restrictions
def add(x, y)
  x + y
end

# OK
add Six.new, 10

# add method with type restrictions
def restricted_add(x : Number, y : Number)
  x + y
end

# Error: no overload matches 'restricted_add' with types Six, Int32
restricted_add Six.new, 10
```

Refer to the [type grammar](type_grammar.md) for the notation used in type restrictions.

Note that type restrictions do not apply to the variables inside the actual methods.

```crystal
def handle_path(path : String)
  path = Path.new(path) # *path* is now of the type Path
  # Do something with *path*
end
```

## Restrictions from instance variables

In some cases it is possible to restrict the type of a method's parameter based on its usage. For instance, consider the following example:

```crystal
class Foo
  @x : Int64

  def initialize(x)
    @x = x
  end
end
```

In this case we know that the parameter `x` from the initialization function must be an `Int64`, and there is no point in leave it unrestricted.

When the compiler finds an assignment from a method parameter to an instance variable, then it inserts such a restriction. In the example above, calling `Foo.new "hi"` fails with (note the type restriction):

```
Error: no overload matches 'Foo.new' with type String

Overloads are:
 - Foo.new(x : ::Int64)
```

## self restriction

A special type restriction is `self`:

```crystal
class Person
  def ==(other : self)
    other.name == name
  end

  def ==(other)
    false
  end
end

john = Person.new "John"
another_john = Person.new "John"
peter = Person.new "Peter"

john == another_john # => true
john == peter        # => false (names differ)
john == 1            # => false (because 1 is not a Person)
```

In the previous example `self` is the same as writing `Person`. But, in general, `self` is the same as writing the type that will finally own that method, which, when modules are involved, becomes more useful.

As a side note, since `Person` inherits `Reference` the second definition of `==` is not needed, since it's already defined in `Reference`.

Note that `self` always represents a match against an instance type, even in class methods:

```crystal
class Person
  getter name : String

  def initialize(@name)
  end

  def self.compare(p1 : self, p2 : self)
    p1.name == p2.name
  end
end

john = Person.new "John"
peter = Person.new "Peter"

Person.compare(john, peter) # OK
```

You can use `self.class` to restrict to the Person type. The next section talks about the `.class` suffix in type restrictions.

## Classes as restrictions

Using, for example, `Int32` as a type restriction makes the method only accept instances of `Int32`:

```crystal
def foo(x : Int32)
end

foo 1       # OK
foo "hello" # Error
```

If you want a method to only accept the type Int32 (not instances of it), you use `.class`:

```crystal
def foo(x : Int32.class)
end

foo Int32  # OK
foo String # Error
```

The above is useful for providing overloads based on types, not instances:

```crystal
def foo(x : Int32.class)
  puts "Got Int32"
end

def foo(x : String.class)
  puts "Got String"
end

foo Int32  # prints "Got Int32"
foo String # prints "Got String"
```

## Type restrictions in splats

You can specify type restrictions in splats:

```crystal
def foo(*args : Int32)
end

def foo(*args : String)
end

foo 1, 2, 3       # OK, invokes first overload
foo "a", "b", "c" # OK, invokes second overload
foo 1, 2, "hello" # Error
foo()             # Error
```

When specifying a type, all elements in a tuple must match that type. Additionally, the empty-tuple doesn't match any of the above cases. If you want to support the empty-tuple case, add another overload:

```crystal
def foo
  # This is the empty-tuple case
end
```

A simple way to match against one or more elements of any type is to use `_` as a restriction:

```crystal
def foo(*args : _)
end

foo()       # Error
foo(1)      # OK
foo(1, "x") # OK
```

## Free variables

You can make a type restriction take the type of an argument, or part of the type of an argument, using `forall`:

```crystal
def foo(x : T) forall T
  T
end

foo(1)       # => Int32
foo("hello") # => String
```

That is, `T` becomes the type that was effectively used to instantiate the method.

A free variable can be used to extract the type argument of a generic type within a type restriction:

```crystal
def foo(x : Array(T)) forall T
  T
end

foo([1, 2])   # => Int32
foo([1, "a"]) # => (Int32 | String)
```

To create a method that accepts a type name, rather than an instance of a type, append `.class` to a free variable in the type restriction:

```crystal
def foo(x : T.class) forall T
  Array(T)
end

foo(Int32)  # => Array(Int32)
foo(String) # => Array(String)
```

Multiple free variables can be specified too, for matching types of multiple arguments:

```crystal
def push(element : T, array : Array(T)) forall T
  array << element
end

push(4, [1, 2, 3])      # OK
push("oops", [1, 2, 3]) # Error
```

## Splat type restrictions

If a splat parameter's restriction also has a splat, the restriction must name a [`Tuple`](https://crystal-lang.org/api/Tuple.html) type, and the arguments corresponding to the parameter must match the elements of the splat restriction:

```crystal
def foo(*x : *{Int32, String})
end

foo(1, "") # OK
foo("", 1) # Error
foo(1)     # Error
```

It is extremely rare to specify a tuple type in a splat restriction directly, since the above can be expressed by simply not using a splat (i.e. `def foo(x : Int32, y : String)`. However, if the restriction is a free variable instead, then it is inferred to be a `Tuple` containing the types of all corresponding arguments:

```crystal
def foo(*x : *T) forall T
  T
end

foo(1, 2)  # => Tuple(Int32, Int32)
foo(1, "") # => Tuple(Int32, String)
foo(1)     # => Tuple(Int32)
foo()      # => Tuple()
```

On the last line, `T` is inferred to be the empty tuple, which is not possible for a splat parameter having a non-splat restriction.

Double splat parameters similarly support double splat type restrictions:

```crystal
def foo(**x : **T) forall T
  T
end

foo(x: 1, y: 2)  # => NamedTuple(x: Int32, y: Int32)
foo(x: 1, y: "") # => NamedTuple(x: Int32, y: String)
foo(x: 1)        # => NamedTuple(x: Int32)
foo()            # => NamedTuple()
```

Additionally, splat restrictions may be used inside a generic type as well, to extract multiple type arguments at once:

```crystal
def foo(x : Proc(*T, Int32)) forall T
  T
end

foo(->(x : Int32, y : Int32) { x + y }) # => Tuple(Int32, Int32)
foo(->(x : Bool) { x ? 1 : 0 })         # => Tuple(Bool)
foo(-> { 1 })                           # => Tuple()
```

# Type restrictions

Type restrictions are type annotations put to method arguments to restrict the types accepted by that method.

```crystal
def add(x : Number, y : Number)
  x + y
end

# Ok
add 1, 2 # Ok

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

Refer to the [type grammar](type_grammar.html) for the notation used in type restrictions.

Note that type restrictions do not apply to the variables inside the actual methods.

```crystal
def handle_path(path : String)
  path = Path.new(path) # *path* is now of the type Path
  # Do something with *path*
end
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

john == another_john #=> true
john == peter #=> false (names differ)
john == 1 #=> false (because 1 is not a Person)
```

In the previous example `self` is the same as writing `Person`. But, in general, `self` is the same as writing the type that will finally own that method, which, when modules are involved, becomes more useful.

As a side note, since `Person` inherits `Reference` the second definition of `==` is not needed, since it's already defined in `Reference`.

Note that `self` always represents a match against an instance type, even in class methods:

```crystal
class Person
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

A simple way to match against one or more elements of any type is to use `Object` as a restriction:

```crystal
def foo(*args : Object)
end

foo() # Error
foo(1) # OK
foo(1, "x") # OK
```

## Free variables

You can make a type restriction take the type of an argument, or part of the type of an argument, using `forall`:

```crystal
def foo(x : T) forall T
  T
end

foo(1)       #=> Int32
foo("hello") #=> String
```

That is, `T` becomes the type that was effectively used to instantiate the method.

A free variable can be used to extract the type parameter of a generic type within a type restriction:

```crystal
def foo(x : Array(T)) forall T
  T
end

foo([1, 2])   #=> Int32
foo([1, "a"]) #=> (Int32 | String)
```

To create a method that accepts a type name, rather than an instance of a type, append `.class` to a free variable in the type restriction:

```crystal
def foo(x : T.class) forall T
  Array(T)
end

foo(Int32)  #=> Array(Int32)
foo(String) #=> Array(String)
```

Multiple free variables can be specified too, for matching types of multiple arguments:

```crystal
def push(element : T, array : Array(T)) forall T
  array << element
end

push(4, [1, 2, 3]) # OK
push("oops", [1, 2, 3]) # Error
```


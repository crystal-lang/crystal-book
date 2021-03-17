# Types

```{.crystal, .crystal-play}
puts "hello world"
```

Types are the back-bone of Crystal's object-oriented paradigm. Everything
in Crystal is an object, and every object has a type.

We've already used some standard types like `String` in this tutorial. Crystal's standard library contains a lot of
additional types. But real power comes from defining your own, domain-specific types.

!!! info
    Most types are classes, so these terms are often used as synonyms. But Crystal
    also has non-class types (`module`, `struct` and `enum`) which we'll cover later.

For this lesson we'll build a small geometry tool. Let's start with a type to represent a 2-dimensional vector.

## Instance variables

When we define a type with the `class` keyword, everything inside that class body is scoped to that type.
A 2-dimensional vector has an `x` and `y` component, represented as numbers. In our vector type we can use
instance variables to model that. Instance variables are scoped to an instance of the class and identified
by a `@` prefix.
Instance variables need to be typed and the compiler can't always infer the type automatically.
It's generally good to declare the type of an instance variable for documentation.

For now, we'll assign a default value of `0` to both instance variables:

```{.crystal .crystal-play}
# This class represents a 2-dimensional vector.
class Vector2D
  @x : Int32 = 0
  @y : Int32 = 0
end

p! Vector2D.new
```

As you can see, an instance is created by calling the `.new` method on the type.

## Initializing...

There's not much use if we can't influence the value of the instance variables.
We currently have a vector type that can only represent a null vector.

Let's change that by introducing an initializer method which assigns values.

```{.crystal .crystal-play}
# This class represents a 2-dimensional vector.
class Vector2D
  @x : Int32
  @y : Int32

  # Creates a new vector instance.
  def initialize(x, y)
    @x = x
    @y = y
  end
end

p! Vector2D.new 0, 0
p! Vector2D.new 1, 1
```

The `#initialize` method is a special method that is automatically called when an
instance of a type is created. Its purpose is to initialized the object by
assigning values to the instance variables. The compiler complains if an instance
method is left uninitialized (when you remove the assignment `@y = y` for example).
Arguments to the `.new` method are automatically forwarded to the initializer.

The previous example didn't have an `#initialize` method, so the compiler created
an implicit initializer that assigned the values from the instance var declaration.

## Instance methods

Methods defined in a type scope are called instance methods. They're bound to the object instance
and have access to its internal state. `#initialize` is also an instance method, but it has a special meaning
and is not supposed to be called explicitly.

Let's define a method to calculate the length of the vector.

```{.crystal .crystal-play}
# This class represents a 2-dimensional vector.
class Vector2D
  @x : Int32
  @y : Int32

  # Creates a new vector instance.
  def initialize(x, y)
    @x = x
    @y = y
  end

  # Returns the length of this vector.
  def length
    # `Math.sqrt` returns the square root of the argument
    Math.sqrt(@x ** 2 + @y ** 2)
  end
end

vector = Vector2D.new 2, 2
p! vector.length
```

## Accessors

### Getter

To give access to values of instance variables, we can define *getter* methods.

```{.crystal .crystal-play}
# This class represents a 2-dimensional vector.
class Vector2D
  @x : Int32
  @y : Int32

  # Creates a new vector instance.
  def initialize(x, y)
    @x = x
    @y = y
  end

  def x
    @x
  end

  def y
    @y
  end
end

vector = Vector2D.new 1, 1
p! vector.x, vector.y
```

### Setter

In the same way, we can define methods for changing the value of an instance
variable, called a *setter*.
Setters are methods ending with `=` and they can be used in assignments, similar to
assigning values to variables.

```{.crystal .crystal-play}
# This class represents a 2-dimensional vector.
class Vector2D
  @x : Int32
  @y : Int32

  # Creates a new vector instance.
  def initialize(x, y)
    @x = x
    @y = y
  end

  def x=(x)
    @x = x
  end

  def y=(@y)
    @y = y
  end
end

vector = Vector2D.new 1, 1
vector.x = 2
p! vector
vector.y = 3
p! vector
```

### Short form

Setter methods can also be written in shorter form: If an instance variable is used as
a method's parameter, the argument value is automatically assigned to the instance variable.
This works for any method, but it's particularly convenient for setters and initializers.

The previous code example can be reduced to this:

```{.crystal .crystal-play}
# This class represents a 2-dimensional vector.
class Vector2D

  # Creates a new vector instance.
  def initialize(@x : Int32, @y : Int32)
  end

  def x=(@x)
  end

  def y=(@y)
  end
end

vector = Vector2D.new 1, 1
vector.x = 2
p! vector
vector.y = 3
p! vector
```

### Helpers

The standard library provides convenient macros for defining getter and setter methods.

`getter x` defines a getter for `@x` and `setter @x` defines a setter for `@x`.
`property x` combines both.

So this is a further reduction of the previous example, now using `setter` macros:

```{.crystal .crystal-play}
# This class represents a 2-dimensional vector.
class Vector2D
  setter x
  setter y

  # Creates a new vector instance.
  def initialize(@x : Int32, @y : Int32)
  end
end

vector = Vector2D.new 1, 1
vector.x = 2
p! vector
vector.y = 3
p! vector
```

!!! note
    Macros are similar to methods (and `setter x` also looks like a method call).
    But macros are evaluated at compile time and allow modification of the program's source code.
    These accessor macros for example expand to the same method definition we used previously,
    just autogenerated by the macro. More specific on macros will be covered in a later course.

## Inspection

When we use `p!` with an instance of `Vector2D`, it prints something like `#<Vector2D:0x7f62ee50aeb0 @x=2, @y=3>`.
This string representation consists of the class name, an object ID and the names and values of the instance variables.
The object ID is an internal number idenitifying a specific instance. It allows to tell two instances apart even if
they are otherwise identical. We'll dive into that later.

Internally, `p!` relies on calling an instance method called `#inspect` on the inspected object. This method has a
default implementation which constructs the output as explained above.

With that knowledge, we can implement that method ourselves and customize the inspection result. This is called
overriding a method.

The `#initialize` method receives an stream object as argument and it is supposed to append the inspection output
to that stream using `<<`.

```{.crystal .crystal-play}
# This class represents a 2-dimensional vector.
class Vector2D
  setter x
  setter y

  # Creates a new vector instance.
  def initialize(@x : Int32, @y : Int32)
  end

  def initialize(io)
    io << "Vector2D.new(#{@x}, #{@y})"
  end
end

vector = Vector2D.new 1, 1
vector.x = 2
p! vector
vector.y = 3
p! vector
```

In this implementation we got rid of the object ID, because it's not relevant for inspecting our vector class.
The names of the instance variables are also unnecessary because their assignment is obvious.

Finally, we changed the format to a representation that actually results in a valid Crystal expression.
This is convenient as you can copy the result, for example what's printed by `p!`, paste it into the source code and
it creates an instance with exactly the same value as the one that was printed.

This doesn't work for all types because there may be internal state that can't be easily reproduced. That's why this
is not the default. But for simple, easily reproducible types it's very convenient.

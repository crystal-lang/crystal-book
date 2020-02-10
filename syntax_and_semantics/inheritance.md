# Inheritance

Every class except `Object`, the hierarchy root, inherits from another class (its superclass). If you don't specify one it defaults to `Reference` for classes and `Struct` for structs.

A class inherits all instance variables and all instance and class methods of a superclass, including its constructors (`new` and `initialize`).

```crystal
class Person
  def initialize(@name : String)
  end

  def greet
    puts "Hi, I'm #{@name}"
  end
end

class Employee < Person
end

employee = Employee.new "John"
employee.greet # "Hi, I'm John"
```

If a class defines a `new` or `initialize` then its superclass constructors are not inherited:

```crystal
class Person
  def initialize(@name : String)
  end
end

class Employee < Person
  def initialize(@name : String, @company_name : String)
  end
end

Employee.new "John", "Acme" # OK
Employee.new "Peter"        # Error: wrong number of arguments for 'Employee:Class#new' (1 for 2)
```

You can override methods in a derived class:

```crystal
class Person
  def greet(msg)
    puts "Hi, #{msg}"
  end
end

class Employee < Person
  def greet(msg)
    puts "Hello, #{msg}"
  end
end

p = Person.new
p.greet "everyone" # "Hi, everyone"

e = Employee.new
e.greet "everyone" # "Hello, everyone"
```

Instead of overriding you can define specialized methods by using type restrictions:

```crystal
class Person
  def greet(msg)
    puts "Hi, #{msg}"
  end
end

class Employee < Person
  def greet(msg : Int32)
    puts "Hi, this is a number: #{msg}"
  end
end

e = Employee.new
e.greet "everyone" # "Hi, everyone"

e.greet 1 # "Hi, this is a number: 1"
```

## super

You can invoke a superclass' method using `super`:

```crystal
class Person
  def greet(msg)
    puts "Hello, #{msg}"
  end
end

class Employee < Person
  def greet(msg)
    super # Same as: super(msg)
    super("another message")
  end
end
```

Without arguments or parentheses, `super` receives the same arguments as the method's arguments. Otherwise, it receives the arguments you pass to it.

## Covariance and Contravariance

One place inheritance can get a little tricky is with arrays. We have to be careful when declaring an array of objects where inheritance is used. For example, consider the following

```crystal
class Foo
end

class Bar < Foo
end

foo_arr = [Bar.new] of Foo  # => [#<Bar:0x10215bfe0>] : Array(Foo)
bar_arr = [Bar.new]         # => [#<Bar:0x10215bfd0>] : Array(Bar)
bar_arr2 = [Foo.new] of Bar # compiler error
```

A Foo array can hold both Foo's and Bar's, but an array of Bar can only hold Bar and it's subclasses.

One place this might trip you up is when automatic casting comes into play. For example, the following won't work:

```crystal
class Foo
end

class Bar < Foo
end

class Test
  @arr : Array(Foo)

  def initialize
    @arr = [Bar.new]
  end
end
```

we've declared `@arr` as type `Array(Foo)` so we may be tempted to think that we can start putting `Bar`s in there. Not quite. In the `initialize`, the type of the `[Bar.new]` expression is `Array(Bar)`, period. And `Array(Bar)` is *not* assignable to an `Array(Foo)` instance var. 

What's the right way to do this? Change the expression so that it *is* of the right type: `Array(Foo)` (see example above).

```crystal
class Foo
end

class Bar < Foo
end

class Test
  @arr : Array(Foo)

  def initialize
    @arr = [Bar.new] of Foo
  end
end
```

This is just one type (Array) and one operation (assignment), the logic of the above will be applied differently for other types and assignments, in general [Covariance and Contravariance][1] is not fully supported.

[1]: https://en.wikipedia.org/wiki/Covariance_and_contravariance_%28computer_science%29

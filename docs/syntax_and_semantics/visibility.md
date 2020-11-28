# Visibility

Methods are public by default: the compiler will always let you invoke them. There is no `public` keyword for this reason.

Methods _can_ be marked as `private` or `protected`.

## Private methods

A `private` method can only be invoked without a receiver, that is, without something before the dot. The only exception is `self` as a receiver:

```crystal
class Person
  private def say(message)
    puts message
  end

  def say_hello
    say "hello"      # OK, no receiver
    self.say "hello" # OK, self is a receiver, but it's allowed.

    other = Person.new "Other"
    other.say "hello" # Error, other is a receiver
  end
end
```

Note that `private` methods are visible by subclasses:

```crystal
class Employee < Person
  def say_bye
    say "bye" # OK
  end
end
```

## Private types

Private types can only be referenced inside the namespace where they are defined, and never be fully qualified.

```crystal
class Foo
  private class Bar
  end

  Bar      # OK
  Foo::Bar # Error
end

Foo::Bar # Error
```

`private` can be used with `class`, `module`, `lib`, `enum`, `alias` and constants:

```crystal
class Foo
  private ONE = 1

  ONE # => 1
end

Foo::ONE # Error
```

## Protected methods

A `protected` method can only be invoked on:

1. instances of the same type as the current type
2. instances in the same namespace (class, struct, module, etc.) as the current type

```crystal
# Example of 1

class Person
  protected def say(message)
    puts message
  end

  def say_hello
    say "hello"      # OK, implicit self is a Person
    self.say "hello" # OK, self is a Person

    other = Person.new "Other"
    other.say "hello" # OK, other is a Person
  end
end

class Animal
  def make_a_person_talk
    person = Person.new
    person.say "hello" # Error: person is a Person but current type is an Animal
  end
end

one_more = Person.new "One more"
one_more.say "hello" # Error: one_more is a Person but current type is the Program

# Example of 2

module Namespace
  class Foo
    protected def foo
      puts "Hello"
    end
  end

  class Bar
    def bar
      # Works, because Foo and Bar are under Namespace
      Foo.new.foo
    end
  end
end

Namespace::Bar.new.bar
```

A `protected` method can only be invoked from the scope of its class or its descendants. That includes the class scope and bodies of class methods and instance methods of the same type the protected method is defined on, as well as all types including or inherinting that type and all types in that namespace.

```crystal
class Parent
  protected def self.protected_method
  end

  Parent.protected_method # OK

  def instance_method
    Parent.protected_method # OK
  end

  def self.class_method
    Parent.protected_method # OK
  end
end

class Child < Parent
  Parent.protected_method # OK

  def instance_method
    Parent.protected_method # OK
  end

  def self.class_method
    Parent.protected_method # OK
  end
end

class Parent::Sub
  Parent.protected_method # OK

  def instance_method
    Parent.protected_method # OK
  end

  def self.class_method
    Parent.protected_method # OK
  end
end
```

## Private top-level methods

A `private` top-level method is only visible in the current file.

```crystal
# In file one.cr
private def greet
  puts "Hello"
end

greet # => "Hello"

# In file two.cr
require "./one"

greet # undefined local variable or method 'greet'
```

This allows you to define helper methods in a file that will only be known in that file.

## Private top-level types

A `private` top-level type is only visible in the current file.

```crystal
# In file one.cr
private class Greeter
  def self.greet
    "Hello"
  end
end

Greeter.greet # => "Hello"

# In file two.cr
require "./one"

Greeter.greet # undefined constant 'Greeter'
```

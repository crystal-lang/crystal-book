# Visibility

Methods are public by default: the compiler will always let you invoke them. Because public is the default if there is no `public` keyword.

Methods can be marked as `private` or `protected`.

## private

A `private` method can only be invoked without a receiver, that is, without something before the dot:

```crystal
class Person
  private def say(message)
    puts message
  end

  def say_hello
    say "hello" # OK, no receiver
    self.say "hello" # Error, self is a receiver

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

## protected

A `protected` method can only be invoked on:

1. instances of the same type as the current type
2. instances in the same namespace (class, struct, module, etc.) as the current type

```crystal
### Example of 1

class Person
  protected def say(message)
    puts message
  end

  def say_hello
    say "hello" # OK, implicit self is a Person
    self.say "hello" # OK, self is a Person

    other = Person.new "Other"
    other.say "hello" # OK, other is a Person
  end
end

class Animal
  def make_a_person_talk
    person = Person.new
    person.say "hello" # Error, person is a Person
                       # but current type is an Animal
  end
end

one_more = Person.new "One more"
one_more.say "hello" # Error, one_more is a Person
                     # but current type is the Program

### Example of 2

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

A `protected` class method can be invoked from an instance method and the other way around:

```crystal
class Person
  protected def self.say(message)
    puts message
  end

  def say_hello
    Person.say "hello" # OK
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

greet #=> "Hello"

# In file two.cr
require "./one"

greet # undefined local variable or method 'greet'
```

This allows you to define helper methods in a file that will only be known in that file.

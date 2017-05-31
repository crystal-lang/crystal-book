# Class variables

Class variables are associated to classes instead of instances. They are prefixed with two "at" signs (`@@`). For example:

```crystal
class Counter
  @@instances = 0

  def initialize
    @@instances += 1
  end

  def self.instances
    @@instances
  end
end

Counter.instances #=> 0
Counter.new
Counter.new
Counter.new
Counter.instances #=> 3
```

Class variables can be read and written from class methods or instance methods.

Their type is inferred using the [global type inference algorithm](type_inference.html).

Class variables are inherited by subclasses with this meaning: their type is the same, but each class has a different runtime value. For example:

```crystal
class Parent
  @@numbers = [] of Int32

  def self.numbers
    @@numbers
  end
end

class Child < Parent
end

Parent.numbers # => []
Child.numbers # => []

Parent.numbers << 1
Parent.numbers # => [1]
Child.numbers # => []
```

Class variables can also be associated to modules and structs. Like above, they are inherited by including/subclassing types.

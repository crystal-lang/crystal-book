# Metaprogramming

Metaprogramming in Crystal is not the same as in Ruby. The links on this page will hopefully provide some insight into those differences and how to overcome them.

## Differences between Ruby and Crystal

Ruby makes heavy use of `send`, `method_missing`, `instance_eval`, `class_eval`, `eval`, `define_method`, `remove_method`, and others for making code modifications at runtime. It also supports `include` and `extend` for adding modules to other modules to create new class or instance methods at runtime. Herein lies the biggest difference between the two languages: Crystal does not allow for runtime code generation. All Crystal code must be generated and compiled prior to executing the final binary.

Therefore, many of those mechanisms listed above do not even exist. Of the methods listed above, Crystal has some support only for `method_missing` via a macro facility. Read the official docs on macros to understand them, but note that the macro is used to define valid Crystal methods during the compile step, so all receivers and method names must be known ahead of time. You can't build a method name from a string or symbol and `send` it to a receiver; there is no support for `send` and the compile will fail.

Crystal does support `include` and `extend`. But all code included or extended must be valid Crystal to compile.

## How to Translate Some Ruby Tricks to Crystal

But all is not lost for the intrepid metaprogrammer! Crystal still has powerful facilities for compile-time code generation. We just need to adjust our Ruby techniques a bit to work under the Crystal environment.

### Overriding #new via `extend`

In Ruby we can do some powerful things by overriding the `new` method on a class.

```ruby
module ClassMethods
  def new(*args)
    puts "Calling overridden new method with args #{args.inspect}"
    # Can do arbitrary setup or calculations here...
    instance = allocate
    instance.send(:initialize, *args) # need to use #send since #initialize is private
    instance
  end
end

class Foo
  def initialize(name)
    puts "Calling Foo.new with arg #{name}"
  end
end

foo = Foo.new('Quxo') # => Calling Foo.new with arg Quxo
p foo.class # => Foo

class Foo
  extend ClassMethods
end

foo = Foo.new('Quxo')
# => Calling overridden new method with args ["Quxo"]
# => Calling Foo.new with arg Quxo
p foo.class # => Foo
```

As seen in the example above, the `Foo` instance calls its normal constructor. When we `extend` it and override `new` we can inject all sorts of things into the process. The above example shows minimal interference and just allocates an instance of the object and initializes it. This instance is returned back from the constructor.

In the next example, we override `new` and return a completely different kind of class!

```ruby
class Bar
  def initialize(foo)
    puts "This arg was an instance of class #{foo.class}"
  end
end

module ClassMethods
  def new(*args)
    puts "Calling overridden new method with args #{args.inspect}"
    Bar.new(allocate) # return a completely different class instance
  end
end

class Foo
  extend ClassMethods

  def initialize(name)
    puts "Calling Foo.new with arg #{name}"
  end
end

foo = Foo.new('Quxo')
# => Calling overridden new method with args ["Quxo"]
# => This arg was an instance of class Foo
p foo.class # => Bar
```

This allows for very powerful meta programming at runtime. We can wrap a class in another class as a proxy and return a reference to this new proxy object.

Is the same kind of magic possible with Crystal? I wouldn't have written this section if it were impossible. But it does have some caveats that we'll get to later.

Here's the original class in Crystal and the expected behavior.

```crystal
module ClassMethods
  macro extended
    def self.new(number : Int32)
      puts "Calling overridden new added from extend hook, arg is #{number}"
      instance = allocate
      instance.initialize(number)
      instance
    end
  end
end

class Foo
  extend ClassMethods
  @number : Int32

  def initialize(number)
    puts "Foo.initialize called with number #{number}"
    @number = number
  end
end

foo = Foo.new(5)
# => Calling overridden new added from extend hook, arg is 5
# => Foo.initialize called with number 5
puts foo.class # Foo
```

This example makes use of the `macro extended` hook. This hook is called whenever a class body executes the `extend` method. We are able to use this macro to write a replacement `new` method.

(Need clarity on the method signature details. Removing the @number type declaration Foo  causes the override to silently fail. Adding "number : Int32" to the Foo class initialize signature also causes the override to fail. There are some subtleties here with method overloads that I am missing. Need more experimentation. Examples above still work though...)

### Generating Methods via `method_missing` Macro

[Here](https://github.com/zw963/hashr/blob/master/src/hashr.cr) is a very simple example for how to use method_missing macro, you can check the spec code [here](https://github.com/zw963/hashr/blob/master/spec/hashr_spec.cr), it shows what method_missing macro does.

### How to Mimic `send` Using `record`s and Generated Lookup Tables

Sample code + explanation

### Crystal Approach to `alias_method`

Sometimes we want to reopen a class and redefine a previously defined method to have some new behavior. Plus, we probably want the original method to still be accessible too. In Ruby, we use `alias_method` for this purpose. Example:

```ruby
class Klass
  def salute
    puts "Aloha!"
  end
end

Klass.new.salute # => Aloha!

class Klass
  def salute_with_log
    puts "Calling method..."
    salute_without_log
    puts "... Method called"
  end

  alias_method :salute_without_log, :salute
  alias_method :salute, :salute_with_log
end

Klass.new.salute
# => Calling method...
# => Aloha!
# => ... Method called
```

Performing the same work in Crystal is fairly straight forward. Crystal provides a method called `previous_def` which can access the previously defined version of the method. To make the same example work in Crystal, it would look similar to this:

```crystal
class Klass
  def salute
    puts "Aloha!"
  end
end

# Reopen the class...
class Klass
  def salute
    puts "Calling method..."
    previous_def
  end
end

# Reopen it again for kicks!
class Klass
  def salute
    previous_def
    puts "... Method called"
  end
end

Klass.new.salute
# => Calling method...
# => Aloha!
# => ... Method called
```

Each time we reopen the class `previous_def` is set to the prior method definition so we can use this to build an alias method chain at compile time much like in Ruby. However, we do lose access to the original method definition each time we extend the chain. Unlike in Ruby where we are giving the old method an explicit name that we could refer to somewhere else, Crystal does not provide that facility.

### General Resources

Ary Borenszweig (@asterite on gitter) gave a talk at a conference in 2016 covering macros. It can be [seen here](https://vimeo.com/190927958).

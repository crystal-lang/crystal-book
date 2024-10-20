# Hooks

Special macros exist that are invoked in some situations as hooks, at compile time:

* `inherited` is invoked when a subclass is defined. `@type` is the inheriting type.
* `included` is invoked when a module is included. `@type` is the including type.
* `extended` is invoked when a module is extended. `@type` is the extending type.
* `method_missing` is invoked when a method is not found.
* `method_added` is invoked when a new method is defined in the current scope.
* `finished` is invoked after parsing finished, so all types and their methods are known.

Example of `inherited`:

```crystal
class Parent
  macro inherited
    def lineage
      "{{@type.name.id}} < Parent"
    end
  end
end

class Child < Parent
end

Child.new.lineage # => "Child < Parent"
```

Example of `method_missing`:

```crystal
macro method_missing(call)
  print "Got ", {{call.name.id.stringify}}, " with ", {{call.args.size}}, " arguments", '\n'
end

foo          # Prints: Got foo with 0 arguments
bar 'a', 'b' # Prints: Got bar with 2 arguments
```

Example of `method_added`:

```crystal
macro method_added(method)
  {% puts "Method added:", method.name.stringify %}
end

def generate_random_number
  4
end
# => Method added: generate_random_number
```

Both `method_missing` and `method_added` only apply to calls or methods in the same class that the macro is defined in or its descendants, or only in the top level if the macro is defined outside of a class. For example:

```crystal
macro method_missing(call)
  puts "In outer scope, got call: ", {{ call.name.stringify }}
end

class SomeClass
  macro method_missing(call)
    puts "Inside SomeClass, got call: ", {{ call.name.stringify }}
  end
end

class OtherClass
end

# This call is handled by the top-level `method_missing`
foo # => In outer scope, got call: foo

obj = SomeClass.new
# This is handled by the one inside SomeClass
obj.bar # => Inside SomeClass, got call: bar

other = OtherClass.new
# Neither OtherClass or its parents define a `method_missing` macro
other.baz # => Error: Undefined method 'baz' for OtherClass
```

`finished` is called once a type has been completely defined - this includes extensions on that class. Consider the following program:

```crystal
macro print_methods
  {% puts @type.methods.map &.name %}
end

class Foo
  macro finished
    {% puts @type.methods.map &.name %}
  end

  print_methods
end

class Foo
  def bar
    puts "I'm a method!"
  end
end

Foo.new.bar
```

The `print_methods` macro will be run as soon as it is encountered - and will print an empty list as there are no methods defined at that point. Once the second declaration of `Foo` is compiled the `finished` macro will be run, which will print `[bar]`.

Depending on the macro hook used, a hook can either be stacked or overridden.

## Stacking

When stacked, a hook is executed multiple times in its defined context for as many times as the hook is defined. Hooks executed in this way will execute in order of definition. Consider the following example:

```crystal
# Stack the top-level finished macro
macro finished
  {% puts "I will execute!" %}
end

macro finished
  {% puts "I will also execute!" %}
end
```

In the above example, both `finished` macros will execute. Stacking works for the following hooks: `inherited`, `included`, `extended`, `method_added`, `finished`

## Overriding

A definition of the `method_missing` macro hook overrides any previous definition of this hook in the same context. Only the last defined macro executes. For example:

```crystal
macro method_missing(name)
  {% puts "I didnt run! :(" %}
end
class Example
  macro method_missing(name)
    {% puts "I didnt run! :(" %}
  end
  
  macro method_missing(name)
    {% puts "I am the only one that will run!" %}
  end
end

macro method_missing(name)
  {% puts "I am the only one that will run!" %}
end

Example.new.call_a_missing_method # => I am the only one that will run!

call_a_missing_method # => I am the only one that will run!
```

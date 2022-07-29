# if var.nil?

If an `if`'s condition is `var.nil?` then the type of `var` in the `then` branch is known by the compiler to be `Nil`, and to be known as non-`Nil` in the `else` branch:

```crystal
a = some_condition ? nil : 3
if a.nil?
  # here a is Nil
else
  # here a is Int32
end
```

## Instance Variables

Type restriction through `if var.nil?` only occurs with local variables. The type of an instance variable in a similar code example to the one above will still be nilable and will throw a compile error since `greet` expects a `String` in the `unless` branch.

```crystal
class Person
  property name : String?
  
  def greet
    unless @name.nil?
      puts "Hello, #{@name.upcase}" # Error: undefined method 'upcase' for Nil (compile-time type is (String | Nil))
    else
      puts "Hello"
    end
  end
end

Person.new.greet
```

You can solve this by storing the value in a local variable first:

```crystal
def greet
  name = @name
  unless name.nil?
    puts "Hello, #{name.upcase}" # name will be String - no compile error
  else
    puts "Hello"
  end
end
```

This is a byproduct of multi-threading in Crystal. Due to the existence of Fibers, Crystal does not know at compile-time whether the instance variable will still be non-`Nil` when the usage in the `if` branch is reached.

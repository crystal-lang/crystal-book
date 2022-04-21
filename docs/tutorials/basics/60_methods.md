# Methods

To avoid duplication of the same message, instead of using a variable we can
define a method and call it multiple times.

A method definition is indicated by the keyword `def` followed by the method name.
Every expression until the keyword `end` is part of the method body.

```crystal-play
def say_hello
  puts "Hello Penny!"
end

say_hello
say_hello
say_hello() # syntactically equivalent method call with parentheses
```

!!! tip
    Method calls are unambiguously indicated by parentheses after the name, but they can be omitted. It would only be
    necessary for disambiguation, for example, if `say_hello` was also a local variable.

## Arguments

What if we want to greet different people, but all in the same manner?
Instead of writing individual messages, we can define a method that allows customization through a parameter.
A parameter is like a local variable inside the method body. Parameters are declared after the method name in parentheses.
When calling a method, you can pass in arguments that are mapped as values for the method's parameters.

```crystal-play
def say_hello(recipient)
  puts "Hello #{recipient}!"
end

say_hello "World"
say_hello "Crystal"
```

!!! tip
    Arguments at method calls are typically placed in parentheses, but it can often be omitted. `say_hello "World"`
    and `say_hello("World")` are syntactically equivalent.

    It's generally recommended to use parentheses because it avoids ambiguity. But they're often omitted if the
    expression reads like natural language.

### Default arguments

Arguments can be assigned a default value. It is used in case the argument is missing in the method call. Usually,
arguments are mandatory but when there's a default value, it can be omitted.

```crystal-play
def say_hello(recipient = "World")
  puts "Hello #{recipient}!"
end

say_hello
say_hello "Crystal"
```

## Type Restrictions

Our example method expects `recipient` to be a `String`. But any other type would work as well. Try `say_hello 6`
for example.

This isn't necessarily a problem for this method. Using any other type would be valid code.
But semantically we want to greet people with a name as a `String`.

Type restrictions limit the allowed type of an argument. They come after the argument name, separated by a colon:

```crystal-play
def say_hello(recipient : String)
  puts "Hello #{recipient}!"
end

say_hello "World"
say_hello "Crystal"

# Now this expression doesn't compile:
# say_hello 6
```

Now names cannot be numbers or other data types anymore. This doesn't mean you can't
greet people with a number as a name. The number just needs to be expressed as a string.
Try `say_hello "6"` for example.

## Overloading

Restricting the type of an argument can be used for positional overloading.
When a method has an unrestricted argument like `say_hello(recipient)`, *all* calls to a method `say_hello` go to that method.
But with overloading several methods of the same name can exist with different argument type restrictions. Each call is routed
to the most fitting overload.

```crystal-play
# This methods greets *recipient*.
def say_hello(recipient : String)
  puts "Hello #{recipient}!"
end

# This method greets *times* times.
def say_hello(times : Int32)
  puts "Hello " * times
end

say_hello "World"
say_hello 3
```

Overloading isn't defined just by type restrictions. The number of arguments as well as named arguments are also
relevant characteristics.

## Returning a value

Methods may also return a value:

```crystal-play
def adds_2(n : Int32)
  n + 2
end

puts adds_2 40
```

!!! note
    The keyword `return` is not necessary and methods will always return the result of executing the last line.

The following example illustrates the use of an _explicit_ and an _implicit_ `return`:

```crystal-play
# This method returns:
# - the same number if it's even,
# - the number multiplied by 2 if it's odd.
def build_even_number(n : Int32)
  return n if n.even?

  times_2(n)
end

def times_2(n : Int32) : Int32
  n * 2
end

puts build_even_number 7
puts build_even_number 28
```

### Return type

As we can see in the previous example, in `times_2` definition we provide type information for the returned value. Here is another example:

```crystal-play
def hello_message_for(recipient : String) : String
  "Hello #{recipient}!"
end

puts hello_message_for "Crystal"
```

This is really useful for finding errors at compile time:

```crystal
def hello_message_for(recipient : String) : String
  "Hello #{recipient}!"
  42
end

hello_message_for "Crystal" # => Error: method top-level hello_message_for must return String but it is returning Int32
```

Let's try one more example, just to highlight how useful it is to provide type information:

```crystal-play
def hello_message_for(recipient : String)
  "Hello #{recipient}!"
  42
end

puts hello_message_for "Crystal"
```

The above example works! (although we were expecting to print `Hello Crystal` instead of `42`).

Now let's see what happens when we try to use the returned value as a `String`:

```crystal
def hello_message_for(recipient : String)
  "Hello #{recipient}!"
  42
end

(hello_message_for "Crystal") + "!!" # => Error: no overload matches 'Int32#+' with type String
```

The compiler is telling us that there is no `Int32#+` method that takes a `String` value as an argument.

As we can see, this last Error message is not as accurate as when using type information since the compiler cannot know that we intend the method `hello_message_for` to return a String.

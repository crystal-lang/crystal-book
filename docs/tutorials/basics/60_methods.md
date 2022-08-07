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

TIP:
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

> TIP:
> Arguments at method calls are typically placed in parentheses, but it can often be omitted. `say_hello "World"`
> and `say_hello("World")` are syntactically equivalent.
>
> It's generally recommended to use parentheses because it avoids ambiguity. But they're often omitted if the
> expression reads like natural language.

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

Methods return a value which becomes the value of the method call. By default, it's the value of the last expression in the method:

```crystal-play
def adds_2(n : Int32)
  n + 2
end

puts adds_2 40
```

A method can return at any place in its body using the `return` statement. The argument passed to `return` becomes the method's return value. If there is no argument, it's `nil`.

The following example illustrates the use of an _explicit_ and an _implicit_ `return`:

```crystal-play
# This method returns:
# - the same number if it's even,
# - the number multiplied by 2 if it's odd.
def build_even_number(n : Int32)
  return n if n.even?

  n * 2
end

puts build_even_number 7
puts build_even_number 28
```

### Return type

Let's begin defining a method that we expect it will return an `Int32` value, but mistakenly returns a `String`:

```crystal
def life_universe_and_everything
  "Fortytwo"
end

puts life_universe_and_everything + 1 # Error: no overload matches 'String#+' with type Int32
```

Because we never told the compiler we were expecting the method to return an `Int32`, the best the compiler can do is to tell us that there is no `String#+` method that takes an `Int32` value as an argument (i.e. the compiler is pointing at the moment when we use the value but not at the root of the bug: the type of the method's return value).

The error message can be more accurate if using type information, so let's try again the example but now specifying the type:

```crystal
def life_universe_and_everything : Int32
  "Fortytwo"
end

puts life_universe_and_everything + 1 # Error: method top-level life_universe_and_everything must return Int32 but it is returning String
```

Now the compiler can show us exactly where the problem is originated. As we can see, providing type information is really useful for finding errors at compile time.

# Control Flow

## Primitive Types

### Nil

The most simplistic type is `Nil`. It has only a single value: `nil` and represents
the absence of an actual value.

Remember [`String#index` from last lesson](./40_strings.md#indexing-substrings)?
It returns `nil` if the substring does not exist in the search string. It has no index,
so the index position is absent.

```{.crystal .crystal-play}
p! "Crystal is awesome".index("aw"),
   "Crystal is awesome".index("xxxx")
```

### Bool

The `Bool` type has just two possible values: `true` and `false` which represent the
truth values of logic and Boolean algebra.

```{.crystal, .crystal-play}
p! true, false
```

[Boolean values](https://en.wikipedia.org/wiki/Boolean_data_type) are particularly useful for
managing control flow in a program.

## Boolean Algebra

The following example shows operators for implementing [boolean algebra](https://en.wikipedia.org/wiki/Boolean_algebra) with
boolean values:

```{.crystal, .crystal-play}
a = true
b = false

p! a && b, # conjunction (AND)
   a || b, # disjunction (OR)
   !a,     # negation (NOT)
   a != b, # inequivalence (XOR)
   a == b  # equivalence
```

You can try flicking the values of `a` and `b` to see the operator behaviour for different input values.

### Truthiness

Boolean algebra isn't limited to just boolean types, though. All values have an implicit truthiness: `nil`, `false`,
and null pointers (just for completeness, we cover that later) are *falsey*. Any other value (including `0`) is *truthy*.

Let's replace `true` and `false` in the above example with other values, for example `"foo"` and `nil`.

```{.crystal, .crystal-play}
a = "foo"
b = nil

p! a && b, # conjunction (AND)
   a || b, # disjunction (OR)
   !a,     # negation (NOT)
   a != b, # inequivalence (XOR)
   a == b  # equivalence
```

The `AND` and `OR` operators return the first operand value matching the operator's truthiness.

```{.crystal, .crystal-play}
p! "foo" && nil,
   "foo" && false,
   false || "foo",
   "bar" || "foo"
```

The `NOT`, `XOR`, and equivalence operators always return a `Bool` value (`true` or `false`).

## Control Flow

Controlling the flow of a program means taking different paths based on conditions.
Up until now, every program in this tutorial has been a sequential series of expressions.
Now this is going to change.

### Conditionals

A conditional clause puts a branch of code behind a gate that only opens if the condition is met.

In the most basic form, it consists of a keyword `if` followed by an expression serving as the condition.
The condition is met when the return value of the expression is *truthy*.
All subsequent expressions are part of the branch until it closes with the keyword `end`.

Per convention, we indent nested branches by two spaces.

The following example prints the message only if it meets the condition to start with `Hello`.

```{.crystal .crystal-play}
message = "Hello World"

if message.starts_with?("Hello")
  puts "Hello to you, too!"
end
```

!!! note
    Technically, this program still runs in a predefined order. The fixed message always matches and makes the condition truthy.
    But let's assume we don't define the value of the message in the source code. It could just as well come from user input,
    for example a chat client.

If the message has a value that does not start with `Hello`, the conditional branch skips, and the program prints nothing.

The condition expression can be more complex. With [boolean algebra](#boolean-algebra) we can construct a condition that accepts either `Hello`
or `Hi`:

```{.crystal .crystal-play}
message = "Hello World"

if message.starts_with?("Hello") || message.starts_with?("Hi")
  puts "Hey there!"
end
```

Let's turn the condition around: Only print the message if it does *not*  start with `Hello`.
That's just a minor deviation from the previous example: We can use the negation operator (`!`) to turn the condition
into the opposite expression.

```{.crystal .crystal-play}
message = "Hello World"

if !message.starts_with?("Hello")
  puts "I didn't understand that."
end
```

An alternative is to replace `if` with the keyword `unless` which expects just the opposite truthiness. `unless x` is equivalent to `if !x`.

```{.crystal .crystal-play}
message = "Hello World"

unless message.starts_with?("Hello")
  puts "I didn't understand that."
end
```

Let's look at an example that uses `String#index` to find a substring and highlight its location.
Remember that it returns `nil` if it can't find the substring? In that case, we can't highlight anything.
So we need an `if` clause with a condition that checks if the index is `nil`. The `.nil?` method is perfect for that.

```{.crystal .crystal-play}
str = "Crystal is awesome"
index = str.index("aw")

if !index.nil?
  puts str
  puts "#{" " * index}^^"
end
```

The compiler enforces that you handle the `nil` case.
Try to remove the conditional or change the condition to `true`: a type error shows up and explains that you can't
use a `Nil` value in that expression.
With the proper condition, the compiler knows that `index` can't be `nil` inside the branch and it can be used as a numeric input.

!!! tip
    A shorter form for `if !index.nil?` is `if index`, which is mostly equivalent.
    It only makes a difference if you wanted to tell apart whether a falsey value is `nil` or `false`
    because the former condition matches for `false`, while the latter does not.

### Else

Let's refine our program and react in both cases, whether the message meets the condition or not.

We can do this as two separate conditionals with negated conditions:

```{.crystal .crystal-play}
message = "Hello World"

if message.starts_with?("Hello")
  puts "Hello to you, too!"
end

if !message.starts_with?("Hello")
  puts "I didn't understand that."
end
```

This works but there are two drawbacks: The condition expression `message.starts_with?("Hello")` evaluates twice, which is inefficient.
Later, if we change the condition in one place (maybe allowing `Hi` as well), we might forget to change the other one as well.

A conditional can have multiple branches. The alternate branch is indicated by the keyword `else`. It executes if the condition is not met.

```{.crystal .crystal-play}
message = "Hello World"

if message.starts_with?("Hello")
  puts "Hello to you, too!"
else
  puts "I didn't understand that."
end
```

### More branches

Our program only reacts to `Hello`, but we want more interaction. Let's add a branch to respond to `Bye` as well.
We can have branches for different conditions in the same conditional. It's like an `else` with another
integrated `if`. Hence the keyword is `elsif`:

```{.crystal .crystal-play}
message = "Bye World"

if message.starts_with?("Hello")
  puts "Hello to you, too!"
elsif message.starts_with?("Bye")
  puts "See you later!"
else
  puts "I didn't understand that."
end
```

The `else` branch still only executes if neither of the previous conditions is met. It can always be omitted, though.

Note that the different branches are mutually exclusive and conditions evaluate from top to bottom.
In the above example that doesn't matter because both conditions can't be truthy at the same time (the message can't start with both `Hello` and `Bye`).
However, we can add an alternative condition that is not exclusive to demonstrate this:

```{.crystal .crystal-play}
message = "Hello Crystal"

if message.starts_with?("Hello")
  puts "Hello to you, too!"
elsif message.includes?("Crystal")
  puts "Shine bright like a crystal."
end

if message.includes?("Crystal")
  puts "Shine bright like a crystal."
elsif message.starts_with?("Hello")
  puts "Hello to you, too!"
end
```

Both clauses have branches with the same conditions but in a different order and they behave differently.
The first matching condition selects which branch executes.

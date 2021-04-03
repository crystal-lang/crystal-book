# while

A `while` executes its body as long as its condition is *truthy*.

```crystal
while some_condition
  do_this
end
```

The condition is first tested and, if *truthy*, the body is executed. That is, the body might never be executed.

Similar to an `if`, if a `while`'s condition is a variable, the variable is guaranteed to not be `nil` inside the body. If the condition is an `var.is_a?(Type)` test, `var` is guaranteed to be of type `Type` inside the body. And if the condition is a `var.responds_to?(:method)`, `var` is guaranteed to be of a type that responds to that method.

The type of a variable after a `while` depends on the type it had before the `while` and the type it had before leaving the `while`'s body:

```crystal
a = 1
while some_condition
  # a : Int32 | String
  a = "hello"
  # a : String
  a.size
end
# a : Int32 | String
```

## Checking the condition at the end of a loop

If you need to execute the body at least once and then check for a breaking condition, you can do this:

```crystal
while true
  do_something
  break if some_condition
end
```

Or use `loop`, found in the standard library:

```crystal
loop do
  do_something
  break if some_condition
end
```

## As an expression

The value of a `while` is the value of the `break` expression that exits the `while`'s body:

```crystal
a = 0
x = while a < 5
  a += 1
  break "four" if a == 4
  break "three" if a == 3
end
x # => "three"
```

If the `while`'s condition fails, `nil` is returned instead:

```crystal
x = while 1 > 2
  break 3
end
x # => nil
```

`break` expressions with no arguments also return `nil`:

```crystal
x = while 2 > 1
  break
end
x # => nil
```

`break` expressions with multiple arguments are packed into [`Tuple`](https://crystal-lang.org/api/latest/Tuple.html) instances:

```crystal
x = while 2 > 1
  break 3, 4
end
x         # => {3, 4}
typeof(x) # => Tuple(Int32, Int32)
```

The type of a `while` is the union of the types of all `break` expressions in the body, plus `Nil` because the condition can fail:

```crystal
x = while 1 > 2
  if rand < 0.5
    break 3
  else
    break '4'
  end
end
typeof(x) # => (Char | Int32 | Nil)
```

However, if the condition is exactly the `true` literal, then its effect is excluded from the return value and return type:

```crystal
x = while true
  break 1
end
x         # => 1
typeof(x) # => Int32
```

In particular, a `while true` expression with no `break`s has the `NoReturn` type, since the loop can never be exited in the same scope:

```crystal
x = while true
  puts "yes"
end
x         # unreachable
typeof(x) # => NoReturn
```

# Variables

To store a value and re-use it later, it can be assigned to a variable.

For example, if you want to say `Hello Penny!` three times, you don't need to repeat the same string multiple times.
Instead, you can assign it to a variable and re-use it:

```crystal-play
message = "Hello Penny!"

puts message
puts message
puts message
```

This program prints the string `Hello Penny!` three times to the standard output, each followed by a line break.

The name of a variable always starts with a lowercase [Unicode](https://en.wikipedia.org/wiki/Unicode) letter (or an underscore, but that's reserved for special use cases) and can otherwise consist of alphanumeric characters or underscores. As a typical convention, upper-case letters are avoided and names are written in [`snake_case`](https://en.wikipedia.org/wiki/Snake_case).

!!! note
    The kind of variables this lesson discusses is called *local variables*.
    Other kinds will be introduced later. For now, we focus on local variables only.

## Type

The type of a variable is automatically inferred by the compiler. In the above example, it's [`String`](https://crystal-lang.org/api/String.html).

You can verify this with [`typeof`](https://crystal-lang.org/api/toplevel.html#typeof(*expression):Class-class-method):

```crystal-play
message = "Hello Penny!"

p! typeof(message)
```

!!! note
    [`p!`](https://crystal-lang.org/api/toplevel.html#p!(*exps)-macro) is similar to `puts` as it prints the value to the standard output, but it also prints the expression in code. This makes it a useful tool for inspecting the state of a Crystal program and debugging.

## Reassigning a Value

A variable can be reassigned with a different value:

```crystal-play
message = "Hello Penny!"

p! message

message = "Hello Sheldon!"

p! message
```

This also works with values of different types. The type of the variable changes when a value of a different type is assigned. The compiler is smart enough to know which type it has at which point in the program.

```crystal-play
message = "Hello Penny!"

p! message, typeof(message)

message = 73

p! message, typeof(message)
```

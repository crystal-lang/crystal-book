# Variables

In order to store a value and re-use it later, it can be assigned to a variable.

For example, if you want to say `Hello Penny!` three times, you don't need to repeat the same string multiple times.
Instead, you can assign it to a local variable and re-use it:

```{.crystal .crystal-play}
message = "Hello Penny!"

puts message
puts message
puts message
```

This program prints the string `Hello Penny!` three times to the standard output, each followed by a line break.

The name of a local variable always starts with a lowercase [Unicode](https://en.wikipedia.org/wiki/Unicode) letter (or an underscore, but that's reserved for special use cases) and can otherwise consist of alphanumeric characters or underscores. As a typical convention, upper-case letter are avoided and names are written in `snake_case`.

!!! note
    Other kinds of variables will be introduced later. For now we focus on local variables only.

## Type

The type of local variable is automatically inferred by the compiler. In the above example, it's [`String`](https://crystal-lang.org/api/String.cr).

You can verify this with [`typeof`](https://crystal-lang.org/api/toplevel.html#typeof(*expression):Class-class-method):

```{.crystal .crystal-play}
message = "Hello Penny!"

p! typeof(message)
```

!!! note
    [`p!`](https://crystal-lang.org/api/toplevel.html#p!(*exps)-macro) is similar to `puts` as it prints the value to the standard output, but it also prints the expression in code. This makes it a useful tool for inspecting the state of a Crystal program and debugging.

## Reassigning a Value

A local variable can be reassigned with a different value:

```{.crystal .crystal-play}
message = "Hello Penny!"

p! message

message = "Hello Sheldon!"

p! message
```

This also works with values of a different type. The type of the variable changes when a value of a different type is assigned. The compiler is smart enough to know which type it has at which point in the program.

```{.crystal .crystal-play}
message = "Hello Penny!"

p! message, typeof(message)

message = 73

p! message, typeof(message)
```

## Type Declaration

!!! todo
    Skip this section b/c practical irrelenvance?

The type can also be declared explicitly. In this case, it's impossible to reassign a value of a different type. Adding `message = 73` to the following program would be a compiler error:

```{.crystal .crystal-play}
message : String = "Hello Penny!"

p! typeof(message)
```

Type declaration and value assignment can also be separated. But it's impossible to read from the variable before a value is assigned (this would result in a compiler error).

```{.crystal .crystal-play}
message : String

# Can't do `p! message` here before the assignment

message = "Hello Penny!"

p! typeof(message)
```

In practice it is rarely necessary or useful to declare the type of local variables.

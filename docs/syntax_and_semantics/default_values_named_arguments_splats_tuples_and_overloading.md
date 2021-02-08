# Method arguments

This is the formal specification of method parameters and call arguments.

## Components of a method definition

A method definition consists of:

* required and optional positional parameters
* an optional splat parameter, whose name can be empty
* required and optional named parameters
* an optional double splat parameter

For example:

```crystal
def foo(
  # These are positional parameters:
  x, y, z = 1,
  # This is the splat parameter:
  *args,
  # These are the named parameters:
  a, b, c = 2,
  # This is the double splat parameter:
  **options
)
end
```

Each one of them is optional, so a method can do without the double splat, without the splat, without named parameters and without positional parameters.

## Components of a method call

A method call also has some parts:

```crystal
foo(
  # These are positional arguments
  1, 2,
  # These are named arguments
  a: 1, b: 2
)
```

Additionally, a call argument can have a splat (`*`) or double splat (`**`). A splat expands a [Tuple](literals/tuple.md) into positional arguments, while a double splat expands a [NamedTuple](literals/named_tuple.md) into named arguments. Multiple argument splats and double splats are allowed.

## How call arguments are matched to method parameters

When invoking a method, the algorithm to match call arguments to method parameters is:

* First positional call arguments are matched with positional method parameters. The number of these must be at least the number of positional parameters without a default value. If there's a splat parameter with a name (the case without a name is explained below), more positional arguments are allowed and they are captured as a tuple. Positional arguments never match past the splat parameter.
* Then named arguments are matched, by name, with any parameter in the method (it can be before or after the splat parameter). If a parameter was already filled by a positional argument then it's an error.
* Extra named arguments are placed in the double splat method parameter, as a [NamedTuple](literals/named_tuple.md), if it exists, otherwise it's an error.

When a splat parameter has no name, it means no more positional arguments can be passed, and any following parameters must be passed as named arguments. For example:

```crystal
# Only one positional argument allowed, y must be passed as a named argument
def foo(x, *, y)
end

foo 1        # Error, missing argument: y
foo 1, 2     # Error: wrong number of arguments (given 2, expected 1)
foo 1, y: 10 # OK
```

But even if a splat parameter has a name, parameters that follow it must be passed as named arguments:

```crystal
# One or more positional argument allowed, y must be passed as a named argument
def foo(x, *args, y)
end

foo 1             # Error, missing argument: y
foo 1, 2          # Error: missing argument; y
foo 1, 2, 3       # Error: missing argument: y
foo 1, y: 10      # OK
foo 1, 2, 3, y: 4 # OK
```

There's also the possibility of making a method only receive named arguments (and list them), by placing the star at the beginning:

```crystal
# A method with two required named parameters: x and y
def foo(*, x, y)
end

foo            # Error: missing arguments: x, y
foo x: 1       # Error: missing argument: y
foo x: 1, y: 2 # OK
```

Parameters past the star can also have default values. It means: they must be passed as named arguments, but they aren't required (so: optional named parameters):

```crystal
# x is a required named parameter, y is an optional named parameter
def foo(*, x, y = 2)
end

foo            # Error: missing argument: x
foo x: 1       # OK, y is 2
foo x: 1, y: 3 # OK, y is 3
```

Because parameters (without a default value) after the splat parameter must be passed by name, two methods with different required named parameters overload:

```crystal
def foo(*, x)
  puts "Passed with x: #{x}"
end

def foo(*, y)
  puts "Passed with y: #{y}"
end

foo x: 1 # => Passed with x: 1
foo y: 2 # => Passed with y: 2
```

Positional parameters can always be matched by name:

```crystal
def foo(x, *, y)
end

foo 1, y: 2    # OK
foo y: 2, x: 3 # OK
```

## External names

An external name can be specified for a method parameter. The external name is the one used when passing an argument as a named argument, and the internal name is the one used to refer to the parameter inside the method definition:

```crystal
def foo(external_name internal_name)
  # here we use internal_name
end

foo external_name: 1
```

This covers two uses cases.

The first use case is using keywords as named parameters:

```crystal
def plan(begin begin_time, end end_time)
  puts "Planning between #{begin_time} and #{end_time}"
end

plan begin: Time.now, end: 2.days.from_now
```

The second use case is making a method parameter more readable inside a method body:

```crystal
def increment(value, by)
  # OK, but reads odd
  value + by
end

def increment(value, by amount)
  # Better
  value + amount
end
```

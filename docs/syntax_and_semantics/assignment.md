# Assignment

Assignment is done using the equals sign (`=`).

```crystal
# Assigns to a local variable
local = 1

# Assigns to an instance variable
@instance = 2

# Assigns to a class variable
@@class = 3
```

Each of the above kinds of variables will be explained later on.

Some syntax sugar that contains the `=` character is available:

```crystal
local += 1  # same as: local = local + 1

# The above is valid with these operators:
# +, -, *, /, %, |, &, ^, **, <<, >>

local ||= 1 # same as: local || (local = 1)
local &&= 1 # same as: local && (local = 1)
```

A method invocation that ends with `=` has syntax sugar:

```crystal
# A setter
person.name=("John")

# The above can be written as:
person.name = "John"

# An indexed assignment
objects.[]=(2, 3)

# The above can be written as:
objects[2] = 3

# Not assignment-related, but also syntax sugar:
objects.[](2, 3)

# The above can be written as:
objects[2, 3]
```

The `=` operator syntax sugar is also available to setters and indexers. Note that `||` and `&&` use the `[]?` method to check for key presence.

```crystal
person.age += 1 # same as: person.age = person.age + 1

person.name ||= "John" # same as: person.name || (person.name = "John")
person.name &&= "John" # same as: person.name && (person.name = "John")

objects[1] += 2 # same as: objects[1] = objects[1] + 2

objects[1] ||= 2 # same as: objects[1]? || (objects[1] = 2)
objects[1] &&= 2 # same as: objects[1]? && (objects[1] = 2)
```
# Local variables

Local variables start with lowercase letters. They are declared when you first assign them a value.

```crystal
name = "Crystal"
age = 1
```

Their type is inferred from their usage, not only from their initializer. In general, they are just value holders associated with the type that the programmer expects them to have according to their location and usage on the program.

For example, reassigning a variable with a different expression makes it have that expression’s type:

```crystal
flower = "Tulip"
# At this point 'flower' is a String

flower = 1
# At this point 'flower' is an Int32
```

Underscores are allowed at the beginning of a variable name, but these names are reserved for the compiler, so their use is not recommended (and it also makes the code uglier to read).

# Constants

Constants can be declared at the top level or inside other types. They must start with a capital letter:

```crystal
PI = 3.14

module Earth
  RADIUS = 6_371_000
end

PI            # => 3.14
Earth::RADIUS # => 6_371_000
```

Although not enforced by the compiler, constants are usually named with all capital letters and underscores to separate words.

A constant definition can invoke methods and have complex logic:

```crystal
TEN = begin
  a = 0
  while a < 10
    a += 1
  end
  a
end

TEN # => 10
```

## Pseudo Constants

Crystal provides a few pseudo-constants which provide reflective data about the source code being executed.

`__LINE__` is the current line number in the currently executing crystal file. When `__LINE__` is used as a default parameter value, it represents the line number at the location of the method call.

`__END_LINE__` is the line number of the `end` of the calling block. Can only be used as a default parameter value.

`__FILE__` references the full path to the currently executing crystal file.

`__DIR__` references the full path to the directory where the currently executing crystal file is located.

```crystal
# Assuming this example code is saved at: /crystal_code/pseudo_constants.cr
#
def pseudo_constants(caller_line = __LINE__, end_of_caller = __END_LINE__)
  puts "Called from line number: #{caller_line}"
  puts "Currently at line number: #{__LINE__}"
  puts "End of caller block is at: #{end_of_caller}"
  puts "File path is: #{__FILE__}"
  puts "Directory file is in: #{__DIR__}"
end

begin
  pseudo_constants
end

# Program prints:
# Called from line number: 13
# Currently at line number: 5
# End of caller block is at: 14
# File path is: /crystal_code/pseudo_constants.cr
# Directory file is in: /crystal_code
```

## Dynamic assignment

Dynamically assigning values to constants using the [chained assignment](assignment.md#chained-assignment) or the [multiple assignment](assignment.md#multiple-assignment) is not supported and results in a syntax error.

```crystal
ONE, TWO, THREE = 1, 2, 3 # Syntax error: Multiple assignment is not allowed for constants
```


## Chained assignment

You can assign the same value to multiple variables using chained assignment:

```crystal
a = b = c = 123

# Now a, b and c have the same value:
a # => 123
b # => 123
c # => 123
```

The chained assignment is not only available to [local variables](local_variables.md) but also to [instance variables](methods_and_instance_variables.md), [class variables](class_variables.md) and setter methods (methods that end with `=`).

## Multiple assignment

You can declare/assign multiple variables at the same time by separating expressions with a comma (`,`):

```crystal
name, age = "Crystal", 1

# The above is the same as this:
temp1 = "Crystal"
temp2 = 1
name = temp1
age = temp2
```

Note that because expressions are assigned to temporary variables it is possible to exchange variables’ contents in a single line:

```crystal
a = 1
b = 2
a, b = b, a
a # => 2
b # => 1
```

If the right-hand side contains just one expression, the type is indexed for each variable on the left-hand side like so:

```crystal
name, age, source = "Crystal, 123, GitHub".split(", ")

# The above is the same as this:
temp = "Crystal, 123, GitHub".split(", ")
name = temp[0]
age = temp[1]
source = temp[2]
```

Multiple assignment is also available to methods that end with `=`:

```crystal
person.name, person.age = "John", 32

# Same as:
temp1 = "John"
temp2 = 32
person.name = temp1
person.age = temp2
```

And it is also available to [index assignments](operators.md#assignments) (`[]=`):

```crystal
objects[1], objects[2] = 3, 4

# Same as:
temp1 = 3
temp2 = 4
objects[1] = temp1
objects[2] = temp2
```

## Underscore

The underscore can appear on the left-hand side of any assignment. Assigning a value to it has no effect and the underscore cannot be read from:

```crystal
_ = 1     # no effect
_ = "123" # no effect
puts _    # Error: can't read from _
```

It is useful in multiple assignment when some of the values returned by the right-hand side are unimportant:

```crystal
before, _, after = "main.cr".partition(".")

# The above is the same as this:
temp = "main.cr".partition(".")
before = temp[0]
_ = temp[1] # this line has no effect
after = temp[2]
```

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
person.age += 1        # same as: person.age = person.age + 1

person.name ||= "John" # same as: person.name || (person.name = "John")
person.name &&= "John" # same as: person.name && (person.name = "John")

objects[1] += 2        # same as: objects[1] = objects[1] + 2

objects[1] ||= 2       # same as: objects[1]? || (objects[1] = 2)
objects[1] &&= 2       # same as: objects[1]? && (objects[1] = 2)
```

# Chained assignment

You can assign the same value to multiple variables using chained assignment:

```crystal
a = b = c = 123

# Now a, b and c have the same value:
a # => 123
b # => 123
c # => 123
```

The chained assignment is not only available to [local variables](local_variables.md) but also to [instance variables](methods_and_instance_variables.md), [class variables](class_variables.md) and setter methods (methods that end with `=`).

# Multiple assignment

You can declare/assign multiple variables at the same time by separating expressions with a comma (`,`):

```crystal
name, age = "Crystal", 1

# The above is the same as this:
temp1 = "Crystal"
temp2 = 1
name  = temp1
age   = temp2
```

Note that because expressions are assigned to temporary variables it is possible to exchange variables’ contents in a single line:

```crystal
a = 1
b = 2
a, b = b, a
a #=> 2
b #=> 1
```

If the right-hand side contains just one expression, the type is indexed for each variable on the left-hand side like so:

```crystal
name, age, source = "Crystal, 123, GitHub".split(", ")

# The above is the same as this:
temp = "Crystal, 123, GitHub".split(", ")
name   = temp[0]
age    = temp[1]
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

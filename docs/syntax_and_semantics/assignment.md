# Assignment

An assignment expression assigns a value to a named identifier (usually a variable).
The [assignment operator](operators.md#assignments) is the equals sign (`=`).

The target of an assignment can be:

* a [local variable](local_variable.md)
* an [instance variable](methods_and_instance_variables.md)
* a [class variable](class_variables.md)
* a [constant](constants.md)
* an assignment method

```crystal
# Assigns to a local variable
local = 1

# Assigns to an instance variable
@instance = 2

# Assigns to a class variable
@@class = 3

# Assigns to a constant
CONST = 4

# Assigns to a setter method
foo.method = 5
foo[0] = 6
```

### Method as assignment target

A method ending with an equals sign (`=`) is called a setter method. It can be used
as the target of an assignment. The semantics of the assignment operator apply as
a form of syntax sugar to the method call.

This is an example of a call to a setter method in typical method notation and with assignment operator.
Both expressions are equivalent.

```crystal
def name=(value);end

name=("John")
name = "John"
```

This is an example of a call to an indexed assignment method in typical method notation and with index assignment operator.
Both expressions are equivalent.

```crystal
class List
  def []=(key, value); end
end
list = List.new

list.[]=(2, 3)
list[2] = 3
```

### Combined assignments

[Combined assignments](operators.md#combined-assignments) are a combination of an
assignment operator and another operator.
This works with any target type except constants.

Some syntax sugar that contains the `=` character is available:

```crystal
local += 1  # same as: local = local + 1
```

The `=` operator syntax sugar is also available to setter and index assignment methods.
Note that `||` and `&&` use the `[]?` method to check for key presence.

```crystal
person.age += 1 # same as: person.age = person.age + 1

person.name ||= "John" # same as: person.name || (person.name = "John")
person.name &&= "John" # same as: person.name && (person.name = "John")

objects[1] += 2 # same as: objects[1] = objects[1] + 2

objects[1] ||= 2 # same as: objects[1]? || (objects[1] = 2)
objects[1] &&= 2 # same as: objects[1]? && (objects[1] = 2)
```

## Chained assignment

The same value can be assigned to multiple targets using chained assignment.
This works with any target type except constants.

```crystal
a = b = c = 123

# Now a, b and c have the same value:
a # => 123
b # => 123
c # => 123
```

## Multiple assignment

You can declare/assign multiple variables at the same time by separating expressions with a comma (`,`).
This works with any target type except constants.

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

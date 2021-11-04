# Assignment

An assignment expression assigns a value to a named identifier (usually a variable).
The [assignment operator](operators.md#assignments) is the equals sign (`=`).

The target of an assignment can be:

* a [local variable](local_variables.md)
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

Calling setter methods requires an explicit receiver. The receiver-less syntax `x = y`
is always parsed as an assignment to a local variable, never a call to a method `x=`.
Even adding parentheses does not force a method call, as it would when reading from a local variable.

The following example shows two calls to a setter method in typical method notation and with assignment operator.
Both assignment expressions are equivalent.

```crystal
class Thing
  def name=(value); end
end

thing = Thing.new

thing.name=("John")
thing.name = "John"
```

The following example shows two calls to an indexed assignment method in typical method notation and with index assignment operator.
Both assignment expressions are equivalent.

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

```{.crystal nocheck}
local += 1  # same as: local = local + 1
```

This assumes that the corresponding target `local` is assignable, either as a variable or via the respective getter and setter methods.

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

## Splat assignment

The left-hand side of an assignment may contain one splat, which collects any values not assigned to the other targets. A [range](literals/range.md) index is used if the right-hand side has one expression:

```crystal
head, *rest = [1, 2, 3, 4, 5]

# Same as:
temp = [1, 2, 3, 4, 5]
head = temp[0]
rest = temp[1..]
```

Negative indices are used for targets after the splat. [`Indexable`](https://crystal-lang.org/api/latest/Indexable.html) types support negative indices out of the box:

```crystal
*rest, tail1, tail2 = [1, 2, 3, 4, 5]

# Same as:
temp = [1, 2, 3, 4, 5]
rest = temp[..-3]
tail1 = temp[-2]
tail2 = temp[-1]
```

If the expression does not have enough elements and the splat appears in the middle of the targets, [`IndexError`](https://crystal-lang.org/api/latest/IndexError.html) is raised:

```crystal
a, b, *c, d, e, f = [1, 2, 3, 4]

# Same as:
temp = [1, 2, 3, 4]
if temp.size < 5 # number of non-splat assignment targets
  raise IndexError.new("Multiple assignment count mismatch")
end
# note that the following assignments would incorrectly not raise if the above check is absent
a = temp[0]
b = temp[1]
c = temp[2..-4]
d = temp[-3]
e = temp[-2]
f = temp[-1]
```

A [`Tuple`](https://crystal-lang.org/api/latest/Tuple.html) is formed if there are multiple values:

```crystal
*a, b, c = 3, 4, 5, 6, 7

# Same as:
temp1 = {3, 4, 5}
temp2 = 6
temp3 = 7
a = temp1
b = temp2
c = temp3
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

Assignments to `*_` are dropped altogether, so multiple assignments can be used to extract the first and last elements in a value efficiently, without creating an intermediate object for the elements in the middle:

```crystal
first, *_, last = "127.0.0.1".split(".")

# Same as:
temp = "127.0.0.1".split(".")
if temp.size < 2
  raise IndexError.new("Multiple assignment count mismatch")
end
first = temp[0]
last = temp[-1]
```

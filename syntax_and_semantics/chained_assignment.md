# Chained assignment

You can assign multiple variables to one value at the same time using the chained assignment:

```crystal
var1 = var2 = var3 = 123

# The above is the same as this:
var1 = 123
var2 = 123
var3 = 123
```

The chained assignment is not only available to [local variables](local_variables.md) but also to [instance variables](methods_and_instance_variables.md) and [class variables](class_variables.md).

Chained assignment is also available to methods that end with `=`:

```crystal
person1.name = person2.name = "John"

# The above is the same as:
person1.name = "John"
person2.name = "John"
```

And it is also available to [indexers](operators.md#indexing) (`[]=`):

```crystal
object1[0] = object2[0] = 5

# The above is the same as:
object1[0] = 5
object2[0] = 5
```

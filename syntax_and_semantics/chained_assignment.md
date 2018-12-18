# Chained assignment

You can assign multiple variables to one value at the same time using the chained assignment:

```crystal
var1 = var2 = var3 = 123

# The above is the same as this:
var1 = 123
var2 = 123
var3 = 123
```

Chained assignment is available to [instance variables](methods_and_instance_variables.md) and [class variables](class_variables.md) as well.

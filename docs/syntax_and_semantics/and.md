# && - Logical AND Operator

An `&&` (and) evaluates its left hand side. If it's *truthy*, it evaluates its right hand side and has that value. Otherwise it has the value of the left hand side. Its type is the union of the types of both sides.

You can think an `&&` as syntax sugar of an `if`:

```crystal
result = some_exp1 && some_exp2

# The above is the same as:
result = if some_exp1
  some_exp2
else
  some_exp1
end
```

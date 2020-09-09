# unless

An `unless` evaluates the then branch if its condition is *falsey*, and evaluates the `else branch`, if there’s any, otherwise. That is, it behaves in the opposite way of an `if`:

```crystal
unless some_condition
  expression_when_falsey
else
  expression_when_truthy
end

# The above is the same as:
if some_condition
  expression_when_truthy
else
  expression_when_falsey
end

# Can also be written as a suffix
close_door unless door_closed?
```

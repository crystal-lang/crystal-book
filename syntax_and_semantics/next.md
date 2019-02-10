# next

You can use `next` to try to execute the next iteration of a `while` loop. After executing `next`, the `while`'s condition is checked and, if *truthy*, the body will be executed.

```crystal
a = 1
while a < 5
  a += 1
  if a == 3
    next
  end
  puts a
end

# The above prints the numbers 2, 4 and 5
```

But `next` can also be used to exit from blocks, for example:

```crystal
def block
  yield
end

block do
  puts 1, 2
  next
  puts 3
end

# The above prints the numbers 1 and 2
```

Similar to [`break`](break.md), `next` can also take a parameter which will then be the value that gets returned:

```crystal
def block
  yield
end

three = block do
  puts 1, 2
  next 3
end

puts three

# The above prints the numbers 1, 2 and 3
```

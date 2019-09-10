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

`next` can also be used to exit from a block, for example:

```crystal
def block
  yield
end

block do
  puts "hello"
  next
  puts "world"
end

# The above prints "hello"
```

Similar to [`break`](break.md), `next` can also take a parameter which will then be returned by `yield`.

```crystal
def block
  puts yield
end

block do
  next "hello"
end

# The above prints "hello"
```

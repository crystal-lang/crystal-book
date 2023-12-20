# break

You can use `break` to break out of a `while` loop:

```crystal
a = 2
while (a += 1) < 20
  if a == 10
    break # goes to 'puts a'
  end
end
puts a # => 10
```

`break` can also take an argument which will then be the value that gets returned:

```crystal
def foo
  loop do
    break "bar"
  end
end

puts foo # => "bar"
```

If a `break` is used within more than one nested `while` loop, only the immediate enclosing loop is broken out of:

```crystal
while true
  pp "start1"
  while true
    pp "start2"
    break
    pp "end2"
  end
  pp "end1"
  break
end

# Output:
"start1"
"start2"
"end1"
```

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

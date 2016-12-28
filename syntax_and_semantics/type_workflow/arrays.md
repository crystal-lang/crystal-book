# Working with Arrays

```crystal
# Various ways to create an array
my_array = [] of Char # => [] : Array(Char)
my_array = Array(Char).new # => [] : Array(Char)
my_array = Array(typeof('a', 'b', 'c')).new # => [] : Array(Char)
my_array = ['a', 'b', 'c'] # => ['a', 'b', 'c'] : Array(Char)

# Add an element to an array
my_array.push('d')
# or
# my_array = my_array + ['d']

my_array # => ['a', 'b', 'c', 'd'] : Array(Char)

# Access a single element
my_array[0] # => 'a' : Char

# Access from the end of an array
my_array[-2] # => 'c' : Char

# Access a range of an array
my_array[1..3] # => ['b', 'c', 'd'] : Array(Char)

# Start at an element in the array and continue for X elements
my_array[2, 2] # => ['c', 'd']
```

<!-- TODO: show examples of replacing a range of elements with a new value -->

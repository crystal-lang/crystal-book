# Enumerable

The `Enumerable` module provides an API to deal with collections.

## Enumerable#map

For example, given a array of `Int32` we may apply a method that sums 1 to every element. Another example, we want to multiply every element by 2.

Let's write the two examples:

**+1 example**
```{.crystal .crystal-play}
arr = [1, 2, 3]
plus1 = [] of Int32

arr.each { |elem|
  plus1 << elem + 1
}

puts plus1 # => [2, 3, 4]
```

***2 example**
```{.crystal .crystal-play}
arr = [1, 2, 3]
times2 = [] of Int32

arr.each { |elem|
  times2 << elem * 2
}

puts times2 # => [2, 4, 6]
```

Done!

Although now it's easy to see that both implementations have the same structure, we are repeating the same logic!

It would be great to have a method to go through each element an apply a method to said element.

Well, we are in luck, because [Enumerable#map](https://crystal-lang.org/api/latest/Enumerable.html#map%28%26%3AT-%3EU%29%3AArray%28U%29forallU-instance-method) does exactly that.

Let's re-write the examples:

**+1 example using Enumerable#map**
```{.crystal .crystal-play}
arr = [1, 2, 3]
plus1 = arr.map { |elem| elem + 1}

puts plus1 # => [2, 3, 4]
```

***2 example using Enumerable#map**
```{.crystal .crystal-play}
arr = [1, 2, 3]
times2 = arr.map { |elem| elem * 2}

puts times2 # => [2, 4, 6]
```

Great!

We wrote the examples using `each`, we detect the pattern used and we learned about `Enumerable#map`. Now let's see [Enumerable#map implementation](https://github.com/crystal-lang/crystal/blob/932f193ae/src/enumerable.cr#L905):

```crystal
  def map(& : T -> U) : Array(U) forall U
    ary = [] of U
    each { |e| ary << yield e }
    ary
  end
```

No magic here, right? :) Just the structure extracted to a method called `map`.

A related method to know: [`map_with_index`](https://crystal-lang.org/api/latest/Enumerable.html#map%28%26%3AT-%3EU%29%3AArray%28U%29forallU-instance-method)

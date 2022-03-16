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

## Enumerable#select

Let's move on to another two examples:

**Even example**

In this example we keep only even numbers

```{.crystal .crystal-play}
arr = [1, 2, 3, 4, 5]
even = [] of Int32

arr.each { |elem|
  even << elem if elem.even?
}

puts even # => [2, 4]
```

**String-length example**

And in this example we keep `strings` which length is more than 3.

```{.crystal .crystal-play}
arr = ["Hello", "Crystal!", "ABC", "Foo"]
str3 = [] of String

arr.each { |elem|
  str3 << elem if elem.size > 3
}

puts str3 # => ["Hello", "Crystal!"]
```

And so the pattern appears. Again, we are repeating the same logic!

It would be great to have a method to go through each element an selects the elements the comply to a given condition.

As we can imagen, there is such method and is called [Enumerable#select](https://crystal-lang.org/api/latest/Enumerable.html#select%28%26%3AT-%3E%29-instance-method).

Let's re-write the examples:

**Even example using Enumerable#select**

```{.crystal .crystal-play}
arr = [1, 2, 3, 4, 5]
even = arr.select { |elem| elem.even? }

puts even # => [2, 4]
```

**String-length example using Enumerable#select**

```{.crystal .crystal-play}
arr = ["Hello", "Crystal!", "ABC", "Foo"]
str3 = arr.select { |elem| elem.size > 3 }

puts str3 # => ["Hello", "Crystal!"]
```

So, we wrote the examples using `each`, we detect the pattern used and we learned about `Enumerable#select`. Let's see [Enumerable#select implementation](https://github.com/crystal-lang/crystal/blob/932f193ae/src/enumerable.cr#L1408):

```crystal
  def select(& : T ->)
    ary = [] of T
    each { |e| ary << e if yield e }
    ary
  end
```

There we have the structure!

Related method: [Enumerable#reject](https://crystal-lang.org/api/latest/Enumerable.html#reject%28%26%3AT-%3E%29-instance-method)

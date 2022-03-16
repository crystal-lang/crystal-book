# Enumerable

The `Enumerable` module provides methods that implement common solutions over collections.

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

## Enumerable#reduce

This next one method is not as easy as the previous ones. But, as we did before, let's start with 2 examples, then we will try to identify an structure and hopefully we will find a method already implementing what we need.

**Add all the things!**

In the first example we will add all the numbers.

```{.crystal .crystal-play}
arr = [1, 2, 3]
sum = 0

arr.each { |elem|
  sum = sum + elem
}

puts sum # => 6
```

**Any empty?**

And in the second example we return if there is an empty string in the array.

```{.crystal .crystal-play}
arr = ["Crystal", "A", "language", "for", "humans", "and", "computers"]
empty_str = false

arr.each { |elem|
  empty_str = empty_str || elem.empty?
}

puts empty_str # => false
```

This time the pattern is a little more difficult to see but it's there!
We can break the example as follows: First we declare a variable (let's call it "accumulator") with an initial value. Then as we go through the elements in the array, we "accumulate" the result of applying a method to the "accumulator" and the current element (in the first example the method was `+`, in the second was `||`)

So, what we need is a method which can go through each element, starting with an `initial value` an applying a method to the `accumulated value` and said element.

Drumroll please ... the method is called [Enumerable#reduce](https://crystal-lang.org/api/latest/Enumerable.html#reduce%28%26%29-instance-method).

Let's re-write the examples:

**Add all the things! using Enumerable#reduce**

```{.crystal .crystal-play}
arr = [1, 2, 3]
sum = arr.reduce(0) { |accum, elem| accum + elem }

puts sum # => 6
```

**Any empty? using Enumerable#reduce**

```{.crystal .crystal-play}
arr = ["Crystal", "A", "language", "for", "humans", "and", "computers"]
empty_str = arr.reduce(false) { |accum, elem| accum || elem.empty?}

puts empty_str # => false
```

So, we wrote the examples using `each`, we detect the pattern used and we learned about `Enumerable#reduce`. Let's see [Enumerable#reduce implementation](https://github.com/crystal-lang/crystal/blob/932f193ae/src/enumerable.cr#L709) using an initial value:

```crystal
  def reduce(memo)
    each do |elem|
      memo = yield memo, elem
    end
    memo
  end
```

It's worth mention that `reduce` is the base for other methods. Let's see one of them related to the first example:

### Enumerable###sum
We can write our first example with [Enumerable#sum](https://crystal-lang.org/api/1.3.2/Enumerable.html#sum%28initial%29-instance-method) like this:

```{.crystal .crystal-play}
arr = [1, 2, 3]
sum = arr.sum(0)

puts sum # => 6
```

We can also use it without an initial value in which case the first element would be the initial value. Is the same behaviour as in `Enumerable#reduce`.

```{.crystal .crystal-play}
arr = [1, 2, 3]
puts arr.sum # => 6
```

[Here](https://github.com/crystal-lang/crystal/blob/932f193ae/src/enumerable.cr#L1586
) is the implementation:

```crystal
  def sum(initial, & : T ->)
    reduce(initial) { |memo, e| memo + (yield e) }
  end
```

### Enumerable###any?

In case you are wondering if there is an `any?` method we can re-write the `Any empty? example` ...

**the short answer is: Yes!**

It's called [Enumerable#any?](https://crystal-lang.org/api/1.3.2/Enumerable.html#any%3F%28%26%3AT-%3E%29%3ABool-instance-method) and so we can write the example like this:

```{.crystal .crystal-play}
arr = ["Crystal", "A", "language", "for", "humans", "and", "computers"]
puts arr.any? { |str| str.empty? } # => false
```

Even more, we have a more concise way of writing it:

```{.crystal .crystal-play}
arr = ["Crystal", "A", "language", "for", "humans", "and", "computers"]
puts arr.any? &.empty? # => false
```

`&` refers to the value passed to the block. You can read more about this [here](https://crystal-lang.org/reference/1.3/syntax_and_semantics/blocks_and_procs.html#short-one-parameter-syntax).

**the long answer is: Yes! But ...**
the method [Enumerable#any?](https://github.com/crystal-lang/crystal/blob/932f193ae/src/enumerable.cr#L81) is not implemented using `Enumerable#reduce` but with `each` so to "break the loop" once we find an element that satisfies the condition.

As you can imagine there are a lot more methods in `Enumerable` and it's a good practice to read [its documentation](https://crystal-lang.org/api/latest/Enumerable.html) at least once so we have an idea of what we can do with enumerable collections.

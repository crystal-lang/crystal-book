# Blocks

As we already mentioned in the [methods](./60_methods.md#blocks) section, *blocks* is an interesting and important topic. So let's start defining them:

A *block of code* or *block* for short, is a way to abstract a sequence of interactions between objects. They are commonly used as a method parameter, as a way to parameterize (forgive the redundancy) part of its behavior.

## Blocks and Methods

Methods may receive a *block* as an argument. And using the keyword `yield` indicates the place in the method's body where we want to "place" said `block`:

```crystal-play
def with_42
  yield
end

with_42 do
  puts 42
end
```

We can also use `yield` in more than one place:

```crystal-play
def three_times
  yield
  yield
  yield
end

three_times do
  puts 42
end
```

Let's see another examples with a common use scenario for *blocks*: collections.

Here are two examples:

```crystal-play
# Example 1
arr = [1, 2, 3]
index = 0

while index < arr.size
  elem = arr[index]

  puts elem + 42

  index = index + 1
end
```

```crystal-play
# Example 2
arr = ["John", "Paul", "George", "Ringo"]
index = 0

while index < arr.size
  elem = arr[index]

  puts "Hello #{elem}"

  index = index + 1
end
```

As we can see in the above examples, the structures are the same: we want to traverse the array and do *something* with the current element at each step. And here is where *blocks* come handy: we can parameterize that *something* we want to execute.

Now, let's rewrite the examples. We are going to declare a new method that will abstract the structure duplicated in both examples: It will receive the array and what we want to do at each step using a *block*:

```crystal-play
def with_array(arr)
  index = 0

  while index < arr.size
    elem = arr[index]

    yield elem # yes! we can pass an argument to a block.

    index = index + 1
  end
end

# Example 1
with_array [1, 2, 3] do |elem|
  puts elem + 42
end

# Example 2
with_array ["John", "Paul", "George", "Ringo"] do |elem|
  puts "Hello #{elem}"
end
```

The abstracted structure declared in the `with_array` method is very common and that's why it's already implemented in [Indexable#each](https://crystal-lang.org/api/Indexable.html#each%28%26%3AT-%3E%29-instance-method).

NOTE:
Both blocks declare a parameter (the current element while traversing the array) which we will see next.

## Blocks with parameters

Like methods, *blocks* may receive parameters declared like this: `| param1, param2, ... |`.

Let's see an example:

```crystal-play
def other_method
  yield 42, "Hello", [1, "Crystal", 3]
end

other_method do |n, s, arr| # here the block declare 3 parameters
  puts "#{s} #{arr[1]}"
  puts n
end
```

### Underscore

What happens if the *block* we are providing does not use all the passed arguments? In that case we can use an underscore just to indicate that an expected parameter it's not used by the block (so no name needed):

```crystal-play
def other_method
  yield 42, "Hello", [1, "Crystal", 3]
end

other_method do |_, _, arr|
  puts arr[1]
end
```

### Unpacking parameters

Now let's suppose we have an array of arrays. And we want to print each  array in the following way: *the first element followed by a hyphen, followed by the second element*.

One way to implement this would be:

```crystal-play
arr = [["one", 42], ["two", 24]]
arr.each do |arg|
  puts "#{arg[0]} - #{arg[1]}"
end
```

This works, but there is a more readable way of writing the same but using parameter unpacking::

```crystal-play
arr = [["one", 42], ["two", 24]]
arr.each do |(word, number)|
  puts "#{word} - #{number}"
end
```

NOTE:
We use parentheses to unpack the argument into the different block parameters.

Unpacking arguments into parameters works only if the argument's type responds to `[i]` (with `i` an `integer`). In our example `Array` inherits [Indexable#[ ]](https://crystal-lang.org/api/Indexable.html#%5B%5D%28index%3AInt%29-instance-method)

### Splats

When the *block* parameter is a [Tuple](../../syntax_and_semantics/literals/tuple.md) we can use auto-splatting (see [Splats](../../syntax_and_semantics/operators.md#splats)) as a way of destructuring the `tuple` in block parameters (and without the need of parentheses).

```crystal-play
arr = [{"one", 42}, {"two", 24}]
arr.each do |word, number|
  puts "#{word} - #{number}"
end
```

NOTE:
`Tuples` also implements [Tuple#[ ]](https://crystal-lang.org/api/Tuple.html#%5B%5D%28index%3AInt%29-instance-method) meaning that we can also use *unpacking*.

## Blocks' returned value

A *block*, by default, returns the value of the last expression (the same as a method).

```crystal-play
def with_number(n : Int32)
  block_result = yield n
  puts block_result
end

with_number(41) do |number|
  number + 1
end
```

### Returning keywords

We can use the `return` keyword ... but, let's see the following example:

```crystal-play
def with_number(n : Int32)
  block_result = yield n
  puts block_result
end

def test_number(n)
  with_number(n) do |number|
    return number if number.negative?
    number + 1
  end

  puts "Inside `#test_number` method after `#with_number`"
end

test_number(42)
```

Outputs:

```console

43
Inside `#test_number` method after `#with_number`
```

And if we want to `test_number(-1)` we would expect:

```console

-1
Inside `#test_number` method after `#with_number`
```

Let's see ...

```crystal-play
def with_number(n : Int32)
  block_result = yield n
  puts block_result
end

def test_number(n)
  with_number(n) do |number|
    return number if number.negative?
    number + 1
  end

  puts "Inside `#test_number` method after `#with_number`"
end

test_number(-1)
```

The output is empty! This is because Crystal implements *full closures*, meaning that using `return` inside the block will return, not only from the *block* itself but, from the method where the *block* is defined (i.e. `#test_number` in the above example).

If we want to return only from the *block* then we need to use the keyword `next`:

```crystal-play
def with_number(n : Int32)
  block_result = yield n
  puts block_result
end

def test_number(n)
  with_number(n) do |number|
    next number if number.negative?
    number + 1
  end

  puts "Inside `#test_number` method after `#with_number`"
end

test_number(-1)
```

The last keyword for returning from a *block* is `break`. Let's see how it behaves:

```crystal-play
def with_number(n : Int32)
  block_result = yield n
  puts block_result
end

def test_number(n)
  with_number(n) do |number|
    break number if number.negative?
    number + 1
  end

  puts "Inside `#test_number` method after `#with_number`"
end

test_number(-1)
```

The output is

```console

Inside `#test_number` method after `#with_number`
```

As we can see the behaviour is something between using `return` and `next`. With `break` we return from the *block* and from the method yielding the *block* (`#with_number` in this example) but not from the method where the `block` is defined.

## Type restrictions

Until now we have been using *blocks* without any kind of type restrictions, moreover, we did not declare the block as a method parameter (it was implied by the use of `yield`).

So first, we will declare a *block* as a method parameter: it should be placed last and the parameter's name should be prefixed by `&`. Then we can use `yield` as before.

```crystal-play
def transform_string(word, &block)
  block_result = yield word
  puts block_result
end

transform_string "crystal" do |word|
  word.capitalize
end
```

Now, we can add type restrictions to our method's parameters:

```crystal-play
def transform_string(word : String, &block : String -> String)
  block_result = yield word
  puts block_result
end

transform_string "crystal" do |word|
  word.capitalize
end
```

Let's focus on the block's type `&block : String -> String`. What we are saying is that the block will receive a `String` and return a `String`.

So, if the block tries to return an `Int` the compiler will say:

```crystal
def transform_string(word : String, &block : String -> String)
  block_result = yield word
  puts block_result
end

transform_string "crystal" do |word|
  42 # Error: expected block to return String, not Int32
end
```

Or if we try to give an `Array(String)` as an input to the block, the compiler will say:

```crystal
def transform_string(word : String, &block : String -> String)
  block_result = yield [word] # Error: argument #1 of yield expected to be String, not Array(String)
  puts block_result
end

transform_string "crystal" do |word|
  word.capitalize
end
```

## Alternative syntaxes

We almost at the end of this section. Let's see some other interesting ways of writing *blocks*.

### Curly braces

Another way of defining a *block* is using `{...}` instead of `do ... end`. Here is one of the examples we have already seen but written with *curly braces syntax*:

```crystal-play
def other_method
  yield 42, "Hello", [1, "Crystal", 3]
end

other_method { |n, s, arr|
  puts "#{s} #{arr[1]}"
  puts n
}
```

Here is the  `_` example written with *curly braces syntax* and in one line:

```crystal-play
def other_method
  yield 42, "Hello", [1, "Crystal", 3]
end

other_method { |_, _, arr| puts arr[1] }
```

The main difference between using `do ... end` and `{ ... }` is how they bind the call:

- `do ... end` binds to left-most call
- `{ ... }` binds to the right-most call

```crystal-play
def generate_number
  42
end

def with_double(n : Int32)
  yield n * 2
end

with_double generate_number do |n|
  puts n
end

# Same as:
with_double(generate_number) do |n|
  puts n
end
```

But with `curly braces syntax`:

```crystal
def generate_number
  42
end

def with_double(n : Int32)
  yield n * 2
end

with_double generate_number { |n| puts n } # Error: 'generate_number' is not expected to be invoked with a block, but a block was given
```

The error is because with *curly braces* we are writing: `with_double(generate_number { |n| puts n })` instead of `with_double(generate_number) { |n| puts n }`

### Short one-parameter syntax

We can use a short syntax with the block parameter if:

- It is a single block parameter.
- One method is invoked on the block parameter.

For example

```crystal-play
def transform_hello_crystal
  puts yield "hello crystal"
end

transform_hello_crystal { |param| param.capitalize }

# and here is using short one-parameter syntax:
transform_hello_crystal(&.capitalize)

# and we can omit parentheses:
transform_hello_crystal &.capitalize
```

The output should be "Hello crystal". What if we want to capitalize every word.

```crystal-play
def transform_hello_crystal
  puts yield "hello crystal"
end

transform_hello_crystal &.split.map(&.capitalize).join(' ')
```

Great! Let's explain it step by step:

First we split the block parameter using the *short one-parameter syntax* `&.split`. Then, we chained the result applying `map` and using again the *short one-parameter syntax* `.map(&.capitalize)`. And finally we join the `array` of `strings` using `join(' ')`.

Now, what if we want to parameterize the string we transform. Can we still use the *short one-parameter syntax*? The answer is yes! Let's see:

```crystal-play
def transform_string(word : String)
  puts yield word
end

transform_string("hello crystal", &.split.map(&.capitalize).join(' '))
```

## Under the hood

Before finishing this section of the tutorial, it would be a good idea to see how *blocks* work under the hood.

First, it's important to note that in this section we have only seen *blocks* that we use with the keyword `yield`. There is [another kind of block](../../syntax_and_semantics/capturing_blocks.md), but we will leave it for later in the tutorial.

In a method that receives a *block*, when we write `yield`, the compiler will inline the *block of code*, which means that this:

```crystal-play
def with_number(n : Int32)
  block_result = yield n
  puts block_result
end

with_number 41 do |number|
  number + 1
end
```

will be rewrite as:

```crystal-play
def with_number(n : Int32)
  number = n
  block_result = number + 1
  puts block_result
end

with_number 41
```

Let's see one last example using collections:

```crystal-lang
[1, 2, 3].each do |n|
  puts n
end
```

The implementation of [Indexable#each](https://crystal-lang.org/api/Indexable.html#each%28%26%3AT-%3E%29-instance-method) is the following:

```crystal
def each(& : T ->)
  each_index do |i|
    yield unsafe_fetch(i)
  end
end
```

So the rewrite will be:

```crystal
def each(& : T ->)
  each_index do |i|
    n = unsafe_fetch(i)
    puts n
  end
end
```

Finally, `each_index` is defined as:

```crystal
def each_index(& : Int32 ->) : Nil
  i = 0
  while i < size
    yield i
    i += 1
  end
end
```

And so, `each_index` will be rewriten as:

```crystal
def each_index(& : Int32 ->) : Nil
  i = 0
  while i < size
    j = i # j is block's parameter
    n = unsafe_fetch(j)
    puts n
    i += 1
  end
end
```

Here we can test the resulting method:

```crystal-play
def puts_each_index(arr)
  i = 0
  while i < arr.size
    j = i
    n = arr.unsafe_fetch(j)
    puts n
    i += 1
  end
end

puts_each_index [1, 2, 3]
```

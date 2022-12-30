# Blocks

As we already mentioned in the [methods](./60_methods.html#blocks) section, _blocks_ is an interesting and important topic. So let's start defining them:

A _block of code_ or _block_ for short, is a way to abstract a sequence of interactions between objects. They are commonly used as a method parameter, as a way to parameterize (forgive the redundancy) part of its behavior.


# Blocks and Methods

Methods may receive a _block_ as an argument. And using the keyword `yield` indicates the place in the method's body where we want to "place" said `block`:

```crystal-play
def with_42
  yield
end

with_42 do
  puts 42
end
```

Or the **places** where we want to execute the _block_:

```crystal-play
def three_times
  yield
  yield
  yield
end

three_times do
  puts 42
end

Let's see another example with a common use scenario for _blocks_: collections.

Here are two examples:

```crystal-play
# Example 1
arr = [1, 2, 3]
index = 0

while index < arr.size
  elem =  arr[index]

  puts elem + 42

  index = index + 1
end
```

```crystal-play
# Example 2
arr = ["John", "Paul", "George","Ringo"]
index = 0

while index < arr.size
  elem = arr[index]

  puts "Hello #{elem}"

  index = index + 1
end
```

As we can see in the above examples, the structures are the same: we want to traverse the array and do _something_ with the current element at each step. And here is where _blocks_ come handy: we can parameterize that _something_ we want to execute.

So let's rewrite the examples. We are going to declare a new method that will abstract the structure duplicated in both examples: It will receive the array and what we want to do at each step using a _block_:

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
with_array [1, 2, 3] do |current_elem|
  puts elem + 42
end

# Example 2
with_array ["John", "Paul", "George","Ringo"] do |current_elem|
  puts "Hello #{current_elem}"
end
```

The abstracted structure declared in the `with_array` method is very common and that's why it's already implemented in [Indexable#each](https://crystal-lang.org/api/latest/Indexable.html#each%28%26%3AT-%3E%29-instance-method).

**Note:** both blocks declare a parameter (the current element while traversing the array) which we will see next.

## Blocks with parameters

Like methods, _blocks_ may receive parameters declared like this: `| param1, param2, ... |`.

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

What happens if the _block_ we are providing does not use all the passed arguments? In that case we can use an underscore just to indicate that an expected parameter it's not used by the block (so no name needed):

```crystal-play
def other_method
  yield 42, "Hello", [1, "Crystal", 3]
end

other_method do |_, _, arr|
  puts arr[1]
end
```

### Unpacking parameters

Now let's suppose we have an array of arrays. And we want to print each  array in the following way: _the first element followed by a hyphen, followed by the second element_.

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

**Note:** we use parentheses to unpack the argument into the different block parameters.

Unpacking arguments into parameters works only if the argument's type responds to `[i]` (with `i` an `integer`). In our example `Array` inherits [Indexable#[ ]](https://crystal-lang.org/api/latest/Indexable.html#%5B%5D%28index%3AInt%29-instance-method)

### Splats

When the _block_ parameter is a [Tuple](../syntax_and_semantics/literals/tuple.html) we can use auto-splatting (see [Splats](../syntax_and_semantics/operators.html#splats)) as a way of destructuring the `tuple` in block parameters (and without the need of parentheses).


```crystal-play
arr = [{"one", 42}, {"two", 24}]
arr.each do |word, number|
  puts "#{word} - #{number}"
end
```

**Note:** `Tuples` also implements [Tuple#[ ]](https://crystal-lang.org/api/latest/Tuple.html#%5B%5D%28index%3AInt%29-instance-method) meaning that we can also use _unpacking_.

## Blocks' returned value

A _block_, by default, returns the value of the last expression (the same as a method).

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

The output is empty! This is because Crystal implements *full closures*, meaning that using `return` inside the block will return, not only from the _block_ itself but, from the method where the _block_ is defined (i.e. `#test_number` in the above example).

If we want to return only from the _block_ then we need to use the keyword `next`:

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

The last keyword for returning from a _block_ is `break`. Let's see how it behaves:

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

As we can see the behaviour is something between using `return` and `next`. With `break` we return from the _block_ and from the method yielding the _block_ (`#with_number` in this example) but not from the method where the `block` is defined.

## Type restrictions

Until now we have been using _blocks_ without any kind of type restrictions, moreover, we did not declare the block as a method parameter (it was implied by the use of `yield`).

So first, we will declare a _block_ as a method parameter: it should be placed last and the parameter's name should be prefixed by `&`. Then we can use `yield` as before.

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

We almost at the end of this section. Let's see some other interesting ways of writing _blocks_.

### Curly braces

Another way of defining a _block_ is using `{...}` instead of `do ... end`. Here is one of the examples we have already seen but written with _curly braces syntax_:

```crystal-play
def other_method
  yield 42, "Hello", [1, "Crystal", 3]
end

other_method { |n, s, arr|
  puts "#{s} #{arr[1]}"
  puts n
}
```

Here is the  `_` example written with _curly braces syntax_ and in one line:

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
def generate_number()
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
def generate_number()
  42
end

def with_double(n : Int32)
  yield n * 2
end

with_double generate_number { |n| puts n } # Error: 'generate_number' is not expected to be invoked with a block, but a block was given
```

The error is because with _curly braces_ we are writing: `with_double(generate_number { |n| puts n })` instead of `with_double(generate_number) { |n| puts n }`

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

First we split the block parameter using the _short one-parameter syntax_ `&.split`. Then, we chained the result applying `map` and using again the _short one-parameter syntax_ `.map(&.capitalize)`. And finally we join the `array` of `strings` using `join(' ')`.

Now, what if we want to parameterize the string we transform. Can we still use the _short one-parameter syntax_? The answer is yes! Let's see:

```crystal-play
def transform_string(word : String)
  puts yield word
end

transform_string("hello crystal", &.split.map(&.capitalize).join(' '))
```

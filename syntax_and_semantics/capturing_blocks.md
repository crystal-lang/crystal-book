# Capturing blocks

A block can be captured and turned into a `Proc`, which represents a block of code with an associated context: the closured data.

To capture a block you must specify it as a method's block argument, and return that block from the method.

## Simple example

```crystal
def int_to_int(&block : Int32 -> Int32)
  block
end

proc = int_to_int { |x| x + 1 }
proc.call(1) #=> 2
```

The above code captures the block of code passed to `int_to_int` in the `block` variable, and returns it from the method. The type of `proc` is [Proc(Int32, Int32)](http://crystal-lang.org/api/Proc.html), a function that accepts a single `Int32` argument and returns an `Int32`.

## Saving a captured block as a callback

A captured block can be saved as a callback:

```crystal
class Model
  def on_save(&block)
    @on_save_callback = block
  end

  def save
    if callback = @on_save_callback
      callback.call
    end
  end
end

model = Model.new
model.on_save { puts "Saved!" }
model.save # prints "Saved!"
```

In the above example the type of `&block` wasn't specified: this just means that the captured block doesn't have arguments and doesn't return anything.

## Options for capturing blocks

Capturing is not limited to requiring one block argument and a specific return type.
A block can be captured in many ways. A captured block can:
- Have any number of block arguments (arguments must be a specific type `Int32` not `Int`)
  - Zero arguments: `->`
  - One argument: `Int32 ->`
  - Many arguments: `Int32, String, Array ->`
- Return a specific type (e.g. `-> Int32`, `-> String`)
- Return anything (using `-> _`)
- Return nothing (e.g. `Int32 ->`, `->`)

### Any number of block arguments

A captured block can take any number of arguments. The arguments must be specifically typed:

```crystal
def zero_args(&block : -> String)
  block
end

zero = zero_args { "0" }
zero.call # => "0"

def one_arg(&block : Int32 -> String)
  block
end

one = one_arg { |a| a.to_s }
one.call(1) # => "1"

def two_args(&block : Int32, Int64 -> String)
  block
end

two = two_args { |a, b| a.to_s + b.to_s }
two.call(1, 2_i64) # => "12"
```

### Return a specific type

The return type of the captured block can be a specific type:

```crystal
def return_a_string(&block : -> String)
  block
end

string_return = return_a_string { "I'm a string!" }
string_return.call #=> "I'm a string!"

def return_an_int(&block : Int32 -> Int32)
  block
end

int_return = return_an_int { |x| x + 1 }
int_return.call(1) #=> 2
```

### Return anything

A captured block can have a generic return, using `_` as the return type:

```crystal
def return_anything(&block : -> _)
  block
end

string_return = return_anything { "I'm a string!" }
string_return.call #=> "I'm a string!"
int_return = return_anything { 2 }
int_return.call #=> 2
```

### Return nothing

Note that if the return type is not specified, `nil` is returned from the proc call:

```crystal
def some_proc(&block : Int32 ->)
  block
end

proc = some_proc { |x| x + 1 }
proc.call(1) # nil
```

## break and next

`return` and `break` can't be used inside a captured block. `next` can be used and will exit and give the value of the captured block.

## with ... yield

The default receiver within a captured block can't be changed by using `with ... yield`.

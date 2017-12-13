# Capturing blocks

A block can be captured and turned into a `Proc`, which represents a block of code with an associated context: the closured data.

To capture a block you must specify it as a method's block argument, give it a name and specify the input and output types. For example:

```crystal
def int_to_int(&block : Int32 -> Int32)
  block
end

proc = int_to_int { |x| x + 1 }
proc.call(1) #=> 2
```

The above code captures the block of code passed to `int_to_int` in the `block` variable, and returns it from the method. The type of `proc` is [Proc(Int32, Int32)](http://crystal-lang.org/api/Proc.html), a function that accepts a single `Int32` argument and returns an `Int32`.

In this way a block can be saved as a callback:

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

Note that if the return type is not specified, nothing gets returned from the proc call:

```crystal
def some_proc(&block : Int32 ->)
  block
end

proc = some_proc { |x| x + 1 }
proc.call(1) # void
```

To have something returned, either specify the return type or use an underscore to allow any return type:

```crystal
def some_proc(&block : Int32 -> _)
  block
end

proc = some_proc { |x| x + 1 }
proc.call(1) # 2

proc = some_proc { |x| x.to_s }
proc.call(1) # "1"
```

To have something returned without requiring any arguments, omit arguments for the proc:

```crystal
def some_proc(&block : -> _)
  block
end

proc = some_proc { "Hello from a block" }
proc.call #=> "Hello from a block"

language = "crystal"
proc = some_proc { "#{language} closures local variables" }
proc.call #=> "crystal closures local variables"
```

In review, a proc can be captured in the following ways:

```crystal
### Procs with no return values ###

# A block that takes no arguments and has no return value
def proc_no_args_and_no_return_value(&block)
  block
end

proc = proc_no_args_and_no_return_value { "I return nothing" }
proc.call # => nil

# A proc that takes one argument and has no return value
def proc_with_one_arg_and_no_return_value(&block : Int32 ->)
  block
end

proc = proc_with_one_arg_and_no_return_value { |x| x + 1 }
proc.call(1) # => nil

# A proc that takes multiple arguments and has no return value
def proc_with_two_args_and_no_return_value(&block : Int32, Int32 ->)
  block
end

proc = proc_with_two_args_and_no_return_value { |a, b| a + b }
proc.call(1, 2) # => nil

### Procs with return values ###

# A proc that takes no arguments and returns a specific type
def proc_no_args_and_specific_return_type(&block : -> String)
  block
end

proc = proc_no_args_and_specific_return_type { "I can only return String types" }
proc.call # => "I can only return String types"

# A proc that takes no arguments and returns any type
def proc_no_args_and_any_return_type(&block : -> _)
  block
end

proc = proc_no_args_and_any_return_type { "I can return any Object" }
proc.call # => "I can return any Object"
proc = proc_no_args_and_any_return_type { 1 }
proc.call # => 1
proc = proc_no_args_and_any_return_type { [1, 2, "3"] }
proc.call # => [1, 2, "3"]

# A proc that takes one argument and returns a specific type
def proc_one_arg_and_specific_return_type(&block : String -> String)
  block
end

proc = proc_one_arg_and_specific_return_type { |x| "You passed: #{x}" }
proc.call("a string") # => "You passed: a string"

# A proc that takes two arguments and returns a specific type
def proc_two_args_and_specific_return_type(&block : Int32, Int32 -> Int32)
  block
end

proc = proc_two_args_and_specific_return_type { |a, b| a + b }
proc.call(1, 2) # => 3

# A proc that takes two arguments and returns any type
def proc_two_args_and_specific_return_type(&block : Int32, Int32 -> _)
  block
end

proc = proc_two_args_and_specific_return_type { |a, b| a + b }
proc.call(1, 2) # => 3
proc = proc_two_args_and_specific_return_type { |a, b| (a + b).to_s }
proc.call(1, 2) # => "3"
```

end

## break and next

`return` and `break` can't be used inside a captured block. `next` can be used and will exit and give the value of the captured block.

## with ... yield

The default receiver within a captured block can't be changed by using `with ... yield`.

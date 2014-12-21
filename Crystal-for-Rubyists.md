Although Crystal has a Ruby-like syntax, Crystal is a different language, not another Ruby implementation. For this reason, and mostly because it's a compiled, statically typed language, the language has some big differences when compared to Ruby.

## Crystal as a compiled language

### Using the `crystal` program

If you have a program `foo.cr`:

```crystal
# Crystal
puts "Hello world"
```

When you execute one of these commands:

```
crystal foo.cr
ruby foo.cr
```

You will get this output:

```
Hello world
```

It looks like `crystal` interprets the file, but what actually happens is that the file `foo.cr` is first compiled to a temporary executable and then this executable is run. This behaviour is very useful in the development cycle as you normally compile a file and want to immediately execute it.

If you want to compile it you can use the `build` command:

```
crystal build foo.cr
```

This will create a `foo` executable, which you can then run with `./foo`.

Note that this creates an executable that is not optimized. To optimize it, pass the `--release` flag:

```
crystal build foo.cr --release
```

When writing benchmarks or testing performance, always remember to compile in release mode.

You can check other commands and flags by invoking `crystal` without arguments, or `crystal` with a command and no arguments (for example `crystal build` will list all flags that can be used with that command).

## Semantic differences

### The `[]` and `[]?` methods

In Ruby the `[]` method generally returns `nil` if an element by that index/key is not found. For example:

```ruby
# Ruby
a = [1, 2, 3]
a[10] #=> nil

h = {a: 1}
h[1] #=> nil
```

In Crystal an exception is thrown in those cases:

```crystal
# Crystal
a = [1, 2, 3]
a[10] #=> raises IndexOutOfBounds

h = {a: 1}
h[1] #=> raises MissingKey
```

The reason behind this change is that it would be very annoying to program in this way if every Array or Hash access could return `nil` as a potential value. This wouldn't work:

```crystal
# Crystal
a = [1, 2, 3]
a[0] + a[1] #=> Error: undefined method `+` for Nil
```

If you do want to get `nil` if the index/key is not found, you can use the `[]?` method:

```crystal
# Crystal
a = [1, 2, 3]
value = a[4]? #=> return a value of type Int32 | Nil
if value
  puts "The number at index 4 is : #{value}"
else
  puts "No number at index 4"
end
```

The `[]?` is just a regular method that you can (and should) define for a container-like class.

Another thing to know is that when you do this:

```crystal
# Crystal
h = {1 => 2}
h[3] ||= 4
```

the program is actually translated to this:

```crystal
# Crystal
h = {1 => 2}
h[3]? || (h[3] = 4)
```

That is, the `[]?` method is used to check for the presence of an index/key.

Just as `[]` doesn't return `nil`, some Array and Hash methods also don't return nil and raise an exception if the element is not found: `first`, `last`, `shift`, `pop`, etc. For these a question-method is also provided to get the `nil` behaviour: `first?`, `last?`, `shift?`, `pop?`, etc.
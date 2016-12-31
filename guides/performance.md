# Performance

Follow these tips to get the best out of your programs, both in speed and memory terms.

## Premature optimization

Donald Knuth once said:

> We should forget about small efficiencies, say about 97% of the time: premature optimization is the root of all evil. Yet we should not pass up our opportunities in that critical 3%

However, if you are writing a program and you realize that writing a semantically equivalent, faster version involves just minor changes, you shouldn't miss that opportunity.

And always be sure to profile your program to learn what its bottlenecks are. For profiling, on Mac OSX you can use [Instruments Time Profiler](https://developer.apple.com/library/prerelease/content/documentation/DeveloperTools/Conceptual/InstrumentsUserGuide/Instrument-TimeProfiler.html), which comes with XCode. On Linux, a program that can profile C/C++ programs, like [gprof](https://sourceware.org/binutils/docs/gprof/), should work.

Make sure to always profile programs by compiling or running them with the `--release` flag, which turns on optimizations.

## Avoiding memory allocations

One of the best optimizations you can do in a program is avoiding extra/useless memory allocation. A memory allocation happens when you create an instance of a **class**, which ends up allocating heap memory. Creating an instance of a **struct** uses stack memory and doesn't incur a performance penalty. If you don't know the difference between stack and heap memory, be sure to [read this](https://www.google.com/search?q=stack+vs+heap+memory).

Allocating heap memory is slow, and it puts more pressure on the Garbage Collector (GC) as it will later have to free that memory.

There are several ways to avoid heap memory allocations. The standard library is designed in a way to help you do that.

### Don't create intermediate strings when writing to an IO

To print a number to the standard output you write:

```
puts 123
```

In many programming languages what will happen is that `to_s`, or a similar method for converting the object to its string representation, will be invoked, and then that string will be written to the standard output. This works, but it has a flaw: it creates an intermediate string, in heap memory, only to write it and then discard it. This, involves a heap memory allocation and gives a bit of work to the GC.

In Crystal, `puts` will invoke `to_s(io)` on the object, passing it the IO to which the string representation should be written.

So, you should never do this:

```
puts 123.to_s
```

as it will create an intermediate string. Always append an object directly to an IO.

When writing custom types, always be sure to override `to_s(io)`, not `to_s`, and avoid creating intermediate strings in that method. For example:

```crystal
class MyClass
  # Good
  def to_s(io)
    # appends "1, 2" to IO without creating intermediate strings
    x = 1
    y = 2
    io << x << ", " << y
  end

  # Bad
  def to_s(io)
    x = 1
    y = 2
    # using a string interpolation creates an intermediate string.
    # this should be avoided
    io << "#{x}, #{y}"
  end
end
```

This philosophy of appending to an IO instead of returning an intermediate string is present in other APIs, such as in the JSON and YAML APIs, where one needs to define `to_json(io)` and `to_yaml(io)` methods to write this data directly to an IO. And you should use this strategy in your API definitions too.

Let's compare the times:

```crystal
# io_benchmark.cr
require "benchmark"

io = IO::Memory.new

Benchmark.ips do |x|
  x.report("without to_s") do
    io << 123
    io.clear
  end

  x.report("with to_s") do
    io << 123.to_s
    io.clear
  end
end
```

Output:

```
$ crystal run --release io_benchmark.cr
without to_s  77.11M ( 12.97ns) (± 1.05%)       fastest
   with to_s  18.15M ( 55.09ns) (± 7.99%)  4.25× slower
```

And always remember that it's not just the time that has improved: memory usage is also decreased.

### Avoid creating temporary objects over and over

Consider this program:

```crystal
lines_with_language_reference = 0
while line = gets
  if ["crystal", "ruby", "java"].any? { |string| line.includes?(string) }
    lines_with_language_reference += 1
  end
end
puts "Lines that mention crystal, ruby or java: #{lines_with_language_reference}"
```

The above program works but has a big performance problem: on every iteration a new array is created for `["crystal", "ruby", "java"]`. Remember: an array literal is just syntax sugar for creating an instance of an array and adding some values to it, and this will happen over and over on each iteration.

There are two ways to solve this:

1. Use a tuple. If you use `{"crystal", "ruby", "java"}` in the above program it will work the same way, but since a tuple doesn't involve heap memory it will be faster, consume less memory, and give more chances for the compiler to optimize the program.

  ```crystal
  lines_with_language_reference = 0
  while line = gets
    if {"crystal", "ruby", "java"}.any? { |string| line.includes?(string) }
      lines_with_language_reference += 1
    end
  end
  puts "Lines that mention crystal, ruby or java: #{lines_with_language_reference}"
  ```

2. Move the array to a constant.

  ```crystal
  LANGS = ["crystal", "ruby", "java"]

  lines_with_language_reference = 0
  while line = gets
    if LANGS.any? { |string| line.includes?(string) }
      lines_with_language_reference += 1
    end
  end
  puts "Lines that mention crystal, ruby or java: #{lines_with_language_reference}"
  ```

Using tuples is the preferred way.

Explicit array literals in loops is one way to create temporary objects, but these can also be created via method calls. For example `Hash#keys` will return a new array with the keys each time it's invoked. Instead of doing that, you can use `Hash#each_key`, `Hash#has_key?` and other methods.

### Use structs when possible

If you declare your type as a **struct** instead of a **class**, creating an instance of it will use stack memory, which is much cheaper than heap memory and doesn't put pressure on the GC.

You shouldn't always use a struct, though. Structs are passed by value, so if you pass one to a method and the method makes changes to it, the caller won't see those changes, so they can be bug-prone. The best thing to do is to only use structs with immutable objects, especially if they are small.

For example:

```crystal
# class_vs_struct.cr
require "benchmark"

class PointClass
  getter x
  getter y

  def initialize(@x : Int32, @y : Int32)
  end
end

struct PointStruct
  getter x
  getter y

  def initialize(@x : Int32, @y : Int32)
  end
end

Benchmark.ips do |x|
  x.report("class") { PointClass.new(1, 2) }
  x.report("struct") { PointStruct.new(1, 2) }
end
```

Output:

```
$ crystal run --release class_vs_struct.cr
 class  28.17M (± 2.86%) 15.29× slower
struct 430.82M (± 6.58%)       fastest
```

## Iterating strings

Strings in Crystal always contain UTF-8 encoded bytes. UTF-8 is a variable-length encoding: a character may be represented by several bytes, although characters in the ASCII range are always represented by a single byte. Because of this, indexing a string with `String#[]` is not an `O(1)` operation, as the bytes need to be decoded each time to find the character at the given position. There's an optimization that Crystal's `String` does here: if it knows all the characters in the string are ASCII, then `String#[]` can be implemented in `O(1)`. However, this isn't generally true.

For this reason, iterating a String in this way is not optimal, and in fact has a complexity of `O(n^2)`:

```crystal
string = ...
while i < string.size
  char = string[i]
  # ...
end
```

There's a second problem with the above: computing the `size` of a String is also slow, because it's not simply the number of bytes in the string (the `bytesize`). However, once a String's size has been computed, it is cached.

The way to improve performance in this case is to either use one of the iteration methods (`each_char`, `each_byte`, `each_codepoint`), or use the more low-level `Char::Reader` struct. For example, using `each_char`:

```crystal
string = ...
string.each_char do |char|
  # ...
end
```

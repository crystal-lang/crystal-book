# Constants

Constants can be declared at the top level or inside other types. They must start with a capital letter:

```crystal
PI = 3.14

module Earth
  RADIUS = 6_371_000
end

PI            # => 3.14
Earth::RADIUS # => 6_371_000
```

Although not enforced by the compiler, constants are usually named with all capital letters and underscores to separate words.

A constant definition can invoke methods and have complex logic:

```crystal
TEN = begin
  a = 0
  while a < 10
    a += 1
  end
  a
end

TEN # => 10
```

When initialized, the [type inference algorithm](type_inference.md) can often implicitly determine the type of the constants:

```cr
module InferredTypes
  INTEGER = 1 # : Int32
  STRING = "" # : String
end
```

Constants can be typed explicitly, which can make use of [autocasting](autocasting.md):

```cr
module ExplicitType
  INTEGER : Int32 = 1
  STRING : String = ""
end

module AutocastTypes
  FOO : Int64 = 123       # autocasts 123 to Int64
  FOO : LibC::SizeT = 123 # autocasts 123 to platform SizeT
end
```

## Pseudo Constants

Crystal provides a few pseudo-constants which provide reflective data about the source code being executed.

`__LINE__` is the current line number in the currently executing Crystal file. When `__LINE__` is used as a default parameter value, it represents the line number at the location of the method call.

`__END_LINE__` is the line number of the `end` of the calling block. Can only be used as a default parameter value.

`__FILE__` references the full path to the currently executing Crystal file.

`__DIR__` references the full path to the directory where the currently executing Crystal file is located.

```crystal
# Assuming this example code is saved at: /crystal_code/pseudo_constants.cr
#
def pseudo_constants(caller_line = __LINE__, end_of_caller = __END_LINE__)
  puts "Called from line number: #{caller_line}"
  puts "Currently at line number: #{__LINE__}"
  puts "End of caller block is at: #{end_of_caller}"
  puts "File path is: #{__FILE__}"
  puts "Directory file is in: #{__DIR__}"
end

begin
  pseudo_constants
end

# Program prints:
# Called from line number: 13
# Currently at line number: 5
# End of caller block is at: 14
# File path is: /crystal_code/pseudo_constants.cr
# Directory file is in: /crystal_code
```

## Dynamic assignment

Dynamically assigning values to constants using the [chained assignment](assignment.md#chained-assignment) or the [multiple assignment](assignment.md#multiple-assignment) is not supported and results in a syntax error.

```{.crystal nocheck}
ONE, TWO, THREE = 1, 2, 3 # Syntax error: Multiple assignment is not allowed for constants
```

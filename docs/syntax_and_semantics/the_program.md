# Program

The program is the entirety of the source code worked by the compiler. The source gets parsed and compiled to an executable version of the program.

The program’s source code must be encoded in UTF-8.



## Top-level scope

Features such as types, constants, macros and methods defined outside any other namespace are in the top-level scope.

```crystal
# Defines a method in the top-level scope
def add(x, y)
  x + y
end

# Invokes the add method on the top-level scope
add(1, 2) # => 3
```

Local variables in the top-level scope are file-local and not visible inside method bodies.

```crystal
x = 1

def add(y)
  x + y # error: undefined local variable or method 'x'
end

add(2)
```

Private features are also only visible in the current file.

A double colon prefix (`::`) unambiguously references a namespace, constant, method or macro in the top-level scope:

```crystal
def baz
  puts "::baz"
end

CONST = "::CONST"

module A
  def self.baz
    puts "A.baz"
  end

  # Without prefix, resolves to the method in the local scope
  baz

  # With :: prefix, resolves to the method in the top-level scope
  ::baz

  CONST = "A::Const"

  p! CONST   # => "A::CONST"
  p! ::CONST # => "::CONST"
end
```

### Main code

Any expression that is neither a method, macro, constant or type definition, or in a method or macro body,
is part of the main code.
Main code is executed when the program starts in the order of the source file's inclusion.

There is no need to use a special entry point for the main code (such as a `main` method).

```crystal
# This is a program that prints "Hello Crystal!"
puts "Hello Crystal!"
```

Main code can also be inside namespaces:

```crystal
# This is a program that prints "Hello"
class Hello
  # 'self' here is the Hello class
  puts self
end
```

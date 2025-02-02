# Enums

!!! note
    This page is for [Crystal enums](https://crystal-lang.org/api/Enum.html). For C enums, see [C bindings enum](c_bindings/enum.md).

An enum is a set of integer values, where each value has an associated name. For example:

```crystal
enum Color
  Red
  Green
  Blue
end
```

An enum is defined with the `enum` keyword, followed by its name. The enum's body contains the values. Values start with the value `0` and are incremented by one. The default value can be overwritten:

```crystal
enum Color
  Red        # 0
  Green      # 1
  Blue   = 5 # overwritten to 5
  Yellow     # 6 (5 + 1)
end
```

Each constant in the enum has the type of the enum:

```crystal
Color::Red # :: Color
```

To get the underlying value, you invoke `value` on it:

```crystal
Color::Green.value # => 1
```

The type of the value is `Int32` by default, but can be changed:

```crystal
enum Color : UInt8
  Red
  Green
  Blue
end

Color::Red.value # :: UInt8
```

Only integer types are allowed as the underlying type.

All enums inherit from [Enum](https://crystal-lang.org/api/Enum.html).

## Flags enums

An enum can be marked with the `@[Flags]` annotation. This changes the default values:

```crystal
@[Flags]
enum IOMode
  Read  # 1
  Write # 2
  Async # 4
end
```

The `@[Flags]` annotation makes the first constant's value be `1`, and successive constants are multiplied by `2`.

Implicit constants, `None` and `All`, are automatically added to these enums, where `None` has the value `0` and `All` has the "or"ed value of all constants.

```crystal
IOMode::None.value # => 0
IOMode::All.value  # => 7
```

Additionally, some `Enum` methods check the `@[Flags]` annotation. For example:

```crystal
puts(Color::Red)                    # prints "Red"
puts(IOMode::Write | IOMode::Async) # prints "Write, Async"
```

## Enums from integers

An enum can be created from an integer:

```crystal
puts Color.new(1) # => prints "Green"
```

Values that don't correspond to an enum's constants are allowed: the value will still be of type `Color`, but when printed you will get the underlying value:

```crystal
puts Color.new(10) # => prints "10"
```

This method is mainly intended to convert integers from C to enums in Crystal.

## Question methods

An enum automatically defines question methods for each member, using
`String#underscore` for the method name.

!!! note
    In the case of regular enums, this compares by equality (`==`). In the case of flags enums, this invokes `includes?`.

For example:

```crystal
enum Color
  Red
  Green
  Blue
end

color = Color::Blue
color.red?  # => false
color.blue? # => true

@[Flags]
enum IOMode
  Read
  Write
  Async
end

mode = IOMode::Read | IOMode::Async
mode.read?  # => true
mode.write? # => false
mode.async? # => true
```

## Methods

Just like a class or a struct, you can define methods for enums:

```crystal
enum ButtonSize
  Sm
  Md
  Lg

  def label
    case self
    in .sm? then "small"
    in .md? then "medium"
    in .lg? then "large"
  end
end

ButtonSize::Sm.label # => "small"
ButtonSize::Lg.label # => "large"
```

Class variables are allowed, but instance variables are not.

## Usage

When a method parameter has an enum [type restriction](type_restrictions.md), it accepts either an enum constant or a [symbol](literals/symbol.md). The symbol will be automatically cast to an enum constant, raising a compile-time error if casting fails.

```crystal
def paint(color : Color)
  puts "Painting using the color #{color}"
end

paint Color::Red

paint :red # automatically casts to `Color::Red`

paint :yellow # Error: expected argument #1 to 'paint' to match a member of enum Color
```

The same automatic casting does not apply to case statements. To use enums with case statements, see [case enum values](case.md#enum-values).

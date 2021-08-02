# Math

## Numeric types

The two most common number types are `Int32` and `Float64`. The number in the name denotes the size in bits: `Int32` is a 32-bit [integer type](https://en.wikipedia.org/wiki/Integer_(computer_science)), `Float64` is a 64-bit [floating point number](https://en.wikipedia.org/wiki/Floating-point_arithmetic).

* An integer literal is written as a series of one or more base-10 digits (`0-9`) without leading zeros. The default type is `Int32`.
* A floating-point literal is written as a series of two or more base-10 digits (`0-9`) with a point (`.`) somewhere in the middle,
  indicating the decimal point. The default type is `Float64`.

All numeric types allow underscores at any place in the middle. This is useful to write large numbers in a more readable way: `100000` can be written as `100_000`.

```crystal-play
p! 1, typeof(1)
p! 1.0, typeof(1.0)
p! 100_000, typeof(100_000)
p! 100_000.0, typeof(100_000.0)
```

Float values print with a decimal point. Integer values don't.

!!! info
    There are quite a few more numeric types, but most of them are intended only for special use cases such as binary protocols,
    specific numeric algorithms, and performance optimization. You probably don't need them for everyday programs.

    See [Integer literal reference](../../syntax_and_semantics/literals/integers.md) and [Float literal reference](../../syntax_and_semantics/literals/floats.md)
    for a full reference on all primitive number types and alternative representations.

## Arithmetic

### Equality and Comparison

Numbers of the same numerical value are considered equal regarding the equality operator `==`, independent of their type.

```crystal-play
p! 1 == 1,
  1 == 2,
  1.0 == 1,
  -2000.0 == -2000
```

Besides the equality operator, there are also comparison operators. They determine the relationship between two values.
As with equality, comparability is also independent of type.

```crystal-play
p! 2 > 1,
  1 >= 1,
  1 < 2,
  1 <= 2
```

The universal comparison operator is `<=>`, also called *Spaceship operator* for its appearance. It compares its operands and returns a value that is either zero (both operands are equal),
a positive value (the first operand is bigger), or a negative value (the second operand is bigger). It combines the behaviour of all other comparison operators.

```crystal-play
p! 1 <=> 1,
  2 <=> 1,
  1 <=> 2
```

### Operators

Basic arithmetic operations can be performed with operators. Most operators are *binary* (i.e. two operands), and
written in infix notation (i.e. between the operands). Some operators are *unary* (i.e. one operand), and written in prefix
notation (i.e. before the operand).
The value of the expression is the result of the operation.

```crystal-play
p! 1 + 1, # addition
  1 - 1,  # subtraction
  2 * 3,  # multiplication
  2 ** 4, # exponentiation
  2 / 3,  # division
  2 // 3, # floor division
  3 % 2,  # modulus
  -1      # negation (unary)
```

As you can see, the result of most of these operations between integer operands is also an integer value.
The division operator (`/`) is an exception. It always returns a float value. The floor division operator (`//`) however returns an integer value, but it's obviously reduced to integer precision.
An operation between integer and float operands always returns a float value. Otherwise, the return type is usually the type of the first operand.

!!! info
    A full list of operators is available in [the Operator reference](../../syntax_and_semantics/operators.md#arithmetic-operators).

#### Precedence

When several operators are combined, the question arises in which order are they executed.
In math, there are several rules, like multiplication and division taking precedence over addition and subtraction.
Crystal operators implement these precedence rules.

A tool to structure operations are parentheses. An operator expression in parentheses always takes precedence over external operators.

```crystal-play
p! 4 + 5 * 2,
  (4 + 5) * 2
```

!!! info
    All the precedence rules are detailed in the [the Operator reference](../../syntax_and_semantics/operators.md#operator-precedence).

### Number Methods

Some less common math operations are not operators, but named methods.

```crystal-play
p! -5.abs,   # absolute value
  4.3.round, # round to nearest integer
  5.even?,   # odd/even check
  10.gcd(16) # greatest common divisor
```

!!! info
    A full list of numerical methods is available in [the Number API docs](https://crystal-lang.org/api/latest/Number.html) (also check subtypes).

### Math Methods

Some arithmetic methods are not defined on the number types directly but in the `Math` namespace.

```crystal-play
p! Math.cos(1),     # cosine
  Math.sin(1),      # sine
  Math.tan(1),      # tangent
  Math.log(42),     # natural logarithm
  Math.log10(312),  # logarithm to base 10
  Math.log(312, 5), # logarithm to base 5
  Math.sqrt(9)      # square root
```

!!! info
    A full list of math methods is available in [the Math API docs](https://crystal-lang.org/api/latest/Math.html).

## Constants

Some mathematical constants are available as constants of the `Math` module.

```crystal-play
p! Math::E,  # Euler's number
  Math::TAU, # Full circle constant (2 * PI)
  Math::PI   # Archimedes' constant (TAU / 2)
```

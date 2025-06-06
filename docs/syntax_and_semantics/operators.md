# Operators

Crystal supports a number of operators, with one, two or three operands.

Operator expressions are actually parsed as method calls. For example `a + b`
is semantically equivalent to `a.+(b)`, a call to method `+` on `a` with
argument `b`.

There are however some special rules regarding operator syntax:

* The dot (`.`) usually put between receiver and method name
  (i.e. the *operator*) can be omitted.
* Chained sequences of operator calls are restructured by the compiler in order
  to implement [operator precedence](#operator-precedence).
  Enforcing operator precedence makes sure that an expression such as
  `1 * 2 + 3 * 4` is parsed as `(1 * 2) + (2 * 3)` to honour regular math rules.
* Regular method names must start with a letter or underscore, but operators
  only consist of special characters. Any method not starting with a letter or
  underscore is an operator  method.
* Available operators are whitelisted in the compiler (see
  [List of Operators](#list-of-operators) below) which allows symbol-only method
  names and treats them as operators, including their precedence rules.

Operators are implemented like any regular method, and the standard library
offers many implementations, for example for math expressions.

## Defining operator methods

Most operators can be implemented as regular methods.

One can assign any meaning to the operators, but it is advisable to stay within
similar semantics to the generic operator meaning to avoid cryptic code that is
confusing and behaves unexpectedly.

A few operators are defined directly by the compiler and cannot be redefined
in user code. Examples for this are the inversion operator `!`, the assignment
operator `=`, [combined assignment operators](#combined-assignments) such as
`||=` and [range operators](#range). Whether a method can be redefined is
indicated by the column *Overloadable* in the below operator tables.

### Unary operators

Unary operators are written in prefix notation and have only a single operand.
Thus, a method implementation receives no arguments and only operates on `self`.

The following example demonstrates the `Vector2` type as a two-dimensional
vector with a unary operator method `-` for vector inversion.

```crystal
struct Vector2
  getter x, y

  def initialize(@x : Int32, @y : Int32)
  end

  # Unary operator. Returns the inverted vector to `self`.
  def - : self
    Vector2.new(-x, -y)
  end
end

v1 = Vector2.new(1, 2)
-v1 # => Vector2(@x=-1, @y=-2)
```

### Binary operators

Binary operators have two operands. Thus, a method implementation receives
exactly one argument representing the second operand. The first operand is the
receiver `self`.

The following example demonstrates the `Vector2` type as a two-dimensional
vector with a binary operator method `+` for vector addition.

```crystal
struct Vector2
  getter x, y

  def initialize(@x : Int32, @y : Int32)
  end

  # Binary operator. Returns *other* added to `self`.
  def +(other : self) : self
    Vector2.new(x + other.x, y + other.y)
  end
end

v1 = Vector2.new(1, 2)
v2 = Vector2.new(3, 4)
v1 + v2 # => Vector2(@x=4, @y=6)
```

Per convention, the return type of a binary operator should be the type of the
first operand (the receiver), so that `typeof(a <op> b) == typeof(a)`.
Otherwise the assignment operator (`a <op>= b`) would unintentionally change the
type of `a`.
There can be reasonable exceptions though. For example in the standard library
the float division operator `/` on integer types always returns `Float64`,
because the quotient must not be limited to the value range of integers.

### Ternary operators

The [conditional operator (`? :`)](./ternary_if.md) is the only ternary
operator. It not parsed as a method, and its meaning cannot be changed.
The compiler transforms it to an `if` expression.

## Operator Precedence

This list is sorted by precedence, so upper entries bind stronger than lower
ones.

<!-- markdownlint-disable no-space-in-code -->

| Category | Operators |
|---|---|
| Index accessors | `[]`, `[]?` |
| Unary | `+`, `&+`, `-`, `&-`, `!`, `~` |
| Exponential | `**`, `&**` |
| Multiplicative | `*`, `&*`, `/`, `//`, `%` |
| Additive | `+`, `&+`, `-`, `&-` |
| Shift | `<<`, `>>` |
| Binary AND | `&` |
| Binary OR/XOR | <code>\|</code>,`^` |
| Equality and Subsumption | `==`, `!=`, `=~`, `!~`, `===` |
| Comparison | `<`, `<=`, `>`, `>=`, `<=>` |
| Logical AND | `&&` |
| Logical OR | <code>\|\|</code> |
| Range | `..`, `...` |
| Conditional | `?:` |
| Assignment | `=`, `[]=`, `+=`, `&+=`, `-=`, `&-=`, `*=`, `&*=`, `/=`, `//=`, `%=`, <code>\|=</code>, `&=`,`^=`,`**=`,`<<=`,`>>=`, <code>\|\|=</code>, `&&=` |
| Splat | `*`, `**` |

<!-- markdownlint-enable no-space-in-code -->

## List of operators

### Arithmetic operators

#### Unary

| Operator | Description | Example | Overloadable | Associativity |
|---|---|---|---|---|
| `+`  | positive | `+1` | yes | right |
| `&+` | wrapping positive | `&+1` | yes | right |
| `-`  | negative | `-1` | yes | right |
| `&-` | wrapping negative | `&-1` | yes | right |

#### Multiplicative

| Operator | Description | Example | Overloadable | Associativity |
|---|---|---|---|---|
| `**` | exponentiation | `1 ** 2` | yes | right |
| `&**` | wrapping exponentiation | `1 &** 2` | yes | right |
| `*` | multiplication | `1 * 2` | yes | left |
| `&*` | wrapping multiplication | `1 &* 2` | yes | left |
| `/` | division | `1 / 2` | yes | left |
| `//` | floor division | `1 // 2` | yes | left |
| `%` | modulus | `1 % 2` | yes | left |

#### Additive

| Operator | Description | Example | Overloadable | Associativity |
|---|---|---|---|---|
| `+` | addition | `1 + 2` | yes | left |
| `&+` | wrapping addition | `1 &+ 2` | yes | left |
| `-` | subtraction | `1 - 2` | yes | left |
| `&-` | wrapping subtraction | `1 &- 2` | yes | left |

### Other unary operators

| Operator | Description | Example | Overloadable | Associativity |
|---|---|---|---|---|
| `!` | inversion | `!true` | no | right |
| `~` | binary complement | `~1` | yes | right |

### Shifts

| Operator | Description | Example | Overloadable | Associativity |
|---|---|---|---|---|
| `<<` | shift left, append | `1 << 2`, `STDOUT << "foo"` | yes | left |
| `>>` | shift right | `1 >> 2` | yes | left |

### Binary

| Operator | Description | Example | Overloadable | Associativity |
|---|---|---|---|---|
| `&` | binary AND | `1 & 2` | yes | left |
| <code>\|</code> | binary OR | <code>1 \| 2</code> | yes | left |
| `^` | binary XOR | `1 ^ 2` | yes | left |

### Relational operators

<span id="equality-and-comparison" />

Relational operators test a relation between two values.
They include *equality*, *inequalities*, and *subsumption*.

#### Equality

The **equal operator** `==` checks whether the values of the operands are
considered equal.

The **not-equal operator** `!=` is a shortcut to express the inversion: `a != b`
is supposed to be equivalent to `!(a == b)`.

Types that implement the not-equal operator must make sure to adhere to this.
Special implementations can be useful for performance reasons because
inequality can often be proven faster than equality.

Both operators are expected to be commutative, i.e. `a == b` if and only if
`b == a`. This is not enforced by the compiler and implementing types must
take care themselves.

| Operator | Description | Example | Overloadable | Associativity |
|---|---|---|---|---|
| `==` | equal | `1 == 2` | yes | left |
| `!=` | not equal | `1 != 2` | yes | left |

> INFO: The standard library defines [`Reference#same?`](https://crystal-lang.org/api/Reference.html#same?(other:Reference):Bool-instance-method) as another equality
> test that is not an operator.
> It checks for referential identity which determines whether two values reference
> the same location in memory.

#### Inequalities

<span id="comparison" />

Inequality operators describe the order between values.

The **three-way comparison operator** `<=>` (also known as *spaceship operator*)
expresses the order between two elements expressed by the sign of its
return value.

| Operator | Description | Example | Overloadable | Associativity |
|---|---|---|---|---|
| `<` | less | `1 < 2` | yes | left |
| `<=` | less or equal | `1 <= 2` | yes | left |
| `>` | greater | `1 > 2` | yes | left |
| `>=` | greater or equal | `1 >= 2` | yes | left |
| `<=>` | three-way comparison | `1 <=> 2` | yes | left |

> INFO: The standard library defines the [`Comparable`](https://crystal-lang.org/api/Comparable.html) module which derives all other inequality operators as well as
> the equal operator from the three-way comparison operator.

#### Subsumption

The **pattern match operator** `=~` checks whether the value of the first operand
matches the value of the second operand with pattern matching.

The **no pattern match operator** `!~` expresses the inverse.

The **case subsumption operator** `===` (also, imprecisely called
*case equality operator* or *triple equals*) checks whether the right hand
operand is a member of the set described by the left hand operator.
The exact interpretation varies depending on the involved data types.

The compiler inserts this operator in [`case ... when` conditions](case.md).

There is no inverse operator.

| Operator | Description | Example | Overloadable | Associativity |
|---|---|---|---|---|
| `=~` | pattern match | `"foo" =~ /fo/` | yes | left |
| `!~` | no pattern match | `"foo" !~ /fo/` | yes | left |
| `===` | case subsumption | `/foo/ === "foo"` | yes | left |

#### Chaining relational operators

<span id="chaining-equality-and-comparison" />

Relational operators `==`, `!=`, `===`, `<`, `>`, `<=`, and `>=`
can be chained together and are interpreted as a compound expression.
For example `a <= b <= c` is treated as `a <= b && b <= c`.
It is possible to mix different operators: `a >= b <= c > d` is
equivalent to `a >= b && b <= c && c > d`.

It is advised to only combine operators of the same
[precedence class](#operator-precedence) to avoid surprising bind behaviour.
For instance, `a == b <= c` is equivalent to `a == b && b <= c`, while `a <= b == c` is equivalent to `a <= (b == c)`.

### Logical

| Operator | Description | Example | Overloadable | Associativity |
|---|---|---|---|---|
| `&&` | [logical AND](and.md) | `true && false` | no | left |
| <code>\|\|</code> | [logical OR](or.md) | <code>true \|\| false</code> | no | left |

### Range

The range operators are used in [Range](literals/range.md)
literals.

| Operator | Description | Example | Overloadable |
|---|---|---|---|
| `..` | inclusive range | `1..10` | no |
| `...` | exclusive range | `1...10` | no |

### Splats

Splat operators can only be used for destructing tuples in method arguments.
See [Splats and Tuples](splats_and_tuples.md) for details.

| Operator | Description | Example | Overloadable |
|---|---|---|---|
| `*` | splat | `*foo` | no |
| `**` | double splat | `**foo` | no |

### Conditional

The [conditional operator (`? :`)](./ternary_if.md) is internally rewritten to
an `if` expression by the compiler.

| Operator | Description | Example | Overloadable | Associativity |
|---|---|---|---|---|
| `? :` | conditional | `a == b ? c : d` | no | right |

### Assignments

The assignment operator `=` assigns the value of the second operand to the first
operand. The first operand is either a variable (in this case the operator can't
be redefined) or a call (in this case the operator can be redefined).
See [assignment](assignment.md) for details.

| Operator | Description | Example | Overloadable | Associativity |
|---|---|---|---|---|
| `=` | variable assignment | `a = 1` | no | right |
| `=` | call assignment | `a.b = 1` | yes | right |
| `[]=` | index assignment | `a[0] = 1` | yes | right |

### Combined assignments

The assignment operator `=` is the basis for all operators that combine an
operator with assignment. The general form is `a <op>= b` and the compiler
transform that into `a = a <op> b`.

Exceptions to the general expansion formula are the logical operators:

* `a ||= b` transforms to `a || (a = b)`
* `a &&= b` transforms to `a && (a = b)`

There is another special case when `a` is an index accessor (`[]`), it is
changed to the nilable variant (`[]?` on the right hand side:

* `a[i] ||= b` transforms to `a[i] = (a[i]? || b)`
* `a[i] &&= b` transforms to `a[i] = (a[i]? && b)`

All transformations assume the receiver (`a`) is a variable. If it is a call,
the replacements are semantically equivalent but the implementation is a bit
more complex (introducing an anonymous temporary variable) and expects `a=` to
be callable.

The receiver can't be anything else than a variable or call.

| Operator | Description | Example | Overloadable | Associativity |
|---|---|---|---|---|
| `+=` | addition *and* assignment | `i += 1` | no | right |
| `&+=` | wrapping addition *and* assignment | `i &+= 1` | no | right |
| `-=` | subtraction *and* assignment | `i -= 1` | no | right |
| `&-=` | wrapping subtraction *and* assignment | `i &-= 1` | no | right |
| `*=` | multiplication *and* assignment | `i *= 1` | no | right |
| `&*=` | wrapping multiplication *and* assignment | `i &*= 1` | no | right |
| `/=` | division *and* assignment | `i /= 1` | no | right |
| `//=` | floor division *and* assignment | `i //= 1` | no | right |
| `%=` | modulo *and* assignment | `i %= 1` | yes | right |
| <code>\|=</code> | binary or *and* assignment | <code>i \|= 1</code> | no | right |
| `&=` | binary and *and* assignment | `i &= 1` | no | right |
| `^=` | binary xor *and* assignment | `i ^= 1` | no | right |
| `**=` | exponential *and* assignment | `i **= 1` | no | right |
| `<<=` | left shift *and* assignment | `i <<= 1` | no | right |
| `>>=` | right shift *and* assignment | `i >>= 1` | no | right |
| <code>\|\|=</code> | logical or *and* assignment | <code>i \|\|= true</code> | no | right |
| `&&=` | logical and *and* assignment | `i &&= true` | no | right |

### Index Accessors

Index accessors are used to query a value by index or key, for example an array
item or map entry. The nilable variant `[]?` is supposed to return `nil` when
the index is not found, while the non-nilable variant raises in that case.
Implementations in the standard-library usually raise [`KeyError`](https://crystal-lang.org/api/KeyError.html)
or [`IndexError`](https://crystal-lang.org/api/IndexError.html).

| Operator | Description | Example | Overloadable |
|---|---|---|---|
| `[]` | index accessor | `ary[i]` | yes |
| `[]?` | nilable index accessor | `ary[i]?` | yes |

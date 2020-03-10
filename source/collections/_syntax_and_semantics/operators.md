---
title: Operators
---

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
indicated by the colum *Overloadable* in the below operator tables.

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
-v1 #=> Vector2(@x=-1, @y=-2)
```

## Binary operators

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
v1 + v2 #=> Vector2(@x=4, @y=6)
```

Per convention, the return type of a binary operator should be the type of the
first operand (the receiver), so that `typeof(a <op> b) == typeof(a)`.
Otherwise the assignment operator (`a <op>= b`) would unintentionally change the
type of `a`.
There can be reasonable exceptions though. For example in the standard library
the float division operator `/` on integer types always returns `Float64`,
because the quotient must not be limited to the value range of integers.

## Ternary operators

The [conditional operator (`? :`)](./ternary_if.md) is the only ternary
operator. It not parsed as a method, and its meaning cannot be changed.
The compiler transforms it to an `if` expression.

## Operator Precedence

This list is sorted by precedence, so upper entries bind stronger than lower
ones.

<table>
<thead>
<tr>
<th>Category</th>
<th>Operators</th>
</tr>
</thead>
<tbody>
<tr>
<td>Index accessors</td>
<td><code>[]</code>, <code>[]?</code></td>
</tr>
<tr>
<td>Unary</td>
<td><code>+</code>, <code>&amp;+</code>, <code>-</code>, <code>&amp;-</code>, <code>!</code>, <code>~</code>, <code>*</code>, <code>**</code></td>
</tr>
<tr>
<td>Exponential</td>
<td><code>**</code>, <code>&amp;**</code></td>
</tr>
<tr>
<td>Multiplicative</td>
<td><code>*</code>, <code>&amp;*</code>, <code>/</code>, <code>//</code>, <code>%</code></td>
</tr>
<tr>
<td>Additive</td>
<td><code>+</code>, <code>&amp;+</code>, <code>-</code>, <code>&amp;-</code></td>
</tr>
<tr>
<td>Shift</td>
<td><code>&lt;&lt;</code>, <code>&gt;&gt;</code></td>
</tr>
<tr>
<td>Binary AND</td>
<td><code>&amp;</code></td>
</tr>
<tr>
<td>Binary OR/XOR</td>
<td><code>|</code>,<code>^</code></td>
</tr>
<tr>
<td>Equality</td>
<td><code>==</code>, <code>!=</code>, <code>=~</code>, <code>!~</code>, <code>===</code></td>
</tr>
<tr>
<td>Comparison</td>
<td><code>&lt;</code>, <code>&lt;=</code>, <code>&gt;</code>, <code>&gt;=</code>, <code>&lt;=&gt;</code></td>
</tr>
<tr>
<td>Logical AND</td>
<td><code>&amp;&amp;</code></td>
</tr>
<tr>
<td>Logical OR</td>
<td><code>||</code></td>
</tr>
<tr>
<td>Range</td>
<td><code>..</code>, <code>...</code></td>
</tr>
<tr>
<td>Conditional</td>
<td><code>?:</code></td>
</tr>
<tr>
<td>Assignment</td>
<td><code>=</code>, <code>[]=</code>, <code>+=</code>, <code>&amp;+=</code>, <code>-=</code>, <code>&amp;-=</code>, <code>*=</code>, <code>&amp;*=</code>, <code>/=</code>, <code>//=</code>, <code>%=</code>, <code>|=</code>, <code>&amp;=</code>,<code>^=</code>,<code>**=</code>,<code>&lt;&lt;=</code>,<code>&gt;&gt;=</code>, <code>||=</code>, <code>&amp;&amp;=</code></td>
</tr>
</tbody>
</table>

## List of operators

### Arithmetic operators

#### Unary

| Operator | Description | Example | Overloadable |
|---|---|---|---|
| `+`  | positive | `+1` | yes |
| `&+` | wrapping positive | `&+1` | yes |
| `-`  | negative | `-1` | yes |
| `&-` | wrapping negative | `&-1` | yes |

#### Multiplicative

| Operator | Description | Example | Overloadable |
|---|---|---|---|
| `**` | exponentiation | `1 ** 2` | yes |
| `&**` | wrapping exponentiation | `1 &** 2` | yes |
| `*` | multiplication | `1 * 2` | yes |
| `&*` | wrapping multiplication | `1 &* 2` | yes |
| `/` | division | `1 / 2` | yes |
| `//` | floor division | `1 // 2` | yes |
| `%` | modulus | `1 % 2` | yes |

#### Additive

| Operator | Description | Example | Overloadable |
|---|---|---|---|
| `+` | addition | `1 + 2` | yes |
| `&+` | wrapping addition | `1 &+ 2` | yes |
| `-` | subtraction | `1 - 2` | yes |
| `&-` | wrapping subtraction | `1 &- 2` | yes |

### Other unary operators

| Operator | Description | Example | Overloadable |
|---|---|---|---|
| `!` | inversion | `!true` | no |
| `~` | binary complement | `~1` | yes |

### Shifts

| Operator | Description | Example | Overloadable |
|---|---|---|---|
| `<<` | shift left, append | `1 << 2`, `STDOUT << "foo"` | yes |
| `>>` | shift right | `1 >> 2` | yes |

### Binary

<table>
<thead>
<tr>
<th>Operator</th>
<th>Description</th>
<th>Example</th>
<th>Overloadable</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>&amp;</code></td>
<td>binary AND</td>
<td><code>1 &amp; 2</code></td>
<td>yes</td>
</tr>
<tr>
<td><code>|</code></td>
<td>binary OR</td>
<td><code>1 | 2</code></td>
<td>yes</td>
</tr>
<tr>
<td><code>^</code></td>
<td>binary XOR</td>
<td><code>1 ^ 2</code></td>
<td>yes</td>
</tr>
</tbody>
</table>

### Equality

Three base operators test equality:

* `==`: Checks whether the values of the operands are equal
* `=~`: Checks whether the value of the first operand matches the value of the
second operand with pattern matching.
* `===`: Checks whether the left hand operand matches the right hand operand in
  [case equality](case.html). This operator is applied in `case ... when`
  conditions.

The first two operators also have inversion operators (`!=` and `!~`) whose
semantical intention is just the inverse of the base operator: `a != b` is
supposed to be equivalent to `!(a == b)` and `a !~ b` to `!(a =~ b)`.
Nevertheless, these inversions can be defined with a custom implementation. This
can be useful for example to improve performance (non-equality can often be
proven faster than equality).

| Operator | Description | Example | Overloadable |
|---|---|---|---|
| `==` | equals | `1 == 2` | yes |
| `!=` | not equals | `1 != 2` | yes |
| `=~` | pattern match | `"foo" =~ /fo/` | yes |
| `!~` | no pattern match | `"foo" !~ /fo/` | yes |
| `===` | [case equality](case.html) | `/foo/ === "foo"` | yes |

### Comparison

| Operator | Description | Example | Overloadable |
|---|---|---|---|
| `<` | less | `1 < 2` | yes |
| `<=` | less or equal | `1 <= 2` | yes |
| `>` | greater | `1 > 2` | yes |
| `>=` | greater or equal | `1 >= 2` | yes |
| `<=>` | comparison | `1 <=> 2` | yes |

### Logical

<table>
<thead>
<tr>
<th>Operator</th>
<th>Description</th>
<th>Example</th>
<th>Overloadable</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>&amp;&amp;</code></td>
<td><a href="and.html">logical AND</a></td>
<td><code>true &amp;&amp; false</code></td>
<td>no</td>
</tr>
<tr>
<td><code>||</code></td>
<td><a href="or.html">logical OR</a></td>
<td><code>true || false</code></td>
<td>no</td>
</tr>
</tbody>
</table>

### Range

The range operators are used in [Range](literals/range.md)
literals.

| Operator | Description | Example | Overloadable |
|---|---|---|---|
| `..` | range | `1..10` | no |
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

| Operator | Description | Example | Overloadable |
|---|---|---|---|
| `? :` | conditional | `a == b ? c : d` | no |

### Assignments

The assignment operator `=` assigns the value of the second operand to the first
operand. The first operand is either a variable (in this case the operator can't
be redefined) or a call (in this case the operator can be redefined).
See [assignment](assignment.md) for details.

| Operator | Description | Example | Overloadable |
|---|---|---|---|
| `=` | variable assignment | `a = 1` | no |
| `=` | call assignment | `a.b = 1` | yes |
| `[]=` | index assignment | `a[0] = 1` | yes |

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

<table>
<thead>
<tr>
<th>Operator</th>
<th>Description</th>
<th>Example</th>
<th>Overloadable</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>+=</code></td>
<td>addition <em>and</em> assignment</td>
<td><code>i += 1</code></td>
<td>no</td>
</tr>
<tr>
<td><code>&amp;+=</code></td>
<td>wrapping addition <em>and</em> assignment</td>
<td><code>i &amp;+= 1</code></td>
<td>no</td>
</tr>
<tr>
<td><code>-=</code></td>
<td>subtraction <em>and</em> assignment</td>
<td><code>i -= 1</code></td>
<td>no</td>
</tr>
<tr>
<td><code>&amp;-=</code></td>
<td>wrapping subtraction <em>and</em> assignment</td>
<td><code>i &amp;-= 1</code></td>
<td>no</td>
</tr>
<tr>
<td><code>*=</code></td>
<td>multiplication <em>and</em> assignment</td>
<td><code>i *= 1</code></td>
<td>no</td>
</tr>
<tr>
<td><code>&amp;*=</code></td>
<td>wrapping multiplication <em>and</em> assignment</td>
<td><code>i &amp;*= 1</code></td>
<td>no</td>
</tr>
<tr>
<td><code>/=</code></td>
<td>division <em>and</em> assignment</td>
<td><code>i /= 1</code></td>
<td>no</td>
</tr>
<tr>
<td><code>//=</code></td>
<td>floor division <em>and</em> assignment</td>
<td><code>i //= 1</code></td>
<td>no</td>
</tr>
<tr>
<td><code>%=</code></td>
<td>modulo <em>and</em> assignment</td>
<td><code>i %= 1</code></td>
<td>yes</td>
</tr>
<tr>
<td><code>|=</code></td>
<td>binary or <em>and</em> assignment</td>
<td><code>i |= 1</code></td>
<td>no</td>
</tr>
<tr>
<td><code>&amp;=</code></td>
<td>binary and <em>and</em> assignment</td>
<td><code>i &amp;= 1</code></td>
<td>no</td>
</tr>
<tr>
<td><code>^=</code></td>
<td>binary xor <em>and</em> assignment</td>
<td><code>i ^= 1</code></td>
<td>no</td>
</tr>
<tr>
<td><code>**=</code></td>
<td>exponential <em>and</em> assignment</td>
<td><code>i **= 1</code></td>
<td>no</td>
</tr>
<tr>
<td><code>&lt;&lt;=</code></td>
<td>left shift <em>and</em> assignment</td>
<td><code>i &lt;&lt;= 1</code></td>
<td>no</td>
</tr>
<tr>
<td><code>&gt;&gt;=</code></td>
<td>right shift <em>and</em> assignment</td>
<td><code>i &gt;&gt;= 1</code></td>
<td>no</td>
</tr>
<tr>
<td><code>||=</code></td>
<td>logical or <em>and</em>  assignment</td>
<td><code>i ||= true</code></td>
<td>no</td>
</tr>
<tr>
<td><code>&amp;&amp;=</code></td>
<td>logical and <em>and</em> assignment</td>
<td><code>i &amp;&amp;= true</code></td>
<td>no</td>
</tr>
</tbody>
</table>

### Index Accessors

Index accessors are used to query a value by index or key, for example an array
item or map entry. The nilable variant `[]?` is supposed to return `nil` when
the index is not found, while the non-nilable variant raises in that case.
Implementations in the standard-library usually raise [`KeyError`](https://crystal-lang.org/api/latest/KeyError.html)
or [`IndexError`](https://crystal-lang.org/api/latest/IndexError.html).

| Operator | Description | Example | Overloadable |
|---|---|---|---|
| `[]` | index accessor | `ary[i]` | yes |
| `[]?` | nilable index accessor | `ary[i]?` | yes |

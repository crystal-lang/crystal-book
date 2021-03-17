# Control Flow

## Primitive Types

### Nil

The most simplistic type is `Nil`. It has only a single value: `nil` and represents
the absence of an actual value. If you ask which car occupies a parking spot, and
no car is parking there, the answer is `nil`.

### Bool

The `Bool` type has just two possible values: `true` and `false` which represent the
truth values of logic and Boolean algebra.

```{.crystal, .crystal-play}
p! true, false
```

[Boolean values](https://en.wikipedia.org/wiki/Boolean_data_type) are particularly useful for
managing control flow in a program.

## Boolean Algebra

The following example shows operators for implementing [boolean algebra](https://en.wikipedia.org/wiki/Boolean_algebra) with
boolean values:

```{.crystal, .crystal-play}
a = true
b = false

p! a && b, # AND
   a || b, # OR
   !a,     # NOT
   a != b, # XOR
   a == b  # equivalence
```

You can try flicking the values of `a` and `b` to see the operator behaviour for different input values.

Boolean algebra however is not only defined for boolean types proper. All values have an implicit truthiness: `nil`, `false`
and null pointers (just for completeness, will be covered later) are *falsey*. Any other value is *truthy*.

Let's replace `true` and `false` in the above example with other values, for example `"foo"` and `nil`.

```{.crystal, .crystal-play}
a = "foo"
b = nil

p! a && b, # AND
   a || b, # OR
   !a,     # NOT
   a != b, # XOR
   a == b  # equivalence
```

The `AND` and `OR` operators return the first operand value matching the operator's truthiness.

```{.crystal, .crystal-play}
p! "foo" && nil
p! "foo" && false
p! false || "foo"
p! "bar" || "foo"
```

The `NOT`, `XOR` and equivalence operators always return a `Bool` value (`true` or `false`).

## Conditionals

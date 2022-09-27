# Integers

There are five signed integer types, and five unsigned integer types:

| Type | Length  | Minimum Value | Maximum Value |
| ---------- | -----------: | -----------: |-----------: |
| [Int8](http://crystal-lang.org/api/Int8.html)  | 8       | -128 | 127 |
| [Int16](http://crystal-lang.org/api/Int16.html)  | 16 | −32,768 | 32,767 |
| [Int32](http://crystal-lang.org/api/Int32.html) | 32  | −2,147,483,648 | 2,147,483,647 |
| [Int64](http://crystal-lang.org/api/Int64.html)   |  64 | −2<sup>63</sup> | 2<sup>63</sup> - 1 |
| [Int128](https://crystal-lang.org/api/Int128.html) | 128 | −2<sup>127</sup> | 2<sup>127</sup> - 1 |
| [UInt8](http://crystal-lang.org/api/UInt8.html) | 8 |  0 | 255 |  
| [UInt16](http://crystal-lang.org/api/UInt16.html) | 16 | 0 | 65,535 |
| [UInt32](http://crystal-lang.org/api/UInt32.html) | 32 |  0 | 4,294,967,295 |
| [UInt64](http://crystal-lang.org/api/UInt64.html) | 64 | 0 | 2<sup>64</sup> - 1 |
| [UInt128](https://crystal-lang.org/api/UInt128.html) | 128 | 0 | 2<sup>128</sup> - 1 |

An integer literal is an optional `+` or `-` sign, followed by
a sequence of digits and underscores, optionally followed by a suffix.
If no suffix is present, the literal's type is `Int32` if the value fits into `Int32`'s range,
and `Int64` otherwise. Integers outside `Int64`'s range must always be suffixed:

```crystal
1 # Int32

1_i8   # Int8
1_i16  # Int16
1_i32  # Int32
1_i64  # Int64
1_i128 # Int128

1_u8   # UInt8
1_u16  # UInt16
1_u32  # UInt32
1_u64  # UInt64
1_u128 # UInt128

+10 # Int32
-20 # Int32

2147483647  # Int32
2147483648  # Int64
-2147483648 # Int32
-2147483649 # Int64

9223372036854775807     # Int64
9223372036854775808_u64 # UInt64
```

Suffix-less integer literals larger than `Int64`'s maximum value but representable within
`UInt64`'s range are deprecated, e.g. `9223372036854775808`.

The underscore `_` before the suffix is optional.

Underscores can be used to make some numbers more readable:

```crystal
1_000_000 # better than 1000000
```

Binary numbers start with `0b`:

```crystal
0b1101 # == 13
```

Octal numbers start with a `0o`:

```crystal
0o123 # == 83
```

Hexadecimal numbers start with `0x`:

```crystal
0xFE012D # == 16646445
0xfe012d # == 16646445
```

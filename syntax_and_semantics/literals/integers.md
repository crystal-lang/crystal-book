# 整數

共有 4 種有號整數以及 4 種無號整數：

型別                                              | 長度（位元數）| 下界            | 上界
 ------------------------------------------------ | ------------: | --------------: |-----------:
[Int8](http://crystal-lang.org/api/Int8.html)     | 8             | -128            | 127
[Int16](http://crystal-lang.org/api/Int16.html)   | 16            | −32,768         | 32,767
[Int32](http://crystal-lang.org/api/Int32.html)   | 32            | −2,147,483,648  | 2,147,483,647
[Int64](http://crystal-lang.org/api/Int64.html)   | 64            | −2<sup>63</sup> | 2<sup>63</sup> - 1
[UInt8](http://crystal-lang.org/api/UInt8.html)   | 8             | 0               | 255
[UInt16](http://crystal-lang.org/api/UInt16.html) | 16            | 0               | 65,535
[UInt32](http://crystal-lang.org/api/UInt32.html) | 32            | 0               | 4,294,967,295
[UInt64](http://crystal-lang.org/api/UInt64.html) | 64            | 0               | 2<sup>64</sup> - 1

整數依照正負號（`+`/`-`，正號可省略）、`數字及底線`的規則組成，也可以加上後綴。

若無後綴時，該常值的型別為 `Int32`、`Int64` 或 `UInt64` 取最低者。如以下範例所示：

```crystal
1      # Int32

1_i8   # Int8
1_i16  # Int16
1_i32  # Int32
1_i64  # Int64

1_u8   # UInt8
1_u16  # UInt16
1_u32  # UInt32
1_u64  # UInt64

+10    # Int32
-20    # Int32

2147483648          # Int64
9223372036854775808 # UInt64
```

底線 `_` 對於後綴是可選的但可增加可讀性。

底線亦可用於數字中間使其更有可讀性：

```crystal
1_000_000 # 優於 1000000
```

二進位數字以 `0b` 開頭：

```crystal
0b1101 # == 13
```

八進位數字以 `0o` 開頭：

```crystal
0o123 # == 83
```

十六進位數字以 `0x` 開頭：

```crystal
0xFE012D # == 16646445
0xfe012d # == 16646445
```

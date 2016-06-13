# 整數

共有 4 種有號整數（[Int](http://crystal-lang.org/api/Int.html)）：[Int8](http://crystal-lang.org/api/Int8.html)、[Int16](http://crystal-lang.org/api/Int16.html)、[Int32](http://crystal-lang.org/api/Int32.html) 及 [Int64](http://crystal-lang.org/api/Int64.html)，可分別表示 8、16、32 和 64 位元的有號整數。

還有4種無號整數: [UInt8](http://crystal-lang.org/api/UInt8.html)、[UInt16](http://crystal-lang.org/api/UInt16.html)、[UInt32](http://crystal-lang.org/api/UInt32.html) 及 [UInt64](http://crystal-lang.org/api/UInt64.html)。

整數常值可選擇性帶有 `+` 或 `-` 號，接著是一連串的數字和底線，也可以加上後綴。
若無後綴，該常值的型別為 `Int32`、`Int64` 或 `UInt64` 最低者。
數字符合以下規則:

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

底線 `_` 可被加於後綴前方。

底線可用於讓數字更有可讀性:

```crystal
1_000_000 # 優於 1000000
```

二進位數字以 `0b` 開始:

```crystal
0b1101 # == 13
```

八進位數字以 `0o`開始:

```crystal
0o123 # == 83
```

十六進位數字以 `0x`開始:

```crystal
0xFE012D # == 16646445
0xfe012d # == 16646445
```

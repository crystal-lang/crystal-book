# 浮點數

有兩種浮點數型別，[Float32](http://crystal-lang.org/api/Float32.html) 及 [Float64](http://crystal-lang.org/api/Float64.html)，
分別對應於IEEE定義的型別 [單精度浮點數(binary32)](https://zh.wikipedia.org/wiki/單精度浮點數)
和 [雙精度浮點數(binary64)](https://zh.wikipedia.org/wiki/雙精度浮點數)。

浮點數常值由可選的 `+` 或 `-` 號，接著是一連串的數字或底線、小數點、數字或底線，
有可能有指數後綴，以及可選的型態後綴所構成。若無後綴，該常值型別為 `Float64`。

```crystal
1.0      # Float64
1.0_f32  # Float32
1_f32    # Float32

1e10     # Float64
1.5e10   # Float64
1.5e-7   # Float64

+1.3     # Float64
-0.5     # Float64
```

底線 `_` 可出現在後綴之前。

底線可使某些數字更有可讀性:

```crystal
1_000_000.111_111 # 優於 1000000.111111
```

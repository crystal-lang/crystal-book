# 陣列 <small>Array</small>

陣列（[Array](http://crystal-lang.org/api/Array.html)）為一以整數為索引之有序泛型集合<small>(Generic collection)</small>，其中包含型別為 `T` 的元素。

通常我們可以使用中括號（`[]`）表達一個陣列常值，並用逗號（`,`）分隔內部的元素：

```crystal
[1, 2, 3]
```

## 泛型型別參數

陣列的泛型型別參數 `T` 會從元素中推導得出，如果所有的元素都屬於同一種型別，那麼 `T` 就會是該型別；若非，則 `T` 會是所有元素型別的型別集合。

```crystal
[1, 2, 3]          # => Array(Int32)
[1, "hello", 'x']  # => Array(Int32 | String | Char)
```

我們也可以透過在陣列後方接著的 `of` 手動指定型別，讓我們可以先建立陣列後再將元素塞入。

```crystal
array_of_numbers = [1, 2, 3] of Float64 | Int32  # => Array(Float64 | Int32)
array_of_numbers << 0.5                          # => [1, 2, 3, 0.5]


array_of_int_or_string = [1, 2, 3] of Int32 | String  # => Array(Int32 | String)
array_of_int_or_string << "foo"                       # => [1, 2, 3, "foo"]
```

而空陣列則一定要指定型別：

```crystal
[] of Int32  # => Array(Int32).new
```

## 百分比陣列常值表示法

[字串陣列](./string.md#Percent String Array Literal)及[符號陣列](./symbol.md#Percent Symbol Array Literal)可以使用百分比（`%`）陣列常值的表達方式來描述陣列常值：

```crystal
%w(one two three)  # => ["one", "two", "three"]
%i(one two three)  # => [:one, :two, :three]
```

## 類・陣列<small>(Array-like)</small>型別常值

Crystal 亦對類・陣列的型別提供以大括號（`{}`）的方式來描述常值：

```crystal
Array{1, 2, 3}
```

只要型別中有定義不需要參數的 `new` 方法以及定義 `<<` 方法，我們就可以使用這個方法來描述該型別的常值：

```crystal
IO::Memory{1, 2, 3}
Set{1, 2, 3}
```

對於非泛型的型別如 `IO:Memory` ，上方表達式等義於：

```crystal
array_like = IO::Memory.new
array_like << 1
array_like << 2
array_like << 3
```

反之，若該型別是泛型如 `Set` ，則泛型型別參數 `T` 會如同陣列一般推導，也就是說上方表達式等義於：

```crystal
array_like = Set(typeof(1, 2, 3)).new
array_like << 1
array_like << 2
array_like << 3
```

在泛型的應用上我們也可以手動指定型別：

```crystal
Set(Int32) {1, 2, 3}
```

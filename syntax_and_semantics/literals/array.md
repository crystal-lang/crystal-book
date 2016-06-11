# 陣列 <small>Array</small>

陣列（[Array](http://crystal-lang.org/api/Array.html)）為一泛型<small>(Generic type)</small>型別，其中包含型別為 `T` 的元素。

通常我們可以這樣表達一個陣列：

```crystal
[1, 2, 3]         # Array(Int32)
[1, "hello", 'x'] # Array(Int32 | String | Char)
```

陣列可以混合多種型別，這表示 `T` 可以是一個型別的集合，但 `T` 所代表的型別必須在陣列建立的時候就指定、或是從陣列常值中提取出來。
剛剛的範例中可以看到，第二行陣列的 `T` 是一個從陣列常值中提取出來的型別集合。

建立空白陣列時，需要手動指定 `T` 的型別：

```crystal
[] of Int32 # 相當於 Array(Int32).new
[]          # 語法錯誤 (syntax error)
```

## 字串陣列

當要描述的陣列常值皆由字串常值所組成時，我們可以使用以下的語法：

```crystal
%w(one two three) # ["one", "two", "three"]
```

## 符號陣列

當要描述的陣列常值皆由符號常值所組成時，我們可以使用以下的語法：

```crystal
%i(one two three) # [:one, :two, :three]
```

## 類·陣列 型別

只要型別中有定義不需要參數的 `new` 方法以及定義 `<<` 方法，我們就可以使用一種特化的陣列常值語法來建立該描述該型別的常值：

```crystal
MyType{1, 2, 3}
```

若 `MyType` 不是泛型的話，上方表達式等義於：

```crystal
tmp = MyType.new
tmp << 1
tmp << 2
tmp << 3
tmp
```

反之，若 `MyType` 是泛型，則上方表達式等義於：

```crystal
tmp = MyType(typeof(1, 2, 3)).new
tmp << 1
tmp << 2
tmp << 3
tmp
```

在泛型的應用上我們也可以手動指定型別：

```crystal
MyType(Int32 | String) {1, 2, "foo"}
```

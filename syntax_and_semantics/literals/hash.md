# 雜湊 <small>Hash</small>

雜湊（[Hash](http://crystal-lang.org/api/Hash.html)）用來表示索引鍵<small>(Key)</small>與值<small>(Value)</small>之間的對應關係，其中索引鍵為 `K` 型別、值為 `V` 型別。

通常我們可以這樣表達一個雜湊常值：

```crystal
{1 => 2, 3 => 4}     # Hash(Int32, Int32)
{1 => 2, 'a' => 3}   # Hash(Int32 | Char, Int32)
{1 => 'a', 2 => 2}   # Hash(Int32, Int32 | Char)
{1 => 'a', 'b' => 2} # Hash(Int32 | Char, Int32 | Char)
```

雜湊不論索引鍵或值皆可混合多種型別，這表示 `K`/`V` 可以是一個型別的集合，但與[陣列](./string.md)相同，`K` 及 `V` 所代表的型別都必須在雜湊建立的時候就指定、或是從雜湊常值中提取出來。

從剛剛的範例可以看到，`K` 及 `V` 是分別從雜湊常值的索引鍵與值中提取出型別集合。

建立空白雜湊時，需要手動指定 `K` 以及 `V` 的型別：

```crystal
{} of Int32 => Int32 # 相當於 Hash(Int32, Int32).new
{}                   # 語法錯誤 (syntax error)
```

## 字串索引鍵

當索引鍵為字串時，可以使用下列寫法：

```crystal
{"key1": 'a', "key2": 'b'} # Hash(String, Char)
```

## 類·雜湊<small>(Hash-like)</small>型別

只要型別中有定義不需要參數的 `new` 方法以及定義 `[]=` 方法，我們就可以使用類似雜湊常值的語法來建立該描述該型別的常值：

```crystal
MyType{"foo": "bar"}
```

若 `MyType` 不是泛型的話，上方表達式等義於：

```crystal
tmp = MyType.new
tmp["foo"] = "bar"
tmp
```

反之，若 `MyType` 是泛型，則上方表達式等義於：

```crystal
tmp = MyType(typeof("foo"), typeof("bar")).new
tmp["foo"] = "bar"
tmp
```

在泛型的應用上我們也可以手動指定型別：

```crystal
MyType(String, String) {"foo": "bar"}
```

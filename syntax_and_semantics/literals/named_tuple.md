# 命名序組 <small>NamedTuple</small>

通常我們會用下面的常值語法來建立一個命名序組（[NamedTuple](http://crystal-lang.org/api/NamedTuple.html)）：

```crystal
tuple = {name: "Crystal", year: 2011} # NamedTuple(name: String, year: Int32)
tuple[:name] # => "Crystal" (String)
tuple[:year] # => 2011      (Int32)
```

如同[序組](./tuple.md)，我們也可以使用下面的語法來指定命名序組使用的型別：

```crystal
# 以下型別表示 x 為 Int32、y 為 String 的命名序組
NamedTuple(x: Int32, y: String)
```

當使用在型別限制時，於任何泛型型別參數或是其他需要填寫型別的地方，我們也可以使用簡短的語法來表示命名序組的型別，這在[型別語法](../type_grammar.md)一章中會解釋：

```crystal
# 以下語句表示了這個陣列的元素皆是 x 為 Int32、y 為 String 的命名序組
Array({x: Int32, y: String})
```

A named tuple key can also be a string literal:

```crystal
{"this is a key": 1}
```

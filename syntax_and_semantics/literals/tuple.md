# 序組 <small>Tuple</small>

我們通常用以下的常值語法建立一個序組（[Tuple](http://crystal-lang.org/api/Tuple.html)）：

```crystal
tuple = {1, "hello", 'x'} # Tuple(Int32, String, Char)
tuple[0]                  #=> 1       (Int32)
tuple[1]                  #=> "hello" (String)
tuple[2]                  #=> 'x'     (Char)
```

我們也可以用 [Tuple.new](http://crystal-lang.org/api/Tuple.html#new%28%2Aargs%29-class-method) 來建立空序組。

我們還可以使用下面的語法來指定序組使用的型別：

```crystal
# 以下型別表示依序包含 Int32、String 以及 Char 的序組
Tuple(Int32, String, Char)
```

當使用在型別限制時，於任何泛型型別參數或是其他需要填寫型別的地方，我們也可以使用簡短的語法來表示序組的型別，這在[型別語法](../type_grammar.md)一章中會解釋：

```crystal
# 以下語句表示了這個陣列的元素皆為包含了 Int32、String 以及 Char 的序組
Array({Int32, String, Char})
```

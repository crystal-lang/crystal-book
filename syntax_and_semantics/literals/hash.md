# 雜湊 <small>Hash</small>

雜湊（[Hash](http://crystal-lang.org/api/Hash.html)）為用來表示索引鍵<small>(Key)</small>與值<small>(Value)</small>對應關係的泛型集合，其中索引鍵為 `K` 型別、值為 `V` 型別。

通常我們可以透過大括號（`{}`）來表達一個雜湊常值，以 `=>` 描述成對的鍵值，並用逗號分隔（`,`）：

```crystal
{"one" => 1, "two" => 2}
```

# 泛型型別參數

泛型型別參數 `K` 、 `V` 分別由索引鍵與值的型別推導而來。
當所有的鍵或值都是相同型別時， `K`/`V` 則為該型別；否則為所有型別的型別集合。

```crystal
{1 => 2, 3 => 4}     # Hash(Int32, Int32)
{1 => 2, 'a' => 3}   # Hash(Int32 | Char, Int32)
{1 => 'a', 2 => 2}   # Hash(Int32, Int32 | Char)
{1 => 'a', 'b' => 2} # Hash(Int32 | Char, Int32 | Char)
```

我們也可以透過在陣列後方接著的 `of` 手動指定型別，以 `=>` 對應描述 `K` 與 `V` 的型別。這讓我們可以先建立陣列後再將元素塞入。

而空白的雜湊常值則必須要指定型別：

```crystal
{} of Int32 => Int32 # => Hash(Int32, Int32).new
```

=======
## 類・雜湊<small>(Hash-like)</small>型別常值

Crystal 亦對類・雜湊的型別提供以大括號（`{}`）的方式來描述常值：

```crystal
Hash{"one" => 1, "two" => 2}
```

只要型別中有定義不需要參數的 `new` 方法以及定義 `[]=` 方法，我們就可以使用這個方法來描述該型別的常值：

```crystal
HTTP::Headers{"foo" => "bar"}
```

對於非泛型的型別如 `HTTP::Headers`，上方表達式等義於：

```crystal
headers = HTTP::Headers.new
headers["foo"] = "bar"
```

反之，若該型別是泛型，則泛型型別參數 `K` 、 `V` 會如同雜湊一般推導：

```crystal
MyHash{"foo" => 1, "bar" => "baz"}
```

假設 `MyHash` 是泛型，則上方表達式等義於：

```crystal
my_hash = MyHash(typeof("foo", "bar"), typeof(1, "baz")).new
my_hash["foo"] = 1
my_hash["bar"] = baz
```

在泛型的應用上我們也可以手動指定型別：

```crystal
MyHash(String, String | Int32) {"foo" => "bar"}
```

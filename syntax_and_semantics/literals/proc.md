# 程序 <small>Proc</small>

程序（[Proc](http://crystal-lang.org/api/Proc.html)）用來表達一個函數指標，同時它可以有自己的上下文<small>(Context)</small>（或稱閉包<small>(Closure)</small>）。 

我們通常用下面的方式來描述一個程序常值：

```crystal
# 不帶有參數的程序：
->{ 1 } # Proc(Int32)

# 帶有一個參數的程序：
->(x : Int32) { x.to_s } # Proc(Int32, String)

# 有兩個參數的程序：
->(x : Int32, y : Int32) { x + y } # Proc(Int32, Int32, Int32)
```

除了當作 `fun` 的參數以外時，我們都必須指定程序中所有參數的型別。（有關 `fun` 的用法，請見 [C 語言綁紮](../c_bindings/README.md)一章）

而回傳值的型別則會從程序的內容中自動推導出來。

或是我們也可以下面的方式，用特化過的 `new` 來建立一個程序：

```crystal
Proc(Int32, String).new { |x| x.to_s } # Proc(Int32, String)
```

上面的形式可以讓我們手動指定回傳的型別並且可以用來預防程序回傳的型別不符的情況。

## The Proc type

如果要指定程序的型別，我們可以用下面的方式來表示：

```crystal
# 僅接受一個 Int32 參數且回傳一個 String 的程序
Proc(Int32, String)

# 不接受參數且回傳 Void 的程序
Proc(Void)

# 接受分別為 Int32 及 String 的參數並回傳一個 Char 的程序
Proc(Int32, String, Char)
```

當使用在型別限制時，於任何泛型型別參數或是其他需要填寫型別的地方，我們也可以使用簡短的語法來表示程序的型別，這在[型別語法](../type_grammar.md)一章中會解釋：

```crystal
# 以下語句表示了這個陣列的元素皆為接受分別為 Int32 及 String 且回傳 Char 的程序
Array(Int32, String -> Char)
```

## 呼叫

我們可以用 `call` 方法來呼叫一個程序，其參數必須符合程序中的定義：

```crystal
proc = ->(x : Int32, y : Int32) { x + y }
proc.call(1, 2) #=> 3
```

## 從現有方法建立

程序表達了函數指標，因此我們也可以從現有的方法建立程序：

```crystal
def one
  1
end

proc = ->one
proc.call #=> 1
```

不過當方法帶有參數時，我們還是需要指定型別：

```crystal
def plus_one(x)
  x + 1
end

proc = ->plus_one(Int32)
proc.call(41) #=> 42
```

程序也可以指定受器<small>(Receiver)</small>：

```crystal
# 將程序指向 str 的 count 方法
str = "hello"
proc = ->str.count(Char)
proc.call('e') #=> 1
proc.call('l') #=> 2
```

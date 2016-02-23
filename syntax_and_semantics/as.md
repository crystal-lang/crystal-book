# as

`as` 這個表達式侷限了一個表達式的型別。例如：

```crystal
if some_condition
  a = 1
else
  a = "hello"
end

# a :: Int32 | String
```

上述的程式碼中， `a` 是一個 `Int32 | String` 的結合。假設因為某些原因我們確定 `a` 在 `if` 後面是一個 `Int32` ，我們可以強至編譯器處理時將其視為一個：

```crystal
a_as_int = a as Int32
a_as_int.abs          # 可行，編譯器知道 a_as_int 是 Int32
```

`as` 這個表達是進行一次執行期檢查：如果 `a` 並不是一個 `Int32` ， 將會引發 [例外](exception_handling.html) 。

這個表達式的參數式一個 [型別](type_grammar.html) 。

如果將一個型別被令一個型別侷限是不可行的，將會被告知一個編譯時期錯誤：

```crystal
1 as String # Error
```

**提醒： ** 你不能使用 `as` 將一個型別轉換為一個部相關的型別： `as` 並不像其他語言裡的 `cast` 。整數、浮點數和字元上有提供這些轉換的方法。或是，如下方解釋的使用指標轉變。

## 指標型別之間的轉換

`as` 這個表達式也允許指標協別之間的轉變：

```crystal
ptr = Pointer(Int32).malloc(1)
ptr as Int8*                    #:: Pointer(Int8)
```

於上方的案例，並沒有執行期檢查：指標非常的不安全，而這類型的轉變通常只有於 C 綁定或是低階程式碼中才必要。

## 指標型別與其他型別之間的轉換

指標型別與參照型別之間的轉換也是可能的：

```crystal
array = [1, 2, 3]

# object_id 回傳一個物件在記憶體中的位址，
# 所以我們創造一個擁有該位址的指標
ptr = Pointer(Void).new(array.object_id)

# 現在我們可以把指標轉變為相同型態，然後
# 我們應當會得到相同的值
array2 = ptr as Array(Int32)
array2.same?(array) #=> true
```

再一次強調，這些案例中因為指標的涉入而沒有執行執行期檢查。這種轉變的需求甚至比比前一向更罕見，但允許實作 Crystal 裡的一些核心型別（例如字串） ，而且他也允許將期透過轉換為 void 指標後傳遞一個參照型別給 C 函式。

## 轉換為更大的型別的使用情況

`as` 這個表達式可以被用於轉換為 " 更大的 " 型別。例如：

```crystal
a = 1
b = a as Int32 | Float64
b #:: Int32 | Float64
```

上面的範例看起來可能不是很有用，但卻在 -- 舉例 -- 對應一個陣列中的元素時非常有用：

```crystal
ary = [1, 2, 3]

# 我們想要創建一個 Int32 | Float64 的陣列 1, 2, 3
ary2 = ary.map { |x| x as Int32 | Float64 }

ary2 #:: Array(Int32 | Float64)
ary2 << 1.5 # OK
```

`Array#map` 這個方法使用了區塊的型別作為陣列的一般型別。沒有 `as` 表達式時，推定的型別將會是 `Int32` 而且我們無法增加一個 `Float64` 進去。

## 當編譯器無法推斷一個區塊的型別的使用情況

有時編譯器並不能推斷區塊的型別，例如：

```crystal
class Person
  def initialize(@name)
  end

  def name
    @name
  end
end

a = [] of Person
x = a.map { |f| f.name } # Error: can't infer block return type
```

編譯器需要區塊的型別以作為 `Array#map` 創建的陣列的一般型別，但既然 `Person` 從來沒有被實例化，編譯器並不知道 `@name` 的型別。在這個案例中你可以透過一個 `as` 表達式幫助編譯器：

```crystal
a = [] of Person
x = a.map { |f| f.name as String } # OK
```

這個錯誤並不是很頻繁，而且通常在一個 `Person` 被 map 呼叫以前被實例化後消失：

```crystal
Person.new "John"

a = [] of Person
x = a.map { |f| f.name as String } # OK
```

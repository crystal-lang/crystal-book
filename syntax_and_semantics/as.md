# as

`as` 是一個虛擬方法<small>(Pseudo-method)</small>，能夠限制一個表達式的型別。例如：

```crystal
if some_condition
  a = 1
else
  a = "hello"
end

# a : Int32 | String
```

上述的程式碼中，`a` 的型別是一個 `Int32 | String` 的型別集合。

假定 `a` 在執行 `if` 之後是一個 `Int32`，那麼我們可以強制編譯器將其視為一個 `Int32`：

```crystal
a_as_int = a as Int32
a_as_int.abs          # 可行，編譯器知道 a_as_int 是 Int32
```

`as` 會在執行時期檢查 —— 如果 `a` 並不是一個 `Int32`，那麼將會喚起一個[例外](exception_handling.html)。

這個表達式的參數為一[型別](type_grammar.html)。

另外，不能夠將任一種型別限制為另一種型別，這將在編譯時期發出錯誤：

```crystal
1.as(String) # Compile-time error
```

**注意：** 我們不能使用 `as` 將一個型別轉換為另一個不相關的型別 —— `as` 並不像其他語言裡的 `cast`（轉型）。而在整數、浮點數與字元中有另外提供轉型的方法，或著我們也能照下方說明的指標來轉型。

## 指標之間的轉型

`as` 也允許指標之間的型別轉換：

```crystal
ptr = Pointer(Int32).malloc(1)
ptr.as(Int8*)                    # : Pointer(Int8)
```

在上方的例子中，並沒有進行檢查 —— 指標非常的不安全，而這類型的轉型通常只在 C 語言繫結<small>(Binding)</small>或是更底層的程式碼中才需要。

## 指標型別與其他型別之間的轉換

我們也可以在指標型別與參考型別之間進行轉換，如：

```crystal
array = [1, 2, 3]

# object_id 回傳一個物件在記憶體中的位址，
# 我們可以建立一個指向該位址的指標
ptr = Pointer(Void).new(array.object_id)

# 再來我們就可以把指標轉型為原來的型態，
# 那麼我們應該要得到相同的值
array2 = ptr as Array(Int32)
array2.same?(array) #=> true
```

再次強調，由於指標的關係，上述例子中並不會進行檢查。

這種轉型其實比前一種例子更罕見，但這讓一些 Crystal 裡的核心型別（如字串）得以實作，而且也允許透過轉換為 void 指標後傳遞一個參考型別給 C 函數。

## 轉型為更大的型別

`as` 也可以被用於轉換為*更大的*型別，例如：

```crystal
a = 1
b = a.as(Int32 | Float64)
b # : Int32 | Float64
```

上面的範例看起來可能不是很實用，但卻在對應陣列中的元素時非常好用：

```crystal
ary = [1, 2, 3]

# 我們想要建立一個 Int32 | Float64 的陣列 1, 2, 3
ary2 = ary.map { |x| x as Int32 | Float64 }

ary2 # : Array(Int32 | Float64)
ary2 << 1.5 # OK
```

`Array#map` 這個方法使用了區塊的型別作為陣列的泛型型別。沒有使用 `as` 時，推定的型別將會是 `Int32`，也就表示我們無法增加一個 `Float64` 元素進去。

## 當編譯器無法推斷區塊的型別時

Sometimes the compiler can't infer the type of a block. This can happen in recursive calls that depend on each other. In those cases you can use `as` to let it know the type:

```crystal
some_call { |v| v.method.as(ExpectedType) }
```

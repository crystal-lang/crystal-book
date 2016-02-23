# alias

透過 `alias` （別名）你可以給一個型別不同的名子：

```crystal
alias PInt32 = Pointer(Int32)

ptr = PInt32.malloc(1) # :: Pointer(Int32)
```

每當你使用一次別名時編譯器會將之取代為其所指稱的型別。

別名在避免寫過長的型別名稱時非常方便，同時也能描述遞迴型別。

```crystal
alias RecArray = Array(Int32) | Array(RecArray)

ary = [] of RecArray
ary.push [1, 2, 3]
ary.push ary
ary #=> [[1, 2, 3], [...]]
```

一個真實世界的遞迴型別範例是 json ：

```crystal
module Json
  alias Type = Nil |
               Bool |
               Int64 |
               Float64 |
               String |
               Array(Type) |
               Hash(String, Type)
end
```

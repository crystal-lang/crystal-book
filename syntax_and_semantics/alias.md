# 別名 (alias)

透過 `alias` 我們可以賦予型別一個不同的名子：

```crystal
alias PInt32 = Pointer(Int32)

ptr = PInt32.malloc(1) # : Pointer(Int32)
```

每當別名被使用時，編譯器都將其替換回原來的型別。

使用別名來避免撰寫過長的型別名稱時非常方便，別名也能夠用來描述遞迴型別。

```crystal
alias RecArray = Array(Int32) | Array(RecArray)

ary = [] of RecArray
ary.push [1, 2, 3]
ary.push ary
ary #=> [[1, 2, 3], [...]]
```

Json 是一個常見的遞迴型別範例：

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

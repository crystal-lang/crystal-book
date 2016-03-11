# 作為後綴時

`if` 可以作為表達式的後綴：

```crystal
a = 2 if some_condition

# 上方等價於：
if some_condition
  a = 2
end
```

這樣的寫法有時可增加程式碼的可讀性。

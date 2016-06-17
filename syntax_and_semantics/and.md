# &&

`&&`（且／邏輯與）會檢查左值。若為「真」時，會計算並返回右值；反之則為左值。其型別為兩側型別之型別集合。

我們也可以將 `&&` 視為一個 `if` 的語法糖：

```crystal
some_exp1 && some_exp2

# 上面與此等價：
tmp = some_exp1
if tmp
  some_exp2
else
  tmp
end
```

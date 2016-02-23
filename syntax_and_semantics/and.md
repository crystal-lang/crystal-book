# &&

一個 `&&` （且） 會計算左值。如果值為 *可信的*，他會計算右值並獲得其值，否則會獲得左值。他的型別將會是兩邊的混合型別。

你可以將一個 `&&` 視為一個 `if` 的語法糖：

```crystal
some_exp1 && some_exp2

# 上面與此等價:
tmp = some_exp1
if tmp
  some_exp2
else
  tmp
end
```

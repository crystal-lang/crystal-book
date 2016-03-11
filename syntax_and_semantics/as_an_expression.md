# 作為表達式時

`if` 的回傳值是在各項分支中最後一個發現的表達式的值 :

```crystal
a = if 2 > 1
      3
    else
      4
    end
a #=> 3
```

如果 `if` 的分支是空的，或是缺乏分支，會被視為 `nil` :

```crystal
if 1 > 2
  3
end

# 上方等價於 :
if 1 > 2
  3
else
  nil
end

# 另一個範例 :
if 1 > 2
else
  3
end

# 上方等價於 :
if 1 > 2
  nil
else
  3
end
```

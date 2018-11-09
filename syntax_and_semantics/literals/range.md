# 範圍 <small>Range</small>

通常以下面的常值語法建立一個範圍（[Range](http://crystal-lang.org/api/Range.html)）：

```crystal
x..y  # 建立一個閉區間，在數學上我們用 [x, y] 表示
x...y # 建立一個半開區間，在數學上我們用 [x, y) 表示
x..y  # an inclusive range, in mathematics: [x, y]
x...y # an exclusive range, in mathematics: [x, y)

# 範例：
0..5.to_a # => [0, 1, 2, 3, 4, 5]
0...5.to_a # => [0, 1, 2, 3, 4]
```

一個簡單好記的祕訣就是：*y* 會被多餘的點（`.`）推出去這個範圍，所以他就被排除在外了。

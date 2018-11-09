# 多項賦值

我們可以使用逗號（`,`）來同時進行多項變數的賦值（當然，也包括宣告）：

```crystal
name, age = "Crystal", 1

# 相當於：
temp1 = "Crystal"
temp2 = 1
name  = temp1
age   = temp2
```

我們可以發現在過程中使用了一些變數來暫存這些右值（也就是即將被賦予的值），所以多項賦值也可以用來交換變數的內容：

```crystal
a = 1
b = 2
a, b = b, a
a #=> 2
b #=> 1
```

如果右側只有一個表達式的話，將會套用下面介紹的語法糖：（注意：我們假定右值一定是可索引的型別）

```crystal
name, age, source = "Crystal,1,github".split(",")

# 等同於下面的做法：
temp = "Crystal,1,github".split(",")
name   = temp[0]
age    = temp[1]
source = temp[2]
```

在對於結尾帶有等號的方法上也可以進行多項賦值：

```crystal
person.name, person.age = "John", 32

# 等同於：
temp1 = "John"
temp2 = 32
person.name = temp1
person.age = temp2
```

當然，在索引存取子上（`[]=`）也可以如此應用：

```crystal
objects[1], objects[2] = 3, 4

# 等同於：
temp1 = 3
temp2 = 4
objects[1] = temp1
objects[2] = temp2
```

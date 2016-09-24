# 賦值

使用等號（`=`）來進行賦值。

```crystal
# 賦值給一個區域變數
local = 1

# 賦值給一個實例變數
@instance = 2

# 賦值給一個類別變數
@@class = 3
```

我們會在後面的章節裡解釋上述的各種變數。

這裡也有一些與等號相關的語法糖：

```crystal
local += 1  # 等同於 local = local + 1

# 這些運算子都套用上述的規則：
# +, -, *, /, %, |, &, ^, **, <<, >>

# 這裡還有兩個不太一樣的規則
local ||= 1 # 等同於 local || (local = 1)
local &&= 1 # 等同於 local && (local = 1)
```

對於結尾帶有等號的方法，這裡也有一些語法糖：

```crystal
# Set 存取子 (Setter)
person.name=("John")

# 也可以寫成這樣：
person.name = "John"

# 使用索引的 Set 存取子來賦值
objects.[]=(2, 3)

# 也可以寫成這樣：
objects[2] = 3

# 下面這個並「不是賦值」，但也有類似的語法糖：
objects.[](2, 3)

# 也可以寫成這樣：
objects[2, 3]
```

賦值的語法糖也可以用在 Set 存取子<small>(Setter)</small>與索引子（`[]`）上。另外，`||` 與 `&&` 會使用 `[]?` 方法來確認該索引鍵是否存在。

```crystal
person.age += 1        # 等同於 person.age = person.age + 1

person.name ||= "John" # 等同於 person.name || (person.name = "John")
person.name &&= "John" # 等同於 person.name && (person.name = "John")

objects[1] += 2        # 等同於 objects[1] = objects[1] + 2

objects[1] ||= 2       # 等同於 objects[1]? || (objects[1] = 2)
objects[1] &&= 2       # 等同於 objects[1]? && (objects[1] = 2)
```

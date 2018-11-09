# 常值 <small>Literals</small>

Crystal 中有許多可以用來表達基本型別常值的寫法。

我們會在接下來的子章節裡一一介紹。

| 常值                                      | 舉例                                        |
|---                                        |---                                          |
| [空值 (Nil)](./literals/nil.md)           | `nil`                                       |
| [布林值 (Bool)](./literals/bool.md)       | `true`, `false`                             |
| [整數 (Integers)](./literals/integers.md) | `18`, `-12`, `19_i64`, `14_u32`,`64_u8`     |
| [浮點數 (Floats)](./literals/floats.md)   | `1.0`, `1.0_f32`, `1e10`, `-0.5`            |
| [字元 (Char)](./literals/char.md)         | `'a'`, `'\n'`, `'あ'`                       |
| [字串 (String)](./literals/string.md)     | `"foo\tbar"`, `%("あ")`, `%q(foo #{foo})`   |
| [符號 (Symbol)](./literals/symbol.md)     | `:symbol`, `:"foo bar"`                     |
| [陣列 (Array)](./literals/array.md)       | `[1, 2, 3]`, `[1, 2, 3] of Int32`, `%w(one two three)` |
| [類・陣列 (Array-like)](./literals/array.md#類・陣列array-like型別常值) | `Set{1, 2, 3}`                              |
| [雜湊 (Hash)](./literals/hash.md)         | `{"foo" => 2}`, `{} of String => Int32`     |
| [類・雜湊 (Hash-like)](./literals/hash.md#類・雜湊hash-like型別常值) | `MyType{"foo" => "bar"}`                    |
| [範圍 (Range)](./literals/range.md)       | `1..9`, `1...10`, `0..var`                  |
| [正規表達式 (Regex)](./literals/regex.md) | `/(foo)?bar/`, `/foo #{foo}/imx`, `%r(foo/)` |
| [序組 (Tuple)](./literals/tuple.md)       | `{1, "hello", 'x'}`                         |
| [命名序組 (NamedTuple)](./literals/named_tuple.md) | `{name: "Crystal", year: 2011}`, `{"this is a key": 1}`|
| [程序 (Proc)](./literals/proc.md)         | `->(x : Int32, y : Int32) { x + y }`        |

## 譯註

常值<small>(Literal)</small>，相對於常數<small>(Constant)</small>，僅描述了所代表的值<small>(Value)</small>，有時也會稱為字面常值<small>(Literal constant)</small>。

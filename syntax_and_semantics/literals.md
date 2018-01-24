# Literals

Crystal provides several literals for creating values of some basic types.
 
| Literal                                   | Sample values                               |
|---                                        |---                                          |
| [Nil](./literals/nil.html)                | `nil`                                       |
| [Bool](./literals/bool.html)              | `true`, `false`                             |
| [Integers](./literals/integers.html)      | `18`, `-12`, `19_i64`, `14_u32`,`64_u8`     |
| [Floats](./literals/floats.html)          | `1.0`, `1.0_f32`, `1e10`, `-0.5`            |
| [Char](./literals/char.html)              | `'a'`, `'\n'`, `'あ'`                       |
| [String](./literals/string.html)          | `"foo\tbar"`, `%("あ")`, `%q(foo #{foo})`   |
| [Symbol](./literals/symbol.html)          | `:symbol`, `:"foo bar"`                     |
| [Array](./literals/array.html)            | `[1, 2, 3]`, `[1, 2, 3] of Int32`, `%w(one two three)` |
| [Array-like](./literals/array.html#array-like-type-literal) | `Set{1, 2, 3}`                              |
| [Hash](./literals/hash.html)              | `{"foo" => 2}`, `{} of String => Int32`     |
| [Hash-like](./literals/hash.html#hash-like-type-literal) | `MyType{"foo" => "bar"}`                    |
| [Range](./literals/range.html)            | `1..9`, `1...10`, `0..var`                  |
| [Regex](./literals/regex.html)            | `/(foo)?bar/`, `/foo #{foo}/imx`, `%r(foo/)` |
| [Tuple](./literals/tuple.html)            | `{1, "hello", 'x'}`                         |
| [NamedTuple](./literals/named_tuple.html) | `{name: "Crystal", year: 2011}`, `{"this is a key": 1}`|
| [Proc](./literals/proc.html)              | `->(x : Int32, y : Int32) { x + y }`        |

# Literals

Crystal provides several literals for creating values of some basic types.

| Literal                                                   | Sample values                                           |
|---                                                        |---                                                      |
| [Nil](./literals/nil.md)                                  | `nil`                                                   |
| [Bool](./literals/bool.md)                                | `true`, `false`                                         |
| [Integers](./literals/integers.md)                        | `18`, `-12`, `19_i64`, `14_u32`,`64_u8`                 |
| [Floats](./literals/floats.md)                            | `1.0`, `1.0_f32`, `1e10`, `-0.5`                        |
| [Char](./literals/char.md)                                | `'a'`, `'\n'`, `'あ'`                                   |
| [String](./literals/string.md)                            | `"foo\tbar"`, `%("あ")`, `%q(foo #{foo})`               |
| [Symbol](./literals/symbol.md)                            | `:symbol`, `:"foo bar"`                                 |
| [Array](./literals/array.md)                              | `[1, 2, 3]`, `[1, 2, 3] of Int32`, `%w(one two three)`  |
| [Array-like](./literals/array.md#array-like-type-literal) | `Set{1, 2, 3}`                                          |
| [Hash](./literals/hash.md)                                | `{"foo" => 2}`, `{} of String => Int32`                 |
| [Hash-like](./literals/hash.md#hash-like-type-literal)    | `MyType{"foo" => "bar"}`                                |
| [Range](./literals/range.md)                              | `1..9`, `1...10`, `0..var`                              |
| [Regex](./literals/regex.md)                              | `/(foo)?bar/`, `/foo #{foo}/imx`, `%r(foo/)`            |
| [Tuple](./literals/tuple.md)                              | `{1, "hello", 'x'}`                                     |
| [NamedTuple](./literals/named_tuple.md)                   | `{name: "Crystal", year: 2011}`, `{"this is a key": 1}` |
| [Proc](./literals/proc.md)                                | `->(x : Int32, y : Int32) { x + y }`                    |
| [Command](./literals/command.md)                          | `` `echo foo` ``, `%x(echo foo)`                        |

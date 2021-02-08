# Literals

Crystal provides several literals for creating values of some basic types.

| Literal                                        | Sample values                                           |
|---                                             |---                                                      |
| [Nil](nil.md)                                  | `nil`                                                   |
| [Bool](bool.md)                                | `true`, `false`                                         |
| [Integers](integers.md)                        | `18`, `-12`, `19_i64`, `14_u32`,`64_u8`                 |
| [Floats](floats.md)                            | `1.0`, `1.0_f32`, `1e10`, `-0.5`                        |
| [Char](char.md)                                | `'a'`, `'\n'`, `'あ'`                                   |
| [String](string.md)                            | `"foo\tbar"`, `%("あ")`, `%q(foo #{foo})`               |
| [Symbol](symbol.md)                            | `:symbol`, `:"foo bar"`                                 |
| [Array](array.md)                              | `[1, 2, 3]`, `[1, 2, 3] of Int32`, `%w(one two three)`  |
| [Array-like](array.md#array-like-type-literal) | `Set{1, 2, 3}`                                          |
| [Hash](hash.md)                                | `{"foo" => 2}`, `{} of String => Int32`                 |
| [Hash-like](hash.md#hash-like-type-literal)    | `MyType{"foo" => "bar"}`                                |
| [Range](range.md)                              | `1..9`, `1...10`, `0..var`                              |
| [Regex](regex.md)                              | `/(foo)?bar/`, `/foo #{foo}/imx`, `%r(foo/)`            |
| [Tuple](tuple.md)                              | `{1, "hello", 'x'}`                                     |
| [NamedTuple](named_tuple.md)                   | `{name: "Crystal", year: 2011}`, `{"this is a key": 1}` |
| [Proc](proc.md)                                | `->(x : Int32, y : Int32) { x + y }`                    |
| [Command](command.md)                          | `` `echo foo` ``, `%x(echo foo)`                        |

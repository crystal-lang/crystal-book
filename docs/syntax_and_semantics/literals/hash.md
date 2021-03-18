# Hash

A [Hash](https://crystal-lang.org/api/latest/Hash.html) is a generic collection of key-value pairs mapping keys of type `K` to values of type `V`.

Hashes are typically created with a hash literal denoted by curly braces (`{ }`) enclosing a list of pairs using `=>` as delimiter between key and value and separated by commas `,`.

```crystal
{"one" => 1, "two" => 2}
```

## Generic Type Argument

The generic type arguments for keys `K` and values `V` are inferred from the types of the keys or values inside the literal, respectively. When all have the same type, `K`/`V` equals to that. Otherwise it will be a union of all key types or value types respectively.

```crystal
{1 => 2, 3 => 4}   # Hash(Int32, Int32)
{1 => 2, 'a' => 3} # Hash(Int32 | Char, Int32)
```

Explicit types can be specified by immediately following the closing bracket with `of` (separated by whitespace), a key type (`K`) followed by `=>` as delimiter and a value type (`V`). This overwrites the inferred types and can be used for example to create a hash that holds only some types initially but can accept other types as well.

Empty hash literals always need type specifications:

```crystal
{} of Int32 => Int32 # => Hash(Int32, Int32).new
```

## Hash-like Type Literal

Crystal supports an additional literal for hashes and hash-like types. It consists of the name of the type followed by a list of  comma separated key-value pairs enclosed in curly braces (`{}`).

```crystal
Hash{"one" => 1, "two" => 2}
```

This literal can be used with any type as long as it has an argless constructor and responds to `[]=`.

```crystal
HTTP::Headers{"foo" => "bar"}
```

For a non-generic type like `HTTP::Headers`, this is equivalent to:

```crystal
headers = HTTP::Headers.new
headers["foo"] = "bar"
```

For a generic type, the generic types are inferred from the types of the keys and values in the same way as with the hash literal.

```crystal
MyHash{"foo" => 1, "bar" => "baz"}
```

If `MyHash` is generic, the above is equivalent to this:

```crystal
my_hash = MyHash(typeof("foo", "bar"), typeof(1, "baz")).new
my_hash["foo"] = 1
my_hash["bar"] = "baz"
```

The type arguments can be explicitly specified as part of the type name:

```crystal
MyHash(String, String | Int32){"foo" => "bar"}
```

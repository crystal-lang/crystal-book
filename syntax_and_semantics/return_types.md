# Return types

A method's return type is always inferred by the compiler. However, you might want to specify it for two reasons:

1. To make sure that the method returns the type that you want
2. To make it appear in documentation comments

For example:

```crystal
def some_method : String
  "hello"
end
```

The return type follows the [type grammar](type_grammar.html).

## Nil return type

Marking a method as returning `Nil` will make it return `nil` regardless of what it actually returns:

```crystal
def some_method : Nil
  1 + 2
end

some_method # => nil
```

This is useful for two reasons:

1. Making sure a method returns `nil` without needing to add an extra `nil` at the end, or at every return point
2. Documenting that the method's return value is of no interest

These methods usually imply a side effect.

Using `Void` is the same, but `Nil` is more idiomatic: `Void` is preferred in C bindings.

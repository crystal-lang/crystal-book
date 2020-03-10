---
title: Return types
---

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

## NoReturn return type

Some expressions won't return to the current scope and therefore have no return type. This is expressed as the special return type `NoReturn`.

Typical examples for non-returning methods and keywords are `return`, `exit`, `raise`, `next`, and `break`.

This is for example useful for deconstructing union types:

```
string = STDIN.gets
typeof(string)                        # => String?
typeof(raise "Empty input")           # => NoReturn
typeof(string || raise "Empty input") # => String
```

The compiler recognizes that in case `string` is `Nil`, the right hand side of the expression `string || raise` will be evaluated. Since `typeof(raise "Empty input")` is `NoReturn` the execution would not return to the current scope in that case. That leaves only `String` as resulting type of the expression.

Every expression whose code paths all result in `NoReturn` will be `NoReturn` as well. `NoReturn` does not show up in a union type because it would essentially be included in every expression's type. It is only used when an expression will never return to the current scope.

`NoReturn` can be explicitly set as return type of a method or function definition but will usually be inferred by the compiler.

# Variables

Variables exposed by a C library can be declared inside a `lib` declaration using a global-variable-like declaration:

```crystal
lib C
  $errno : Int32
end
```

Then it can be get and set:

```crystal
C.errno #=> some value
C.errno = 0
C.errno #=> 0
```

A variable can be marked as thread local with an attribute:

```crystal
lib C
  @[ThreadLocal]
  $errno : Int32
end
```

Refer to the [type grammar](../type_grammar.html) for the notation used in external variables types.

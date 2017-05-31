# Hooks

Special macros exist that are invoked in some situations as hooks:
`inherited`, `included`, `extended` and `method_missing`.
* `inherited` is invoked at compile-time when a subclass is defined. `@type` is the inheriting type.
* `included` is invoked at compile-time when a module is included. `@type` is the including type.
* `extended` is invoked at compile-time when a module is extended. `@type` is the extending type.
* `method_missing` is invoked at compile-time when a method is not found.

Example of `inherited`:

```crystal
class Parent
  macro inherited
    def lineage
      "{{@type.name.id}} < Parent"
    end
  end
end

class Child < Parent
end

Child.new.lineage #=> "Child < Parent"
```

Example of `method_missing`:

```crystal
macro method_missing(call)
  print "Got ", {{call.name.id.stringify}}, " with ", {{call.args.size}}, " arguments", '\n'
end

foo          # Prints: Got foo with 0 arguments
bar 'a', 'b' # Prints: Got bar with 2 arguments
```

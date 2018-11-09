# if var

If a variable is the condition of an `if`, inside the `then` branch the variable will be considered as not having the `Nil` type:

```crystal
a = some_condition ? nil : 3
# a is Int32 or Nil

if a
  # Since the only way to get here is if a is truthy,
  # a can't be nil. So here a is Int32.
  a.abs
end
```

This also applies when a variable is assigned in an `if`'s condition:

```crystal
if a = some_expression
  # here a is not nil
end
```

This logic also applies if there are ands (`&&`) in the condition:

```crystal
if a && b
  # here both a and b are guaranteed not to be Nil
end
```

Here, the right-hand side of the `&&` expression is also guaranteed to have `a` as not `Nil`.

Of course, reassigning a variable inside the `then` branch makes that variable have a new type based on the expression assigned.

## Limitations

The above logic **doesn’t** work with instance variables, class variables and variables bound in a closure. The value of these kinds of variables could potentially be affected by another fiber after the condition was checked, rendering it `nil`.

```crystal
if @a
  # here `@a` can be nil
end

if @@a
  # here `@@a` can be nil
end

a = nil
closure = ->(){ a = "foo" }

if a
  # here `a` can be nil
end
```

This can be circumvented by assigning the value to a new local variable:

```crystal
if a = @a
  # here `a` can't be nil
end
```

Another option is to use [`Object#try`](https://crystal-lang.org/api/Object.html#try%28%26block%29-instance-method) found in the standard library which only executes the block if the value is not `nil`:

```crystal
@a.try do |a|
  # here `a` can't be nil
end
```

## Method calls

That logic also doesn't work with proc and method calls, including getters and properties, because nilable (or, more generally, union-typed) procs and methods aren't guaranteed to return the same more-specific type on two successive calls.

```crystal
if method # first call to a method that can return Int32 or Nil
          # here we know that the first call did not return Nil
  method  # second call can still return Int32 or Nil
end
```

The techniques described above for instance variables will also work for proc and method calls.

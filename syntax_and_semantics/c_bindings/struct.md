# struct

A `struct` declaration inside a `lib` declares a C struct.

```crystal
lib C
  # In C:
  #
  #  struct TimeZone {
  #    int minutes_west;
  #    int dst_time;
  #  };
  struct TimeZone
    minutes_west : Int32
    dst_time : Int32
  end
end
```

You can also specify many fields of the same type:

```crystal
lib C
  struct TimeZone
    minutes_west, dst_time : Int32
  end
end
```

Recursive structs work just like you expect them to:

```crystal
lib C
  struct LinkedListNode
    prev, _next : LinkedListNode*
  end

  struct LinkedList
    head : LinkedListNode*
  end
end
```

To create an instance of a struct use `new`:

```crystal
tz = C::TimeZone.new
```

This allocates the struct on the stack.

A C struct starts with all its fields set to "zero": integers and floats start at zero, pointers start with an address of zero, etc.

To avoid this initialization you can use `uninitialized`:

```crystal
tz = uninitialized C::TimeZone
tz.minutes_west # => some garbage value
```

You can set and get its properties:

```crystal
tz = C::TimeZone.new
tz.minutes_west = 1
tz.minutes_west # => 1
```

If the assigned value is not exactly the same as the property's type, [to_unsafe](to_unsafe.html) will be tried.

You can also initialize some fields with a syntax similar to [named arguments](../default_and_named_arguments.html):

```crystal
tz = C::TimeZone.new minutes_west: 1, dst_time: 2
tz.minutes_west # => 1
tz.dst_time     # => 2
```

A C struct is passed by value (as a copy) to functions and methods, and also passed by value when it is returned from a method:

```crystal
def change_it(tz)
  tz.minutes_west = 1
end

tz = C::TimeZone.new
change_it tz
tz.minutes_west # => 0
```

Refer to the [type grammar](../type_grammar.html) for the notation used in struct field types.

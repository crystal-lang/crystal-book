# Module Type Checking

Modules can also be used for type checking.

If we define two modules with names `A` and `B`:

```crystal
module A; end
module B; end
```

These can be included into classes:

```crystal
class One
  include A
end

class Two
  include B
end

class Three
  include A
  include B
end
```

We can then type check against instances of these classes with not only their class, but the
included modules as well:

```crystal
one = One.new
typeof(one)   #=> One
one.is_a?(A)  #=> true
one.is_a?(B)  #=> false

three = Three.new
typeof(three)   #=> Three
three.is_a?(A)  #=> true
three.is_a?(B)  #=> true
```

This allows you to define arrays and methods based on module type instead of class:
```crystal

one = One.new
two = Two.new
three = Three.new

new_array = Array(A).new
new_array << one    #=> Ok, one includes module A
new_array << three  #=> Ok, three includes module A

new_array << two #=> Bad, no overload matches 'Array(A)#<<' with type Two
```

# Generics

Generics allow you to parameterize a type based on other type. Consider a Box type:

```crystal
class MyBox(T)
  def initialize(@value : T)
  end

  def value
    @value
  end
end

int_box = MyBox(Int32).new(1)
int_box.value # => 1 (Int32)

string_box = MyBox(String).new("hello")
string_box.value # => "hello" (String)

another_box = MyBox(String).new(1) # Error, Int32 doesn't match String
```

Generics are especially useful for implementing collection types. `Array`, `Hash`, `Set` are generic types, as is `Pointer`.

More than one type parameter is allowed:

```crystal
class MyDictionary(K, V)
end
```

Any name can be used for type parameters:

```crystal
class MyDictionary(KeyType, ValueType)
end
```

## Generic class methods

Type restrictions in a generic type's class method become free variables when the receiver's type arguments were not specified. Those free variables are then inferred from a call's arguments. For example, one can also write:

```crystal
int_box = MyBox.new(1)          # : MyBox(Int32)
string_box = MyBox.new("hello") # : MyBox(String)
```

In the above code we didn't have to specify the type arguments of `MyBox`, the compiler inferred them following this process:

* The compiler generates a `MyBox.new(value : T)` method, which has no explicitly defined free variables, from `MyBox#initialize(@value : T)`
* The `T` in `MyBox.new(value : T)` isn't bound to a type yet, and `T` is a type parameter of `MyBox`, so the compiler binds it to the type of the given argument
* The compiler-generated `MyBox.new(value : T)` calls `MyBox(T)#initialize(@value : T)`, where `T` is now bound

In this way generic types are less tedious to work with. Note that the `#initialize` method itself does not need to specify any free variables for this to work.

The same type inference also works for class methods other than `.new`:

```crystal
class MyBox(T)
  def self.nilable(x : T)
    MyBox(T?).new(x)
  end
end

MyBox.nilable(1)     # : MyBox(Int32 | Nil)
MyBox.nilable("foo") # : MyBox(String | Nil)
```

In these examples, `T` is only inferred as a free variable, so the `T` of the receiver itself remains unbound. Thus it is an error to call other class methods where `T` cannot be inferred:

```crystal
module Foo(T)
  def self.foo
    T
  end

  def self.foo(x : T)
    foo
  end
end

Foo.foo(1)        # Error: can't infer the type parameter T for the generic module Foo(T). Please provide it explicitly
Foo(Int32).foo(1) # OK
```

## Generic structs and modules

Structs and modules can be generic too. When a module is generic you include it like this:

```crystal
module Moo(T)
  def t
    T
  end
end

class Foo(U)
  include Moo(U)

  def initialize(@value : U)
  end
end

foo = Foo.new(1)
foo.t # Int32
```

Note that in the above example `T` becomes `Int32` because `Foo.new(1)` makes `U` become `Int32`, which in turn makes `T` become `Int32` via the inclusion of the generic module.

## Generic types inheritance

Generic classes and structs can be inherited. When inheriting you can specify an instance of the generic type, or delegate type variables:

```crystal
class Parent(T)
end

class Int32Child < Parent(Int32)
end

class GenericChild(T) < Parent(T)
end
```

## Generics with variable number of arguments

We may define a Generic class with a variable number of arguments using the [splat operator](./operators.md#splats).

Let's see an example where we define a Generic class called `Foo` and then we will use it with different number of type variables:

```crystal-play
class Foo(*T)
  getter content

  def initialize(*@content : *T)
  end
end

# 2 type variables:
# (explicitly specifying type variables)
foo = Foo(Int32, String).new(42, "Life, the Universe, and Everything")

p typeof(foo) # => Foo(Int32, String)
p foo.content # => {42, "Life, the Universe, and Everything"}

# 3 type variables:
# (type variables inferred by the compiler)
bar = Foo.new("Hello", ["Crystal", "!"], 140)
p typeof(bar) # => Foo(String, Array(String), Int32)
```

In the following example we define classes by inheritance, specifying instances for the generic types:

```crystal
class Parent(*T)
end

# We define `StringChild` inheriting from `Parent` class
# using `String` for generic type argument:
class StringChild < Parent(String)
end

# We define `Int32StringChild` inheriting from `Parent` class
# using `Int32` and `String` for generic type arguments:
class Int32StringChild < Parent(Int32, String)
end
```

And if we need to instantiate a `class` with 0 arguments? In that case we may do:

```crystal-play
class Parent(*T)
end

foo = Parent().new
p typeof(foo) # => Parent()
```

But we should not mistake 0 arguments with not specifying the generic type variables. The following examples will raise an error:

```crystal
class Parent(*T)
end

foo = Parent.new # Error: can't infer the type parameter T for the generic class Parent(*T). Please provide it explicitly

class Foo < Parent # Error: generic type arguments must be specified when inheriting Parent(*T)
end
```

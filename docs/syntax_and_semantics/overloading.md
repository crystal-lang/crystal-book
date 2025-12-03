# Overloading

We can define a `become_older` method that accepts a number indicating the years to grow:

```crystal
class Person
  getter :age

  def initialize(@name : String, @age : Int = 0)
  end

  def become_older
    @age += 1
  end

  def become_older(years)
    @age += years
  end
end

john = Person.new "John"
john.age # => 0

john.become_older
john.age # => 1

john.become_older 5
john.age # => 6
```

That is, you can have different methods with the same name and different number of parameters and they will be considered as separate methods. This is called *method overloading*.

Methods overload by several criteria:

* The number of parameters
* The type restrictions applied to parameters
* The names of required named parameters
* Whether the method accepts a [block](blocks_and_procs.md) or not

For example, we can define four different `become_older` methods:

```crystal
class Person
  @age = 0

  # Increases age by one
  def become_older
    @age += 1
  end

  # Increases age by the given number of years
  def become_older(years : Int32)
    @age += years
  end

  # Increases age by the given number of years, as a String
  def become_older(years : String)
    @age += years.to_i
  end

  # Yields the current age of this person and increases
  # its age by the value returned by the block
  def become_older(&)
    @age += yield @age
  end
end

person = Person.new "John"

person.become_older
person.age # => 1

person.become_older 5
person.age # => 6

person.become_older "12"
person.age # => 18

person.become_older do |current_age|
  current_age < 20 ? 10 : 30
end
person.age # => 28
```

Note that in the case of the method that yields, the compiler figured this out because there's a `yield` expression. To make this more explicit, you can add a dummy `&block` parameter at the end:

```crystal
class Person
  @age = 0

  def become_older(&block)
    @age += yield @age
  end
end
```

In generated documentation the dummy `&block` method will always appear, regardless of you writing it or not.

Given the same number of parameters, the compiler will try to sort them by leaving the less restrictive ones to the end:

```crystal
class Person
  @age = 0

  # First, this method is defined
  def become_older(age)
    @age += age
  end

  # Since "String" is more restrictive than no restriction
  # at all, the compiler puts this method before the previous
  # one when considering which overload matches.
  def become_older(age : String)
    @age += age.to_i
  end
end

person = Person.new "John"

# Invokes the first definition
person.become_older 20

# Invokes the second definition
person.become_older "12"
```

However, the compiler cannot always figure out the order because there isn't always a total ordering, so it's always better to put less restrictive methods at the end.

## Caveats

There are some known compiler bugs where overloading order is not as it's supposed to be.
Unfortunately, fixing these bugs would break existing code that relies on this specific, but unintended overload order.
We try to avoid breaking existing code, so it's not easy to roll out the fixes.

### Preview flag

Some bug fixes are already available with the compiler flag `-Dpreview_overload_order` (introduced in Crystal 1.6.0).

Consider using this flag when writing new Crystal code.

It's expected that this flag will be enabled by default in some future version.
At that point, all Crystal code is expected to use the correct overload ordering
and code which still depends on the incorrect ordering can use an opt-out feature flag for a transition period.

### Known bugs

* Overloads without a parameter override ones with a default value ([#10231](https://github.com/
crystal-lang/crystal/issues/10231))

  ```cr
  def bar(x = true)
  end

  def bar
  end

  bar 1 # Error: wrong number of arguments for 'bar' (given 1, expected 0)
  ```

  This issue is fixed with `-Dpreview_overload_order`.

* Overload ordering depends on the definition order of types used in type restrictions ([#7579](https://github.com/crystal-lang/crystal/issues/7579), [#4897](https://github.com/crystal-lang/crystal/issues/4897))

  ```cr
  class Foo
  end

  def foo(a : Bar)
    1
  end

  def foo(a : Foo)
    true
  end

  class Bar < Foo
  end

  foo(Bar.new) # => 1 # This should be true
  ```

  As a workaround, we can move the declaration of `Bar` before of `def foo`.

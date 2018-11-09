# new, initialize and allocate

You create an instance of a class by invoking `new` on that class:

```
person = Person.new
```

Here, `person` is an instance of `Person`.

We can't do much with `person`, so let's add some concepts to it. A `Person` has a name and an age. In the "Everything is an object" section we said that an object has a type and responds to some methods, which is the only way to interact with objects, so we'll need both `name` and `age` methods. We will store this information in instance variables, which are always prefixed with an *at* (`@`) character. We also want a Person to come into existence with a name of our choice and an age of zero. We code the "come into existence" part with a special `initialize` method, which is normally called a *constructor*:

```crystal
class Person
  def initialize(name : String)
    @name = name
    @age = 0
  end

  def name
    @name
  end

  def age
    @age
  end
end
```

Now we can create people like this:

```crystal
john = Person.new "John"
peter = Person.new "Peter"

john.name #=> "John"
john.age #=> 0

peter.name #=> "Peter"
```

(If you wonder why we needed to specify that `name` is a `String` but we didn't need to do it for `age`, check the [global type inference algorithm](type_inference.html))

Note that we create a `Person` with `new` but we defined the initialization in an `initialize` method, not in a `new` method. Why is this so?

The answer is that when we defined an `initialize` method Crystal defined a `new` method for us, like this:

```crystal
class Person
  def self.new(name : String)
    instance = Person.allocate
    instance.initialize(name)
    instance
  end
end
```

First, note the `self.new` notation. This is a [class method](class_methods.md) that belongs to the **class** `Person`, not to particular instances of that class. This is why we can do `Person.new`.

Second, `allocate` is a low-level class method that creates an uninitialized object of the given type. It basically allocates the necessary memory for the object, then `initialize` is invoked on it and finally the instance is returned. You generally never invoke `allocate`, as it is [unsafe](unsafe.html), but that's the reason why `new` and `initialize` are related.


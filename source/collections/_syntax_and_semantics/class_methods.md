---
title: Class methods
---

Class methods are methods associated to a class or module instead of a specific instance.

```crystal
module CaesarCipher
  def self.encrypt(string : String)
    string.chars.map{ |char| ((char.upcase.ord - 52) % 26 + 65).chr }.join
  end
end

CaesarCipher.encrypt("HELLO") # => "URYYB"
```

Class methods are defined by prefixing the method name with the type name and a period.

```crystal
def CaesarCipher.decrypt(string : String)
  encrypt(string)
end
```

When they're defined inside a class or module scope it is easier to use `self` instead of the class name.

Class methods can also be defined by [extending a `Module`](modules.md#extend-self).

A class method can be called under the same name as it was defined (`CaesarCipher.decrypt("HELLO")`).
When called from within the same class or module scope the receiver can be `self` or implicit (like `encrypt(string)`).

# Constructors

Constructors are normal class methods which [create a new instance of the class](new,_initialize_and_allocate.md).
By default all classes in Crystal have at least one constructor called `new`, but they may also define other constructors with different names.

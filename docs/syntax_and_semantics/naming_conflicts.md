# Naming conflicts

Differents namespaces could end up having the same class name which would conflict in some contexts.

For example, in the context of a module, the built-in class `Socket` could conflicts with the custom class `MyNetwork::Socket`.

```crystal
require "socket"

module MyNetwork
  def self.test(addr : String)
    Socket::IPAddress.new(addr, 8080)
  end

  class Socket
    # something else
  end
end

MyNetwork.test("127.0.0.1")
```

Hence, in this context inside `MyNetwork.test`, the programm would think you are trying to call the local `MyNetwork::Socket` class while you are in fact trying to call the top-level `Socket` class. Since `MyNetwork::Socket::IPAddress` doesn't exist, you'll face this error:

```plaintext
Showing last frame. Use --error-trace for full trace.

In test.cr:5:5

 5 | Socket::IPAddress.new(addr, 8080)
     ^----------------
Error: undefined constant Socket::IPAddress
```

Because, in a local context both `MyNetwork::Socket` and `Socket` would call the custom class, you have to call `::Socket` in order to explicitely use the built-in class. The `::` prefix denotes it should use the top level type and not the local scope one.
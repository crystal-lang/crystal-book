# finalize

If a class defines a `finalize` method, when an instance of that class is
garbage-collected that method will be invoked:

```crystal
class Foo
  def finalize
    # Invoked when Foo is garbage-collected
    # Use to release non-managed resources (ie. C libraries, structs)
  end
end
```

Use this method to release resources allocated by external libraries that are
not directly managed by Crystal garbage collector.

Examples of this can be found in [`IO::FileDescriptor#finalize`](https://crystal-lang.org/api/IO/FileDescriptor.html#finalize-instance-method)
or [`OpenSSL::Digest#finalize`](https://crystal-lang.org/api/OpenSSL/Digest.html#finalize-instance-method).

**Notes**:

- The `finalize` method will only be invoked once the object has been
fully initialized via the `initialize` method. If an exception is raised
inside the `initialize` method, `finalize` won't be invoked. If your class
defines a `finalize` method, be sure to catch any exceptions that might be
raised in the `initialize` methods and free resources.

- Allocating any new object instances during garbage-collection might result
in undefined behavior and most likely crashing your program.

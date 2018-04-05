# Static builds

Crystal is able to produce static builds. This is extremely useful for delivering portable, pre-compiled binaries.

The process for producing static builds varies by platform.

For the remainder of this guide, let's assume this is your program:

```crystal
# parser.cr
require "yaml"
puts YAML.parse("hello")
```

## Linux

To produce a static build on a Linux system, all you need to do is compile using the `--static` flag.

    $ crystal build -o parser parser.cr --static --release

## macOS

According to [this link](https://developer.apple.com/library/content/qa/qa1118/_index.html), you won't be able to produce a fully static binary on macOS.

However, you can still ship a pre-compiled binary that will run on macOS, but the process is a bit more complicated.

First, you'll need to compile your app as you normally would:

    $ crystal build -o parser.cr parser

Now, you have a binary. Using the `otool` command, you can see what shared libraries your binary depends on:

    $ otool -L parser
    parser:
        /usr/local/opt/libyaml/lib/libyaml-0.2.dylib (compatibility version 3.0.0, current version 3.5.0)
        /usr/lib/libpcre.0.dylib (compatibility version 1.0.0, current version 1.1.0)
        /usr/local/opt/bdw-gc/lib/libgc.1.dylib (compatibility version 5.0.0, current version 5.2.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1252.0.0)
        /usr/local/opt/libevent/lib/libevent-2.1.6.dylib (compatibility version 7.0.0, current version 7.2.0)
        /usr/lib/libiconv.2.dylib (compatibility version 7.0.0, current version 7.0.0)

We'll need to coerce the linker to prefer static libraries over the dynamic ones that are used above. However, some of these libraries MUST be dynamic.

Static libraries are `.a` files. You'll find them alongside the `dylib` files listed above, but they are also usually symlinked in `/usr/local/lib`. If an `.a` file exists for a given library, then you can statically link it.

Let's create a directory called `static` and copy our `.a` files into it:

    $ mkdir static
    $ cp /usr/local/lib/libyaml.a static
    $ cp /usr/local/lib/libpcre.a static
    $ cp /usr/local/lib/libgc.a static
    $ cp /usr/local/lib/libevent.a static

We'll compile again, but this time, we'll tell the linker to look at our `static` directory:

    $ crystal build -o parser parser.cr --link-flags "-L$(pwd)/static" --release

This time, if you run `otool` on the binary, you'll see fewer results:

    $ otool -L parser
    parser:
      /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1252.0.0)
      /usr/lib/libiconv.2.dylib (compatibility version 7.0.0, current version 7.0.0)

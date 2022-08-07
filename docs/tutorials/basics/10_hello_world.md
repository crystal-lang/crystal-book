# Hello World

The first thing you need to learn in any programming language is the famous [`Hello World!` program](https://en.wikipedia.org/wiki/%22Hello,_World!%22_program).

In Crystal this is pretty simple, maybe a little bit boring:

```crystal-play
puts "Hello World!"
```

> TIP:
> You can build and run code examples interactively in this tutorial by clicking the `Run` button (thanks to [carc.in](https://carc.in)).
> The output is shown directly inline.
>
> If you want to follow along locally, follow the [installation](https://crystal-lang.org/install/) and [getting started](../../getting_started/README.md) instructions.

!!! info inline end
    The name `puts` is short for “put string”.

The entire program consists of a call to the method [`puts`](https://crystal-lang.org/api/toplevel.html#puts%28%2Aobjects%29%3ANil-class-method) with the string `Hello World!` as an argument.

This method prints the string (plus a trailing newline character) to the [standard output](https://en.wikipedia.org/wiki/Standard_output).

All code in the top-level scope is part of the main program. There is no explicit `main` function as [entry point](https://en.wikipedia.org/wiki/Entry_point) to the program.

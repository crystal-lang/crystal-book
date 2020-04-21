# Getting started

Hi and welcome to Crystal's Reference Book!

First we are going to check if we have [installed the language](https://crystal-lang.org/install/) correctly so that we may try all the examples listed in this book.

Once installed, the Crystal compiler should be available as `crystal` command.

Let's try it!

## Crystal version

We may check the Crystal compiler version. If Crystal is installed correctly then we should see something like this:

```terminal-session
$ crystal --version
Crystal 0.33.0 (2020-02-14)

LLVM: 9.0.1
Default target: x86_64-apple-macosx
```

Great!

## Crystal help

Now, if we want to list all the options given by the compiler, we may run `crystal` and that's it:

```terminal-session
$ crystal
Usage: crystal [command] [switches] [program file] [--] [arguments]

Command:
    init                     generate a new project
    build                    build an executable
    docs                     generate documentation
    env                      print Crystal environment information
    eval                     eval code from args or standard input
    play                     starts Crystal playground server
    run (default)            build and run program
    spec                     build and run specs (in spec directory)
    tool                     run a tool
    help, --help, -h         show this help
    version, --version, -v   show version

Run a command followed by --help to see command specific information, ex:
    crystal <command> --help
```

We have a section with some examples about [using the compiler](https://crystal-lang.org/reference/guides/using_the_compiler/README.md).


## Hello Crystal

The following example is the classic Hello World. In Crystal it looks like this:

```crystal
# hello_world.cr

puts "Hello World!"
```

We may run our example like this:

```terminal-session
$ crystal hello_world.cr
Hello World!
```

**Note:** The main routine is simply the program itself. There's no need to define a "main" function or something similar.

Here we have two more examples to continue our first steps in Crystal:
- [HTTP Server](./http_server.md)
- [Command Line Application](./cli.md)

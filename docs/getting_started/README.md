# Getting started

Hi and welcome to Crystal's Reference Book!

First, let's make sure to [install the compiler](https://crystal-lang.org/install/) so that we may try all the examples listed in this book.

Once installed, the Crystal compiler should be available as `crystal` command.

Let's try it!

## Crystal version

We may check the Crystal compiler version. If Crystal is installed correctly then we should see something like this:

```console
$ crystal --version
--8<-- "crystal-version.txt"
```

Great!

## Crystal help

Now, if we want to list all the options given by the compiler, we may run `crystal` program without any arguments:

```console
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

Run a command followed by --help to see command-specific information, ex:
    crystal <command> --help
```

More details about using the compiler can be found on the manpage `man crystal` or in our [compiler manual](../using_the_compiler/README.md).

## Hello Crystal

The following example is the classic Hello World. In Crystal it looks like this:

```crystal title="hello_world.cr"
puts "Hello World!"
```

We may run our example like this:

```console
$ crystal hello_world.cr
Hello World!
```

!!! note
    The main routine is simply the program itself. There's no need to define a "main" function or something similar.

Next you might want to start with the [Introduction Tour](../tutorials/basics/README.md) to get acquainted with the language.

Here we have two more examples to continue our first steps in Crystal:

* [HTTP Server](./http_server.md)
* [Command Line Application](./cli.md)

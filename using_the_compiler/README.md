# Using the compiler

Once you [install](../installation/README.md) the compiler you will have a `crystal` binary at your disposal.

In the next sections a dollar sign (`$`) denotes the command line.

## Compiling and running at once

To compile and run a program in a single shot you can invoke `crystal` with a single filename:

```
$ crystal some_program.cr
```

Crystal files end with the `.cr` extension.

Alternatively you can use the `run` command:

```
$ crystal run some_program.cr
```

## Creating an executable

To create an executable use the `build` command:

```
$ crystal build some_program.cr
```

This will create a `some_program` file that you can execute:

```
$ ./some_program
```

**Note:** By default the generated executables **are not fully optimized**. To turn optimizations on, use the `--release` flag:

```
$ crystal build some_program.cr --release
```

Make sure to always use `--release` for production-ready executables and when performing benchmarks.

The reason for this is that performance without full optimizations is still pretty good and provides fast compile times, so you can use the `crystal` command almost as if it were an interpreter.

To reduce the binary size, you can add the `--no-debug` flag and use the `strip` command. Debug symbols will be removed, use this option if only size is an issue and you won't need to debug the program.

## Creating a statically-linked executable

To build a statically-linked executable of your program:

```
$ crystal build some_program.cr --release --static
```

**Note:** Building statically-linked executables is currently only supported on Alpine Linux.

More information about statically linking [can be found on the wiki](https://github.com/crystal-lang/crystal/wiki/Static-Linking).

## Creating a project or library

Use the `init` command to create a Crystal project with the standard directory structure.

```
$ crystal init lib my_cool_lib
    create  my_cool_lib/.gitignore
    create  my_cool_lib/.editorconfig
    create  my_cool_lib/LICENSE
    create  my_cool_lib/README.md
    create  my_cool_lib/.travis.yml
    create  my_cool_lib/shard.yml
    create  my_cool_lib/src/my_cool_lib.cr
    create  my_cool_lib/spec/spec_helper.cr
    create  my_cool_lib/spec/my_cool_lib_spec.cr
Initialized empty Git repository in ~/my_cool_lib/.git/
```

## Creating documentation

Use the `docs` command to create documentation for your library (see [documenting code](../conventions/documenting_code.html)). By default, this command will create a docs directory, with a `docs/index.html` entry point. All files inside the root `src` directory will be considered (`src/**`). Now you can just open that `index.html` file with your web browser and start browsing your docs.

If your library has any load-order dependence, you can instead specify which file or files should be used as arguments to the `docs` command will create docs for the crystal program resulting from only reading `src/my_app.cr`.

```
$ crystal docs src/my_app.cr
```

There are also two options (which you will see by invoking `crystal docs -h`)

```
--output=DIR, -o DIR             Set the output directory (default: ./docs)
--canonical-base-url=URL, -b URL Set the canonical base url
```

Thus, for the above program, if you need to output the docs at `public` and would like to customize your [canonical base url](https://en.wikipedia.org/wiki/Canonical_link_element) then you could do so like this

```
$ crystal docs -o public -b http://example.com/ src/my_app.cr
```

## Other commands and options

To see the full set of commands, invoke `crystal` without arguments.

```
$ crystal
Usage: crystal [command] [switches] [program file] [--] [arguments]

Command:
    init                     generate a new project
    build                    build an executable
    docs                     generate documentation
    env                      print Crystal environment information
    eval                     eval code from args or standard input
    play                     starts crystal playground server
    run (default)            build and run program
    spec                     build and run specs (in spec directory)
    tool                     run a tool
    help, --help, -h         show this help
    version, --version, -v   show version
```

To see the available options for a particular command, use `--help` after a command:

```
$ crystal build --help
Usage: crystal build [options] [programfile] [--] [arguments]

Options:
    --cross-compile                  cross-compile
    -d, --debug                      Add full symbolic debug info
    --no-debug                       Skip any symbolic debug info
    -D FLAG, --define FLAG           Define a compile-time flag
    --emit [asm|llvm-bc|llvm-ir|obj] Comma separated list of types of output for the compiler to emit
    -f text|json, --format text|json Output format text (default) or json
    --error-trace                    Show full error trace
    -h, --help                       Show this message
    --ll                             Dump ll to Crystal's cache directory
    --link-flags FLAGS               Additional flags to pass to the linker
    --mcpu CPU                       Target specific cpu type
    --mattr CPU                      Target specific features
    --no-color                       Disable colored output
    --no-codegen                     Don't do code generation
    -o                               Output filename
    --prelude                        Use given file as prelude
    --release                        Compile in release mode
    -s, --stats                      Enable statistics output
    -p, --progress                   Enable progress output
    -t, --time                       Enable execution time output
    --single-module                  Generate a single LLVM module
    --threads                        Maximum number of threads to use
    --target TRIPLE                  Target triple
    --verbose                        Display executed commands
    --static                         Link statically
    --stdin-filename                 Source file name to be read from STDIN
```

# Command Line Interface Application

Programming Command Line Interface applications (CLI applications) is one of the most entertaining tasks a developer may do. So let’s have some fun building our first CLI application in Crystal.

There are two main topics when building a CLI application:

* [input](#input)
* [output](#output)

## Input

This topic covers all things related to:

* [options passed to the app](#options)
* [request for user input](#request-for-user-input)

### Options

It is a very common practice to pass options to the application. For example, we may run `crystal -v` and Crystal will display:

```console
$ crystal -v
Crystal 0.31.1 (2019-10-02)

LLVM: 8.0.1
Default target: x86_64-apple-macosx
```

and if we run: `crystal -h`, then Crystal will show all the accepted options and how to use them.

So now the question would be: **do we need to implement an options parser?** No need to, Crystal got us covered with the class `OptionParser`. Let’s build an application using this parser!

At start our CLI application will have two options:

* `-v` / `--version`: it will display the application version.
* `-h` / `--help`: it will display the application help.

```crystal
# file: help.cr
require "option_parser"

OptionParser.parse do |parser|
  parser.banner = "Welcome to The Beatles App!"

  parser.on "-v", "--version", "Show version" do
    puts "version 1.0"
    exit
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
end
```

So, how does all this work? Well … magic! No, it’s not really magic! Just Crystal making our life easy.
When our application starts, the block passed to `OptionParser#parse` gets executed. In that block we define all the options. After the block is executed, the parser will start consuming the arguments passed to the application, trying to match each one with the options defined by us. If an option matches then the block passed to `parser#on` gets executed!

We can read all about `OptionParser` in [the official API documentation](https://crystal-lang.org/api/latest/OptionParser.html). And from there we are one click away from the source code ... the actual proof that it is not magic!

Now, let's run our application. We have two ways [using the compiler](../using_the_compiler/README.md):

1. [Build the application](../using_the_compiler/README.md#crystal-build) and then run it.
2. Compile and [run the application](../using_the_compiler/README.md#crystal-run), all in one command.

We are going to use the second way:

```console
$ crystal run ./help.cr -- -h

Welcome to The Beatles App!
    -v, --version                    Show version
    -h, --help                       Show help
```

Let's build another _fabulous_ application with the following feature:

By default (i.e. no options given) the application will display the names of the Fab Four. But, if we pass the option `-t` / `--twist` it will display the names in uppercase:

```crystal
# file: twist_and_shout.cr
require "option_parser"

the_beatles = [
  "John Lennon",
  "Paul McCartney",
  "George Harrison",
  "Ringo Starr"
]
shout = false

option_parser = OptionParser.parse do |parser|
  parser.banner = "Welcome to The Beatles App!"

  parser.on "-v", "--version", "Show version" do
    puts "version 1.0"
    exit
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
  parser.on "-t", "--twist", "Twist and SHOUT" do
    shout = true
  end
end

members = the_beatles
members = the_beatles.map &.upcase if shout

puts ""
puts "Group members:"
puts "=============="
members.each do |member|
  puts member
end
```

Running the application with the `-t` option will output:

```console
$ crystal run ./twist_and_shout.cr -- -t

Group members:
==============
JOHN LENNON
PAUL MCCARTNEY
GEORGE HARRISON
RINGO STARR
```

#### Parameterized options

Let’s create another application: _when passing the option `-g` / `--goodbye_hello`, the application will say hello to a given name **passed as a parameter to the option**_.

```crystal
# file: hello_goodbye.cr
require "option_parser"

the_beatles = [
  "John Lennon",
  "Paul McCartney",
  "George Harrison",
  "Ringo Starr"
]
say_hi_to = ""

option_parser = OptionParser.parse do |parser|
  parser.banner = "Welcome to The Beatles App!"

  parser.on "-v", "--version", "Show version" do
    puts "version 1.0"
    exit
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
  parser.on "-g NAME", "--goodbye_hello=NAME", "Say hello to whoever you want" do |name|
    say_hi_to = name
  end
end

unless say_hi_to.empty?
  puts ""
  puts "You say goodbye, and #{the_beatles.sample} says hello to #{say_hi_to}!"
end
```

In this case, the block receives a parameter that represents the parameter passed to the option.

Let’s try it!

```console
$ crystal run ./hello_goodbye.cr -- -g "Penny Lane"

You say goodbye, and Ringo Starr say hello to Penny Lane!
```

Great! These applications look awesome! But, **what happens when we pass an option that is not declared?** For example -n

```console
$ crystal run ./hello_goodbye.cr -- -n
Unhandled exception: Invalid option: -n (OptionParser::InvalidOption)
  from ...
```

Oh no! It’s broken: we need to handle **invalid options** and **invalid parameters** given to an option! For these two situations, the `OptionParser` class has two methods: `#invalid_option` and `#missing_option`

So, let's add this option handlers and merge all this CLI applications into one fabulous CLI application!

#### All My CLI: The complete application!

Here’s the final result, with invalid/missing options handling, plus other new options:

```crystal
# file: all_my_cli.cr
require "option_parser"

the_beatles = [
  "John Lennon",
  "Paul McCartney",
  "George Harrison",
  "Ringo Starr"
]
shout = false
say_hi_to = ""
strawberry = false

option_parser = OptionParser.parse do |parser|
  parser.banner = "Welcome to The Beatles App!"

  parser.on "-v", "--version", "Show version" do
    puts "version 1.0"
    exit
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
  parser.on "-t", "--twist", "Twist and SHOUT" do
    shout = true
  end
  parser.on "-g NAME", "--goodbye_hello=NAME", "Say hello to whoever you want" do |name|
    say_hi_to = name
  end
  parser.on "-r", "--random_goodbye_hello", "Say hello to one random member" do
    say_hi_to = the_beatles.sample
  end
  parser.on "-s", "--strawberry", "Strawberry fields forever mode ON" do
    strawberry = true
  end
  parser.missing_option do |option_flag|
    STDERR.puts "ERROR: #{option_flag} is missing something."
    STDERR.puts ""
    STDERR.puts parser
    exit(1)
  end
  parser.invalid_option do |option_flag|
    STDERR.puts "ERROR: #{option_flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

members = the_beatles
members = the_beatles.map &.upcase if shout

puts "Strawberry fields forever mode ON" if strawberry

puts ""
puts "Group members:"
puts "=============="
members.each do |member|
  puts "#{strawberry ? "🍓" : "-"} #{member}"
end

unless say_hi_to.empty?
  puts ""
  puts "You say goodbye, and I say hello to #{say_hi_to}!"
end
```

### Request for user input

Sometimes, we may need the user to input a value. How do we _read_ that value?
Easy, peasy! Let’s create a new application: the Fab Four will sing with us any phrase we want. When running the application, it will request a phrase to the user and the magic will happen!

```crystal
# file: let_it_cli.cr
puts "Welcome to The Beatles Sing Along version 1.0!"
puts "Enter a phrase you want The Beatles to sing"
print "> "
user_input = gets
puts "The Beatles are singing: 🎵#{user_input}🎶🎸🥁"
```

The method [`gets`](https://crystal-lang.org/api/latest/toplevel.html#gets%28*args,**options%29-class-method) will **pause** the execution of the application, until the user finishes entering the input (pressing the `Enter` key).
When the user presses `Enter`, then the execution will continue and `user_input` will have the user value.

But what happen if the user doesn’t enter any value? In that case, we would get an empty string (if the user only presses `Enter`) or maybe a `Nil` value (if the input stream id closed, e.g. by pressing `Ctrl+D`).
To illustrate the problem let’s try the following: we want the input entered by the user to be sang loudly:

```crystal
# file: let_it_cli.cr
puts "Welcome to The Beatles Sing Along version 1.0!"
puts "Enter a phrase you want The Beatles to sing"
print "> "
user_input = gets
puts "The Beatles are singing: 🎵#{user_input.upcase}🎶🎸🥁"
```

When running the example, Crystal will reply:

```console
$ crystal run ./let_it_cli.cr
Showing last frame. Use --error-trace for full trace.

In let_it_cli.cr:5:46

 5 | puts "The Beatles are singing: 🎵#{user_input.upper_case}
                                                  ^---------
Error: undefined method 'upper_case' for Nil (compile-time type is (String | Nil))
```

Ah! We should have known better: the type of the user input is the [union type](https://crystal-lang.org/reference/syntax_and_semantics/type_grammar.html) `String | Nil`.
So, we have to test for `Nil` and for `empty` and act naturally for each case:

```crystal
# file: let_it_cli.cr
puts "Welcome to The Beatles Sing Along version 1.0!"
puts "Enter a phrase you want The Beatles to sing"
print "> "
user_input = gets

exit if user_input.nil? # Ctrl+D

default_lyrics = "Na, na, na, na-na-na na" \
                 " / " \
                 "Na-na-na na, hey Jude"

lyrics = user_input.presence || default_lyrics

puts "The Beatles are singing: 🎵#{lyrics.upcase}🎶🎸🥁"
```

## Output

Now, we will focus on the second main topic: our application’s output.
For starters, our applications already display information but (I think) we could do better. Let’s add more _life_ (i.e. colors!) to the outputs.

And to accomplish this, we will be using the [`Colorize`](https://crystal-lang.org/api/latest/Colorize.html) module.

Let’s build a really simple application that shows a string with colors! We will use yellow font on a black background:

```crystal
# file: yellow_cli.cr
require "colorize"

puts "#{"The Beatles".colorize(:yellow).on(:black)} App"
```

Great! That was easy! Now imagine using this string as the banner for our All My CLI application, it's easy if you try:

```crystal
  parser.banner = "#{"The Beatles".colorize(:yellow).on(:black)} App"
```

For our second application, we will add a *text decoration* (`blink`in this case):

```crystal
# file: let_it_cli.cr
require "colorize"

puts "Welcome to The Beatles Sing Along version 1.0!"
puts "Enter a phrase you want The Beatles to sing"
print "> "
user_input = gets

exit if user_input.nil? # Ctrl+D

default_lyrics = "Na, na, na, na-na-na na" \
                 " / " \
                 "Na-na-na na, hey Jude"

lyrics = user_input.presence || default_lyrics

puts "The Beatles are singing: #{"🎵#{user_input}🎶🎸🥁".colorize.mode(:blink)}"
```

Let’s try the renewed application … and _hear_ the difference!!
**Now** we have two fabulous apps!!

You may find a list of **available colors** and **text decorations** in the [API documentation](https://crystal-lang.org/api/latest/Colorize.html).

## Testing

As with any other application, at some point we would like to [write tests](../guides/testing.md) for the different features.

Right now the code containing the logic of each of the applications always gets executed with the `OptionParser`, i.e. there is no way to include that file without running the whole application. So first we would need to refactor the code, separating the code necessary for parsing options from the logic. Once the refactor is done, we could start testing the logic and including the file with the logic in the testing files we need. We leave this as an exercise for the reader.

## Using `Readline` and `NCurses`

In case we want to build richer CLI applications, there are libraries that can help us. Here we will name two well-known libraries: `Readline` and `NCurses`.

As stated in the documentation for the [GNU Readline Library](http://www.gnu.org/software/readline/), `Readline` is a library that provides a set of functions for use by applications that allow users to edit command lines as they are typed in.
`Readline` has some great features: filename autocompletion out of the box; custom autocompletion method; keybinding, just to mention a few. If we want to try it then the [crystal-lang/crystal-readline](https://github.com/crystal-lang/crystal-readline) shard will give us an easy API to use `Readline`.

On the other hand, we have `NCurses`(New Curses). This library allows developers to create _graphical_ user interfaces in the terminal. As its name implies, it is an improved version of the library named `Curses`, which was developed to support a text-based dungeon-crawling adventure game called Rogue!
As you can imagine, there are already [a couple of shards](https://crystalshards.org/shards/search?q=ncurses) in the ecosystem that will allow us to use `NCurses` in Crystal!

And so we have reached The End 😎🎶

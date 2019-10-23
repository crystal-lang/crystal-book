# Command Line Interfaces

Programming Command Line Interfaces applications (CLI applications) is one of the most entertaining tasks a developer may do. Maybe because it resembles us to the Matrix movie? ... maybe because we may play with ascii art? well … I don’t know … but let’s have some fun building our first CLI application in Crystal.

There are two main topics when building a CLI application:
* [input](#input)
* [output](#output)

## Input
This topic covers all things related to:
* [options passed to the app](#options)
* [request for user input](#request-for-user-input)

### Options
It is a very common practice to pass options to the application. For example, we may run `crystal -v` and Crystal will display:

```bash
$ crystal -v
Crystal 0.31.1 (2019-10-02)

LLVM: 8.0.1
Default target: x86_64-apple-macosx
```

and if we run: `crystal -h`, then Crystal will show all the options and the way to use the different options.

So now the question would be: **do we need to implement an options parser?** No need to, Crystal got us covered with the class `OptionParser`. Let’s build an application using this parser!

To begin, our first CLI application will have two options:
* -v (--version) it will display the application version.
* -h (--help) it will display the application help.

```crystal
# file: all_my_cli.cr
require "option_parser"

OptionParser.parse do |parser|
  parser.banner = "Welcome to The Beatles App!"

  parser.on "-v", "--version", "Please, please show me the version" do
    puts "version 1.0"
    exit
  end
  parser.on "-h", "--help", "Help! I need somebody..." do
    puts parser
    exit
  end
end
```

So, how does all this is working? Well … magic! No, it’s not really magic! Just Crystal making our life easy. When our application starts, the block passed to `OptionParser#parse` gets executed (in that block we define all the options our application will accept). After the block is executed, the parser will start consuming the options passed to the application, trying to match each one with the options defined by us. If an option matches then the block passed to `parser#on` gets executed!
So, for example, if we run our application with the option `-v`, then it should print the version and then exit the application, as defined in the block:

```crystal
  parser.on "-v", "--version", "Please, please show me the version" do
    puts "version 1.0"
    exit
  end
```

We can read all about `OptionParser` in [the official API documentation](https://crystal-lang.org/api/latest/OptionParser.html). And from there we are one click away from the source code ... the actual proof that it is not magic!

Great! That was far from a hard day’s night! But, **How do we run the application?**

We may take two roads:

The first one, is to **build the application**

```bash
$ crystal build all_my_cli.cr
```

Crystal will build our application, and generate the executable file (in our example it will be named `all_my_cli`) Then, we can execute the file passing the options we want. Like this:

```bash
$ ./all_my_cli -v
version 1.0
```

The second ~~Abbey~~ road (okay, that would be the last Beatles reference) is to **compile and run the application** in one command

```bash
$ crystal run ./all_my_cli.cr -- -h
Welcome to The Beatles App!
    -v, --version                    Please, please show me the version
    -h, --help                       Help! I need somebody...
```

**NOTE:** we use `--` to tell Crystal that the following options are to be passed to the application and they are not options for the compiler itself.
**NOTE:** it’s not necessary to explicitly use `run` because it’s the default behaviour.

Now, let’s add new features to this _fabulous_ application! By default (i.e. no options given) the application will display the names of the Fab Four. And if we pass the option `-t` (`--twist`) it will display the uppercased names.

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

option_parser = OptionParser.parse do |parser|
  parser.banner = "Welcome to The Beatles App!"

  parser.on "-v", "--version", "Please, -please- show me the version" do
    puts "version 1.0"
    exit
  end
  parser.on "-h", "--help", "Help! I need somebody..." do
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

Furthermore, we may want to **pass a parameter to an option**. Let’s add a new option to our application: when passing this option, the application will say hello to the given name (passed as a parameter to the option). Here we go:

First we define a new variable:

```crystal
say_hi_to = ""

option_parser = OptionParser.parse do |parser|
  # ... etc
```

Then, we define the new option:

```crystal
option_parser = OptionParser.parse do |parser|
  parser.banner = "Welcome to The Beatles App!"

  parser.on "-g NAME", "--goodbye_hello=NAME", "Say hello to whoever you want" do |name|
    say_hi_to = name
  end

  # ... etc
```

Finally, after listing the group members, we add:

```crystal
members.each do |member|
  puts member
end

if (!say_hi_to.empty?)
  puts "You say goodbye, and I say hello to #{say_hi_to}!"
end
```

In this case, the block receives a parameter that represents the parameter passed to the option.
Let’s try this new option:

```bash
$ crystal ./src/samples/input_option.cr -- -g "Penny Lane"

Group members:
==============
John Lennon
Paul McCartney
George Harrison
Ringo Starr

You say goodbye, and I say hello to Penny Lane!
```

Great! We almost finished our application. But, what happens when we pass an option that is not declared? For example -n

```bash
$ crystal ./src/samples/input_option_banner.cr -- -n
Unhandled exception: Invalid option: -n (OptionParser::InvalidOption)
  from ...
```

Oh no! It’s broken: we need to handle **invalid options** and **invalid parameters** given to an option! For these two situations, the `OptionParser` class has two methods: `invalid_option` and `missing_option`

Here’s the final result (with other new options and invalid/missing options handling):

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

  parser.on "-v", "--version", "Please, please show me the version" do
    puts "version 1.0"
    exit
  end
  parser.on "-h", "--help", "Help! I need somebody..." do
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
    say_hi_to = the_beatles[Random.new.rand(4)]
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

if (!say_hi_to.empty?)
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

The method `gets` will **pause** the execution of the application, until the user finishes entering the input (pressing the `Enter` key)
When the user presses `Enter`, then the execution will continue and `user_input` will have the user value. And if the user doesn’t enter any value? Maybe we would  get an `empty string` (if the user only presses `Enter`) or maybe a `Nil value`(if the user hits Ctrl+D)
Let’s try the following, we want the input entered by the user to be sang loudly:

 ```crystal
# file: let_it_cli.cr
puts "Welcome to The Beatles Sing Along version 1.0!"
puts "Enter a phrase you want The Beatles to sing"
print "> "
user_input = gets
puts "The Beatles are singing: 🎵#{user_input.upcase}🎶🎸🥁"
```

When running the example, Crystal will reply:

```bash
$ crystal ./let_it_cli.cr
Showing last frame. Use --error-trace for full trace.

In let_it_cli.cr:5:46

 5 | puts "The Beatles are singing: 🎵#{user_input.upper_case}
                                                  ^---------
Error: undefined method 'upper_case' for Nil (compile-time type is (String | Nil))
```

Ah! We should have known better: the type of the user input is the [union type](https://crystal-lang.org/reference/syntax_and_semantics/type_grammar.html) `String | Nil`.
So, we have to test for `Nil`, and for `empty` and act naturally for each case:

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

lyrics = user_input.presence? || default_lyrics

puts "The Beatles are singing: 🎵#{lyrics.upcase}🎶🎸🥁"
```

## Output

Now, we will focus on the second main topic: our application’s output.
For starters, our applications already display information but (I think) we could do better. Let’s add more _life_ (i.e. colors!) to the outputs.

And to accomplish this, we will be using the `Colorize` module.

Let’s focus on our first application. We will add colors to the application’s banner. We will use white font on a black background:

```crystal
app_banner = "#{"The Beatles".colorize(:white).on(:black)} App"
```

Great! That was easy!

And for our second application, we will add a text decoration (`blink`in this case):

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

lyrics = user_input.presence? || default_lyrics

puts "The Beatles are singing: #{"🎵#{user_input}🎶🎸🥁".colorize.mode(:blink)}"
```

Let’s try the renewed application … and _hear_ the difference!!

And **now** we have two fabulous apps!!

You may read more about the `Colorize` module  [in the official API documentation](https://crystal-lang.org/api/latest/Colorize.html) and find a list of available colors and text decorations.

## Testing

As with any other application, at some point we would like to [write tests](https://crystal-lang.org/reference/guides/testing.html) for the different features.

Right now the code containing the logic of each of the applications always gets executed with the `OptionParser`, i.e. there is no way to include that file without running the whole application. So first we would need to refactor the code, separating the code necessary for parsing options from the logic. Ones the refactor is done, then we could start testing the logic, and so including the file with the logic in the testing files we need. We leave this as an exercise for the reader.

## Using `Readline` and `NCurses`

In case we want to build richer CLI applications, there are libraries that can help us. Here we will name two well-known libraries: `Readline` and` NCurses`.

As stated in the documentation for the [GNU Readline Library](http://www.gnu.org/software/readline/), `Readline` is a library that provides a set of functions for use by applications that allow users to edit command lines as they are typed in.
`Readline` has some great features: filename autocompletion out of the box; custom autocompletion method; keybinding, just to mention a few. If we want to try it then the [crystal-lang/crystal-readline](https://github.com/crystal-lang/crystal-readline) shard will give us an easy API to use `Readline`.

On the other hand, we have `NCurses`(New Curses). This library allows developers to create _graphical_ user interfaces in the terminal. As its name implies, it is an improved version of the library named `Curses`, which was developed to support a text-based dungeon-crawling adventure game called Rogue!
As you can imagine, there are already a couple of shards in the ecosystem that will allow us to use `NCurses` in Crystal!

And so we have reached The End 😎🎶

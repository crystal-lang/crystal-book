# Command literal

A command literal is a string delimited by backticks `` ` `` or a `%x` percent literal.
It will be substituted at runtime by the captured output from executing the string in a subshell.

The same [escaping](./string.md#escaping) and [interpolation rules](./string.md#interpolation) apply as for regular strings.

Similar to percent string literals, valid delimiters for `%x` are parentheses `()`, square brackets `[]`, curly braces `{}`, angles `<>` and pipes `||`. Except for the pipes, all delimiters can be nested; meaning a start delimiter inside the string escapes the next end delimiter.

The special variable `$?` holds the exit status of the command as a [`Process::Status`](https://crystal-lang.org/api/latest/Process/Status.html). It is only available in the same scope as the command literal.

```crystal
`echo foo`  # => "foo"
$?.success? # => true
```

Internally, the compiler rewrites command literals to calls to the top-level method [`` `()``](https://crystal-lang.org/api/latest/toplevel.html#%60(command):String-class-method) with a string literal containing the command as argument: `` `echo #{argument}` `` and `%x(echo #{argument})` are rewritten to `` `("echo #{argument}")``.

## Security concerns

While command literals may prove useful for simple script-like tools, special caution is advised when interpolating user input because it may easily lead to command injection.

```crystal
user_input = "hello; rm -rf *"
`echo #{user_input}`
```

This command will write `hello` and subsequently delete all files and folders in the current working directory.

To avoid this, command literals should generally not be used with interpolated user input. [`Process`](https://crystal-lang.org/api/latest/Process.html) from the standard library offers a safe way to provide user input as command arguments:

```crystal
user_input = "hello; rm -rf *"
process = Process.new("echo", [user_input], output: Process::Redirect::Pipe)
process.output.gets_to_end # => "hello; rm -rf *"
process.wait.success?      # => true
```

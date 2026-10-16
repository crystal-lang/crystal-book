# Local variables

Local variables are declared when you first assign them a value.

The name always starts with a lowercase [Unicode](https://en.wikipedia.org/wiki/Unicode) letter,
or an underscore, but that's reserved for special use cases such as indicating that the value is unused.
The following characters are Unicode alphanumeric or underscores.

As a typical convention, upper-case letters are avoided and names are written in [`snake_case`](https://en.wikipedia.org/wiki/Snake_case).

```crystal
name = "Crystal"
age = 1
```

Their type is inferred from their usage, not only from their initializer. In general, they are just value holders associated with the type that the programmer expects them to have according to their location and usage on the program.

For example, reassigning a variable with a different expression makes it have that expression’s type:

```crystal
flower = "Tulip"
# At this point 'flower' is a String

flower = 1
# At this point 'flower' is an Int32
```

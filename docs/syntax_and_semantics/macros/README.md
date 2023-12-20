# Macros

Macros are methods that receive AST nodes at compile-time and produce
code that is pasted into a program. For example:

```crystal
macro define_method(name, content)
  def {{name}}
    {{content}}
  end
end

# This generates:
#
#     def foo
#       1
#     end
define_method foo, 1

foo # => 1
```

A macro's definition body looks like regular Crystal code with extra syntax to manipulate the AST nodes. The generated code must be valid Crystal code, meaning that you can't for example generate a `def` without a matching `end`, or a single `when` expression of a `case`, since both of them are not complete valid expressions. Refer to [Pitfalls](#pitfalls) for more information.

## Scope

Macros declared at the top-level are visible anywhere. If a top-level macro is marked as `private` it is only accessible in that file.

They can also be defined in classes and modules, and are visible in those scopes. Macros are also looked-up in the ancestors chain (superclasses and included modules).

For example, a block which is given an object to use as the default receiver by being invoked with `with ... yield` can access macros defined within that object's ancestors chain:

```crystal
class Foo
  macro emphasize(value)
    "***#{ {{value}} }***"
  end

  def yield_with_self(&)
    with self yield
  end
end

Foo.new.yield_with_self { emphasize(10) } # => "***10***"
```

Macros defined in classes and modules can be invoked from outside of them too:

```crystal
class Foo
  macro emphasize(value)
    "***#{ {{value}} }***"
  end
end

Foo.emphasize(10) # => "***10***"
```

## Interpolation

You use `{{...}}` to paste, or interpolate, an AST node, as in the above example.

Note that the node is pasted as-is. If in the previous example we pass a symbol, the generated code becomes invalid:

```crystal
# This generates:
#
#     def :foo
#       1
#     end
define_method :foo, 1
```

Note that `:foo` was the result of the interpolation, because that's what was passed to the macro. You can use the method [`ASTNode#id`](https://crystal-lang.org/api/Crystal/Macros/ASTNode.html#id%3AMacroId-instance-method) in these cases, where you just need an identifier.

## Macro calls

You can invoke a **fixed subset** of methods on AST nodes at compile-time. These methods are documented in a fictitious [Crystal::Macros](https://crystal-lang.org/api/Crystal/Macros.html) module.

For example, invoking [`ASTNode#id`](https://crystal-lang.org/api/Crystal/Macros/ASTNode.html#id%3AMacroId-instance-method) in the above example solves the problem:

```crystal
macro define_method(name, content)
  def {{name.id}}
    {{content}}
  end
end

# This correctly generates:
#
#     def foo
#       1
#     end
define_method :foo, 1
```

### parse_type

Most AST nodes are obtained via either manually passed arguments, hard coded values, or retrieved from either the [type](#type-information) or [method](#method-information) information helper variables. Yet there might be cases in which a node is not directly accessible, such as if you use information from different contexts to construct the path to the desired type/constant.

In such cases the [`parse_type`](https://crystal-lang.org/api/Crystal/Macros.html#parse_type%28type_name%3AStringLiteral%29%3APath%7CGeneric%7CProcNotation%7CMetaclass-instance-method) macro method can help by parsing the provided [`StringLiteral`](https://crystal-lang.org/api/Crystal/Macros/StringLiteral.html) into something that can be resolved into the desired AST node.

```crystal
MY_CONST = 1234

struct Some::Namespace::Foo; end

{{ parse_type("Some::Namespace::Foo").resolve.struct? }} # => true
{{ parse_type("MY_CONST").resolve }}                     # => 1234

{{ parse_type("MissingType").resolve }} # Error: undefined constant MissingType
```

See the API docs for more examples.

## Modules and classes

Modules, classes and structs can also be generated:

```crystal
macro define_class(module_name, class_name, method, content)
  module {{module_name}}
    class {{class_name}}
      def initialize(@name : String)
      end

      def {{method}}
        {{content}} + @name
      end
    end
  end
end

# This generates:
#     module Foo
#       class Bar
#         def initialize(@name : String)
#         end
#
#         def say
#           "hi " + @name
#         end
#       end
#     end
define_class Foo, Bar, say, "hi "

p Foo::Bar.new("John").say # => "hi John"
```

## Conditionals

You use `{% if condition %}` ... `{% end %}` to conditionally generate code:

```crystal
macro define_method(name, content)
  def {{name}}
    {% if content == 1 %}
      "one"
    {% elsif content == 2 %}
      "two"
    {% else %}
      {{content}}
    {% end %}
  end
end

define_method foo, 1
define_method bar, 2
define_method baz, 3

foo # => one
bar # => two
baz # => 3
```

Similar to regular code, [`Nop`](https://crystal-lang.org/api/Crystal/Macros/Nop.html), [`NilLiteral`](https://crystal-lang.org/api/Crystal/Macros/NilLiteral.html) and a false [`BoolLiteral`](https://crystal-lang.org/api/Crystal/Macros/BoolLiteral.html) are considered *falsey*, while everything else is considered *truthy*.

Macro conditionals can be used outside a macro definition:

```crystal
{% if env("TEST") %}
  puts "We are in test mode"
{% end %}
```

## Iteration

You can iterate a finite amount of times:

```crystal
macro define_constants(count)
  {% for i in (1..count) %}
    PI_{{i.id}} = Math::PI * {{i}}
  {% end %}
end

define_constants(3)

PI_1 # => 3.14159...
PI_2 # => 6.28318...
PI_3 # => 9.42477...
```

To iterate an [`ArrayLiteral`](https://crystal-lang.org/api/Crystal/Macros/ArrayLiteral.html):

```crystal
macro define_dummy_methods(names)
  {% for name, index in names %}
    def {{name.id}}
      {{index}}
    end
  {% end %}
end

define_dummy_methods [foo, bar, baz]

foo # => 0
bar # => 1
baz # => 2
```

The `index` variable in the above example is optional.

To iterate a [`HashLiteral`](https://crystal-lang.org/api/Crystal/Macros/HashLiteral.html):

```crystal
macro define_dummy_methods(hash)
  {% for key, value in hash %}
    def {{key.id}}
      {{value}}
    end
  {% end %}
end

define_dummy_methods({foo: 10, bar: 20})
foo # => 10
bar # => 20
```

Macro iterations can be used outside a macro definition:

```crystal
{% for name, index in ["foo", "bar", "baz"] %}
  def {{name.id}}
    {{index}}
  end
{% end %}

foo # => 0
bar # => 1
baz # => 2
```

## Variadic arguments and splatting

A macro can accept variadic arguments:

```crystal
macro define_dummy_methods(*names)
  {% for name, index in names %}
    def {{name.id}}
      {{index}}
    end
  {% end %}
end

define_dummy_methods foo, bar, baz

foo # => 0
bar # => 1
baz # => 2
```

The arguments are packed into a [`TupleLiteral`](https://crystal-lang.org/api/Crystal/Macros/TupleLiteral.html) and passed to the macro.

Additionally, using `*` when interpolating a [`TupleLiteral`](https://crystal-lang.org/api/Crystal/Macros/TupleLiteral.html) interpolates the elements separated by commas:

```crystal
macro println(*values)
  print {{*values}}, '\n'
end

println 1, 2, 3 # outputs 123\n
```

## Type information

When a macro is invoked you can access the current scope, or type, with a special instance variable: `@type`. The type of this variable is [`TypeNode`](https://crystal-lang.org/api/Crystal/Macros/TypeNode.html), which gives you access to type information at compile time.

Note that `@type` is always the *instance* type, even when the macro is invoked in a class method.

For example:

```crystal
macro add_describe_methods
  def describe
    "Class is: " + {{ @type.stringify }}
  end

  def self.describe
    "Class is: " + {{ @type.stringify }}
  end
end

class Foo
  add_describe_methods
end

Foo.new.describe # => "Class is Foo"
Foo.describe     # => "Class is Foo"
```

## The top level module

It is possible to access the top-level namespace, as a [`TypeNode`](https://crystal-lang.org/api/Crystal/Macros/TypeNode.html), with a special variable: `@top_level`. The following example shows its utility:

```crystal
A_CONSTANT = 0

{% if @top_level.has_constant?("A_CONSTANT") %}
  puts "this is printed"
{% else %}
  puts "this is not printed"
{% end %}
```

## Method information

When a macro is invoked you can access the method, the macro is in with a special instance variable: `@def`. The type of this variable is [`Def`](https://crystal-lang.org/api/Crystal/Macros/Def.html) unless the macro is outside of a method, in this case it's [`NilLiteral`](https://crystal-lang.org/api/Crystal/Macros/NilLiteral.html).

Example:

```crystal
module Foo
  def Foo.boo(arg1, arg2)
    {% @def.receiver %} # => Foo
    {% @def.name %}     # => boo
    {% @def.args %}     # => [arg1, arg2]
  end
end

Foo.boo(0, 1)
```

## Call Information

When a macro is called, you can access the macro call stack with a special instance variable: `@caller`.
This variable returns an `ArrayLiteral` of [`Call`](https://crystal-lang.org/api/Crystal/Macros/Call.html) nodes with the first element in the array being the most recent,
unless it is called outside of a macro in which case it's a [`NilLiteral`](https://crystal-lang.org/api/Crystal/Macros/NilLiteral.html).

NOTE: As of now, the returned array will always only have a single element.

Example:

```crystal
macro foo
  {{ @caller.first.line_number }}
end

def bar
  {{ @caller }}
end

foo # => 9
bar # => nil
```

## Constants

Macros can access constants. For example:

```crystal
VALUES = [1, 2, 3]

{% for value in VALUES %}
  puts {{value}}
{% end %}
```

If the constant denotes a type, you get back a [`TypeNode`](https://crystal-lang.org/api/Crystal/Macros/TypeNode.html).

## Nested macros

It is possible to define a macro which generates one or more macro definitions. You must escape macro expressions of the inner macro by preceding them with a backslash character "\\" to prevent them from being evaluated by the outer macro.

```crystal
macro define_macros(*names)
  {% for name in names %}
    macro greeting_for_{{name.id}}(greeting)
      \{% if greeting == "hola" %}
        "¡hola {{name.id}}!"
      \{% else %}
        "\{{greeting.id}} {{name.id}}"
      \{% end %}
    end
  {% end %}
end

# This generates:
#
#     macro greeting_for_alice(greeting)
#       {% if greeting == "hola" %}
#         "¡hola alice!"
#       {% else %}
#         "{{greeting.id}} alice"
#       {% end %}
#     end
#     macro greeting_for_bob(greeting)
#       {% if greeting == "hola" %}
#         "¡hola bob!"
#       {% else %}
#         "{{greeting.id}} bob"
#       {% end %}
#     end
define_macros alice, bob

greeting_for_alice "hello" # => "hello alice"
greeting_for_bob "hallo"   # => "hallo bob"
greeting_for_alice "hej"   # => "hej alice"
greeting_for_bob "hola"    # => "¡hola bob!"
```

### verbatim

Another way to define a nested macro is by using the special `verbatim` call. Using this you will not be able to use any variable interpolation but will not need to escape the inner macro characters.

```crystal
macro define_macros(*names)
  {% for name in names %}
    macro greeting_for_{{name.id}}(greeting)

      # name will not be available within the verbatim block
      \{% name = {{name.stringify}} %}

      {% verbatim do %}
        {% if greeting == "hola" %}
          "¡hola {{name.id}}!"
        {% else %}
          "{{greeting.id}} {{name.id}}"
        {% end %}
      {% end %}
    end
  {% end %}
end

# This generates:
#
#     macro greeting_for_alice(greeting)
#       {% name = "alice" %}
#       {% if greeting == "hola" %}
#         "¡hola {{name.id}}!"
#       {% else %}
#         "{{greeting.id}} {{name.id}}"
#       {% end %}
#     end
#     macro greeting_for_bob(greeting)
#       {% name = "bob" %}
#       {% if greeting == "hola" %}
#         "¡hola {{name.id}}!"
#       {% else %}
#         "{{greeting.id}} {{name.id}}"
#       {% end %}
#     end
define_macros alice, bob

greeting_for_alice "hello" # => "hello alice"
greeting_for_bob "hallo"   # => "hallo bob"
greeting_for_alice "hej"   # => "hej alice"
greeting_for_bob "hola"    # => "¡hola bob!"
```

Notice the variables in the inner macro are not available within the `verbatim` block. The contents of the block are transferred "as is", essentially as a string, until re-examined by the compiler.

## Comments

Macro expressions are evaluated both within comments as well as compatible sections of code. This may be used to provide relevant documentation for expansions:

```crystal
{% for name, index in ["foo", "bar", "baz"] %}
  # Provides a placeholder {{name.id}} method. Always returns {{index}}.
  def {{name.id}}
    {{index}}
  end
{% end %}
```

This evaluation applies to both interpolation and directives. As a result of this, macros cannot be commented out.

```crystal
macro a
  # {% if false %}
  puts 42
  # {% end %}
end

a
```

The expression above will result in no output.

### Merging Expansion and Call Comments

The [`@caller`](./#call-information) can be combined with the [`#doc_comment`](https://crystal-lang.org/api/Crystal/Macros/ASTNode.html#doc_comment%3AMacroId-instance-method) method in order to allow merging documentation comments on a node generated by a macro, and the comments on the macro call itself. For example:

```crystal
macro gen_method(name)
 # {{ @caller.first.doc_comment }}
 #
 # Comment added via macro expansion.
 def {{name.id}}
 end
end

# Comment on macro call.
gen_method foo
```

When generated, the docs for the `#foo` method would be like:

```text
# Comment on macro call.
#
# Comment added via macro expansion.
```

## Pitfalls

When writing macros (especially outside of a macro definition) it is important to remember that the generated code from the macro must be valid Crystal code by itself even before it is merged into the main program's code. This means, for example, a macro cannot generate a one or more `when` expressions of a `case` statement unless `case` was a part of the generated code.

Here is an example of such an invalid macro:

```{.crystal nocheck}
case 42
{% for klass in [Int32, String] %} # Syntax Error: unexpected token: {% (expecting when, else or end)
  when {{klass.id}}
    p "is {{klass}}"
{% end %}
end
```

Notice that `case` is not within the macro. The code generated by the macro consists solely of two `when` expressions which, by themselves, is not valid Crystal code. We must include `case` within the macro in order to make it valid by using `begin` and `end`:

```crystal
{% begin %}
  case 42
  {% for klass in [Int32, String] %}
    when {{klass.id}}
      p "is {{klass}}"
  {% end %}
  end
{% end %}
```

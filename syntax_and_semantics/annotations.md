# Annotations

Annotations can be used to add metadata to certain features in the source code. Types, methods and instance variables may be annotated.  User-defined annotations, such as the standard library's [JSON::Field](https://crystal-lang.org/api/JSON/Field.html), are defined using the `annotation` keyword.  A number of [built-in annotations](./annotations/built_in_annotations.md) are provided by the compiler.

Users can define their own annotations using the `annotation` keyword, which works similarly to defining a `class` or `struct`.

```crystal
annotation MyAnnotation
end
```

The annotation can then be applied to various items, including:
* Instance and class methods
* Instance variables
* Classes, structs, enums, and modules

```crystal
annotation MyAnnotation
end

@[MyAnnotation]
def foo
  "foo"
end

@[MyAnnotation]
class Klass
end

@[MyAnnotation]
module MyModule
end
```

## Applications

Annotations are best used to store metadata about a given instance variable, type, or method so that it can be read at compile time using macros.  One of the main benefits of annotations is that they are applied directly to instance variables/methods, which causes classes to look more natural since a standard macro is not needed to create these properties/methods.

A few applications for annotations:

### Object Serialization

Have an annotation that when applied to an instance variable determines if that instance variable should be serialized, or with what key. Crystal's [`JSON::Serializable`](https://crystal-lang.org/api/JSON/Serializable.html) and [`YAML::Serializable`](https://crystal-lang.org/api/YAML/Serializable.html) are examples of this.

### ORMs

An annotation could be used to designate a property as an ORM column. The name and type of the instance variable can be read off the `TypeNode` in addition to the annotation; removing the need for any ORM specific macro. The annotation itself could also be used to store metadata about the column, such as if it is nullable, the name of the column, or if it is the primary key.

## Fields

Data can be stored within an annotation.

```crystal
annotation MyAnnotaion
end

# The fields can either be a key/value pair
@[MyAnnotation(key: "value", value: 123)]

# Or positional
@[MyAnnotation("foo", 123, false)]
```

### Key/value

The values of annotation key/value pairs can be accessed at compile time via the [`[]`](https://crystal-lang.org/api/Crystal/Macros/Annotation.html#%5B%5D%28name%3ASymbolLiteral%7CStringLiteral%7CMacroId%29%3AASTNode-instance-method) method.

```crystal
annotation MyAnnotation
end

@[MyAnnotation(value: 2)]
def annotation_value
  # The name can be a `String`, `Symbol`, or `MacroId`
  {{ @def.annotation(MyAnnotation)[:value] }}
end

annotation_value # => 2
```

The `named_args` method can be used to read all key/value pairs on an annotation as a `NamedTupleLiteral`.  This method is defined on all annotations by default, and is unique to each applied annotation.

```crystal
annotation MyAnnotation
end

@[MyAnnotation(value: 2, name: "Jim")]
def annotation_named_args
  {{ @def.annotation(MyAnnotation).named_args }}
end

annotation_named_args # => {value: 2, name: "Jim"}
```

Since this method returns a `NamedTupleLiteral`, all of the [methods](https://crystal-lang.org/api/Crystal/Macros/NamedTupleLiteral.html) on that type are available for use.  Especially `#double_splat` which makes it easy to pass annotation arguments to methods.

```crystal
annotation MyAnnotation
end

class SomeClass
  def initialize(@value : Int32, @name : String); end
end

@[MyAnnotation(value: 2, name: "Jim")]
def new_test
  {% begin %}
    SomeClass.new {{ @def.annotation(MyAnnotation).named_args.double_splat }}
  {% end %}
end

new_test # => #<SomeClass:0x5621a19ddf00 @name="Jim", @value=2>
```

### Positional

Positional values can be accessed at compile time via the [`[]`](<https://crystal-lang.org/api/Crystal/Macros/Annotation.html#%5B%5D%28index%3ANumberLiteral%29%3AASTNode-instance-method>) method; however, only one index can be accessed at a time.

```crystal
annotation MyAnnotation
end

@[MyAnnotation(1, 2, 3, 4)]
def annotation_read
  {% for idx in [0, 1, 2, 3, 4] %}
    {% value = @def.annotation(MyAnnotation)[idx] %}
    pp "{{ idx }} = {{ value }}"
  {% end %}
end

annotation_read

# Which would print
"0 = 1"
"1 = 2"
"2 = 3"
"3 = 4"
"4 = nil"
```

The `args` method can be used to read all positional arguments on an annotation as a `TupleLiteral`.  This method is defined on all annotations by default, and is unique to each applied annotation.

```crystal
annotation MyAnnotation
end

@[MyAnnotation(1, 2, 3, 4)]
def annotation_args
  {{ @def.annotation(MyAnnotation).args }}
end

annotation_args # => {1, 2, 3, 4}
```

Since the return type of `TupleLiteral` is iterable, we can rewrite the previous example in a better way.  By extension, all of the [methods](https://crystal-lang.org/api/Crystal/Macros/TupleLiteral.html) on `TupleLiteral` are available for use as well.

```crystal
annotation MyAnnotation
end

@[MyAnnotation(1, "foo", true, 17.0)]
def annotation_read
  {% for value, idx in @def.annotation(MyAnnotation).args %}
    pp "{{ idx }} = #{{{ value }}}"
  {% end %}
end

annotation_read

# Which would print
"0 = 1"
"1 = foo"
"2 = true"
"3 = 17.0"
```

## Reading

Annotations can be read off of a [`TypeNode`](https://crystal-lang.org/api/Crystal/Macros/TypeNode.html), [`Def`](https://crystal-lang.org/api/Crystal/Macros/Def.html), or [`MetaVar`](https://crystal-lang.org/api/Crystal/Macros/MetaVar.html) using the `.annotation(type : TypeNode)` method.  This method return an [`Annotation`](https://crystal-lang.org/api/master/Crystal/Macros/Annotation.html) object representing the applied annotation of the supplied type.

**NOTE:** If multiple annotations of the same type are applied, the `.annotation` method will return the _last_ one.

The [`@type`](./macros.md#type-information) and [`@def`](./macros.md#method-information) variables can be used to get a `TypeNode` or `Def` object to use the `.annotation` method on.  However, it is also possible to get `TypeNode`/`Def` types using other methods on `TypeNode`.  For example `TypeNode.all_subclasses` or `TypeNode.methods`, respectively.

The `TypeNode.instance_vars` can be used to get an array of instance variable `MetaVar` objects that would allow reading annotations defined on those instance variables.

**NOTE:** `TypeNode.instance_vars` currently only works in the context of an instance/class method.

```crystal
annotation MyClass
end

annotation MyMethod
end

annotation MyIvar
end

@[MyClass]
class Foo
  pp {{ @type.annotation(MyClass).stringify }}

  @[MyIvar]
  @num : Int32 = 1

  @[MyIvar]
  property name : String = "jim"

  def properties
    {% for ivar in @type.instance_vars %}
      pp {{ ivar.annotation(MyIvar).stringify }}
    {% end %}
  end
end

@[MyMethod]
def my_method
  pp {{ @def.annotation(MyMethod).stringify }}
end

Foo.new.properties
my_method
pp {{ Foo.annotation(MyClass).stringify }}

# Which would print
"@[MyClass]"
"@[MyIvar]"
"@[MyIvar]"
"@[MyMethod]"
"@[MyClass]"
```

### Reading Multiple Annotations

If there are multiple annotations of the same type applied to the same instance variable/method/type, the `.annotations(type : TypeNode)` method can be used.  This will work on anything that `.annotation(type : TypeNode)` would, but instead returns an `ArrayLiteral(Annotation)`.

```crystal
annotation MyAnnotation
end

@[MyAnnotation("foo")]
@[MyAnnotation(123)]
@[MyAnnotation(123)]
def annotation_read
  {% for ann, idx in @def.annotations(MyAnnotation) %}
    pp "Annotation {{ idx }} = {{ ann[0].id }}"
  {% end %}
end

annotation_read

# Which would print
"Annotation 0 = foo"
"Annotation 1 = 123"
"Annotation 2 = 123"
```

# User Defined Annotations

Users can define their own annotations using the `annotation` keyword, which works similarly to defining `class` or `sruct`.

```crystal
annotation MyAnnotation; end
```

The annotation can then be applied to various types, including:
* Instance and Class methods
* Instance variables
* Classes, structs, and modules

```crystal
annotation MyAnnotation; end

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

## Reading

Annotations can be read off of a [`TypeNode`](https://crystal-lang.org/api/Crystal/Macros/TypeNode.html), [`Def`](https://crystal-lang.org/api/Crystal/Macros/Def.html), or [`MetaVar`](https://crystal-lang.org/api/Crystal/Macros/MetaVar.html) using the `[]` method.  This method return an [`Annotation`](https://crystal-lang.org/api/master/Crystal/Macros/Annotation.html) object representing the applied annotation of the supplied type.

**NOTE:** If multiple annotations of the same type are applied, the `annotation` method will return the _last_ one.

The [@type](../macros.md#type-information) and [@def](../macros.md#method-information) variables can be used to get `TypeNode` or `Def` object to use the `annotation` method on.  However, it is also possible to get `TypeNode`/`Def` types using other methods on `TypeNode`.  For example `TypeNode.all_subclasses` or `TypeNode.methods` respectfully.

The `TypeNode.instance_vars` can be used to get an array of instance variable `MetaVar` objects that would allow reading annotations defined on those instance variables.

**NOTE:** `TypeNode.instance_vars` currently only works in the context of an instance/class method.

```crystal
annotation MyClass; end
annotation MyMethod; end
annotation MyIvar; end

@[MyClass]
class Foo
  {{@type.annotation(MyClass).stringify}}
  
  @[MyIvar]
  @num : Int32 = 1
  
  @[MyIvar]
  property name : String = "jim"

  def properties
    {% for ivar in @type.instance_vars %}
      {{ivar.annotation(MyIvar).stringify}}
    {% end %}
  end
end

@[MyMethod]
def my_method
  {{@def.annotation(MyMethod).stringify}}
end

Foo.new.properties
my_method

# Which would print
"@[MyClass]"
"@[MyIvar]"
"@[MyIvar]"
"@[MyMethod]"
```

### Reading Multiple Annotations

If there are multiple annotations of the same type applied to the same instance variable/method/type, the `annotations(type : TypeNode)` method can be used.  This will work on anything that `annotation(type : TypeNode)` would, but instead returns an `ArrayLiteral(Annotation)`.

```crystal
annotation MyAnnotation; end

@[MyAnnotation("foo")]
@[MyAnnotation(123)]
@[MyAnnotation("bar")]
def annotation_read
  {% for ann, idx in @def.annotations(MyAnnotation) %}
    pp "Annotation {{idx}} = {{ann[0].id}}"
  {% end %}
end

annotation_read

# Which would print
"Annotation 0 = foo"
"Annotation 1 = 123"
"Annotation 2 = bar"
```


## Fields

Data can be stored within an annotation.

```crystal
annotation MyAnnotaion; end

# The fields can either be a key/value pair
@[MyAnnotation(key: "value", value: 123)]

# Or index based
@[MyAnnotation("foo", 123, false)]
```

### Key/value

The values of key/value pairs would be readable at compile time via the [`[]`](https://crystal-lang.org/api/Crystal/Macros/Annotation.html#%5B%5D%28name%3ASymbolLiteral%7CStringLiteral%7CMacroId%29%3AASTNode-instance-method)  method.

```crystal
annotation MyAnnotation; end

@[MyAnnotation(default: 2)]
def double(num : Number? = nil)
  # The name can be a `String`, `Symbol`, or `MacroId`
  2 * (num ? num : {{@def.annotation(MyAnnotation)[:default]}})
end

double 10 # => 20
double # => 4
```

### Indexed

Values added without a key name can be read at compile time via the [`[]`](<https://crystal-lang.org/api/Crystal/Macros/Annotation.html#%5B%5D%28index%3ANumberLiteral%29%3AASTNode-instance-method>)  method, however only one index can be read at a time.

```crystal
annotation MyAnnotation; end

@[MyAnnotation(1,2,3,4)]
def annotation_read
  {% for idx in [0,1,2,3] %}
    {% value = @def.annotation(MyAnnotation)[idx] %}
    pp "{{idx}} = {{value}}"
  {% end %}
end

annotation_read

# Which would print
"0 = 1"
"1 = 2"
"2 = 3"
"3 = 4"
```

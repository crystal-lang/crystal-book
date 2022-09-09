# Testing Crystal Code

Crystal comes with a fully-featured spec library in the [`Spec` module](https://crystal-lang.org/api/Spec.html). It provides a structure for writing executable examples of how your code should behave.

Inspired by [Rspec](http://rspec.info/), it includes a domain specific language (DSL) that allows you to write examples in a way similar to plain english.

A basic spec looks something like this:

```crystal
require "spec"

describe Array do
  describe "#size" do
    it "correctly reports the number of elements in the Array" do
      [1, 2, 3].size.should eq 3
    end
  end

  describe "#empty?" do
    it "is true when no elements are in the array" do
      ([] of Int32).empty?.should be_true
    end

    it "is false if there are elements in the array" do
      [1].empty?.should be_false
    end
  end
end
```

## Anatomy of a spec file

To use the spec module and DSL, you need to add `require "spec"` to your spec files. Many projects use a custom [spec helper](#spec-helper) which organizes these includes.

Concrete test cases are defined in `it` blocks. An optional (but strongly recommended) descriptive string states it's purpose and a block contains the main logic performing the test.

Test cases that have been defined or outlined but are not yet expected to work can be defined using `pending` instead of `it`. They will not be run but show up in the spec report as pending.

An `it` block contains an example that should invoke the code to be tested and define what is expected of it. Each example can contain multiple expectations, but it should test only one specific behaviour.

When `spec` is included, every object has the instance methods `#should` and `#should_not`. These methods are invoked on the value being tested with an expectation as argument. If the expectation is met, code execution continues. Otherwise the example has *failed* and other code in this block will not be executed.

In test files, specs are structured by example groups which are defined by `describe` and `context` sections. Typically a top level `describe` defines the outer unit (such as a class) to be tested by the spec. Further `describe` sections can be nested within the outer unit to specify smaller units under test (such as individual methods).

For unit tests, it is recommended to follow the conventions for method names: Outer `describe` is the name of the class, inner `describe` targets methods. Instance methods are prefixed with `#`, class methods with `.`.

To establish certain contexts - think *empty array* versus *array with elements* - the `context` method may be used to communicate this to the reader. It has a different name, but behaves exactly like `describe`.

`describe` and `context` take a description as argument (which should usually be a string) and a block containing the individual specs or nested groupings.

## Expectations

Expectations define if the value being tested (*actual*) matches a certain value or specific criteria.

### Equivalence, Identity and Type

There are methods to create expectations which test for equivalence (`eq`), identity (`be`), type (`be_a`), and nil (`be_nil`).
Note that the identity expectation uses `.same?` which tests if [`#object_id`](https://crystal-lang.org/api/Reference.html#object_id%3AUInt64-instance-method) are identical. This is only true if the expected value points to *the same object* instead of *an equivalent one*. This is only possible for reference types and won't work for value types like structs or numbers.

```crystal
actual.should eq(expected)   # passes if actual == expected
actual.should be(expected)   # passes if actual.same?(expected)
actual.should be_a(expected) # passes if actual.is_a?(expected)
actual.should be_nil         # passes if actual.nil?
```

### Truthiness

```crystal
actual.should be_true   # passes if actual == true
actual.should be_false  # passes if actual == false
actual.should be_truthy # passes if actual is truthy (neither nil nor false nor Pointer.null)
actual.should be_falsey # passes if actual is falsey (nil, false or Pointer.null)
```

### Comparisons

```crystal
actual.should be < expected  # passes if actual <  expected
actual.should be <= expected # passes if actual <= expected
actual.should be > expected  # passes if actual >  expected
actual.should be >= expected # passes if actual >= expected
```

### Other matchers

```crystal
actual.should be_close(expected, delta) # passes if actual is within delta of expected:
#                                         (actual - expected).abs <= delta
actual.should contain(expected) # passes if actual.includes?(expected)
actual.should match(expected)   # passes if actual =~ expected
```

### Expecting errors

These matchers run a block and pass if it raises a certain exception.

```crystal
expect_raises(MyError) do
  # Passes if this block raises an exception of type MyError.
end

expect_raises(MyError, "error message") do
  # Passes if this block raises an exception of type MyError
  # and the error message contains "error message".
end

expect_raises(MyError, /error \w{7}/) do
  # Passes if this block raises an exception of type MyError
  # and the error message matches the regular expression.
end
```

They return the rescued exception so it can be used for further expectations, for example to verify specific properties of the exception.

## Focusing on a group of specs

`describe`, `context` and `it` blocks can be marked with `focus: true`, like this:

```crystal
it "adds", focus: true do
  (2 + 2).should_not eq(5)
end
```

If any such thing is marked with `focus: true` then only those examples will run.

## Tagging specs

Tags can be used to group specs, allowing to only run a subset of specs when providing a `--tag` argument to the spec runner (see [Using the compiler](../man/crystal/README.md)).

`describe`, `context` and `it` blocks can be tagged, like this:

```crystal
it "is slow", tags: "slow" do
  sleep 60
  true.should be_true
end

it "is fast", tags: "fast" do
  true.should be_true
end
```

Tagging an example group (`describe` or `context`) extends to all of the contained examples.

Multiple tags can be specified by giving an [`Enumerable`](https://crystal-lang.org/api/Enumerable.html), such as [`Array`](https://crystal-lang.org/api/Array.html) or [`Set`](https://crystal-lang.org/api/Set.html).

## Running specs

The Crystal compiler has a `spec` command with tools to constrain which examples get run and tailor the output. All specs of a project are compiled and executed through the command `crystal spec`.

By convention, specs live in the `spec/` directory of a project. Spec files must end with `_spec.cr` to be recognizable as such by the compiler command.

You can compile and run specs from folder trees, individual files, or specific lines in a file. If the specified line is the beginning of a `describe` or `context` section, all specs inside that group are run.

The default formatter outputs the file and line style command for failing specs which makes it easy to rerun just this individual spec.

You can turn off colors with the switch `--no-color`.

### Randomizing order of specs

Specs, by default, run in the order defined, but can be run in a random order by passing `--order random` to `crystal spec`.

Specs run in random order will display a seed value upon completion. This seed value can be used to rerun the specs in that same order by passing the seed value to `--order`.

### Examples

```bash
# Run all specs in files matching spec/**/*_spec.cr
crystal spec

# Run  all specs in files matching spec/**/*_spec.cr without colors
crystal spec --no-color

# Run all specs in files matching spec/my/test/**/*_spec.cr
crystal spec spec/my/test/

# Run all specs in spec/my/test/file_spec.cr
crystal spec spec/my/test/file_spec.cr

# Run the spec or group defined in line 14 of spec/my/test/file_spec.cr
crystal spec spec/my/test/file_spec.cr:14

# Run all specs tagged with "fast"
crystal spec --tag 'fast'

# Run all specs not tagged with "slow"
crystal spec --tag '~slow'
```

## Spec helper

Many projects use a custom spec helper file, usually named `spec/spec_helper.cr`.

This file is used to require `spec` and other includes like code from the project needed for every spec file. This is also a good place to define global helper methods that make writing specs easier and avoid code duplication.

```crystal title="spec/spec_helper.cr"
require "spec"
require "../src/my_project.cr"

def create_test_object(name)
  project = MyProject.new(option: false)
  object = project.create_object(name)
  object
end
```

```crystal title="spec/my_project_spec.cr"
require "./spec_helper"

describe "MyProject::Object" do
  it "is created" do
    object = create_test_object(name)
    object.should_not be_nil
  end
end
```

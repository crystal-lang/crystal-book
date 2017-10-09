# Testing Crystal Code

Crystal comes with a full-feature spec library to write test cases in the [`Spec`module](https://crystal-lang.org/api/latest/Spec.html).

It is inspired by [Rspec](https://relishapp.com/rspec).

## Anatomy of a spec file

To use the spec module and DSL, you need to add `require "spec"` to your spec files. Many projects use a custom [spec helper](#spec-helper) which organizes these includes.

Test files are structured through `describe` and `context` sections. Typically a top level `describe` defines the outer unit (such as a class) to be tested by the spec. Further `describe` sections can be nested within the outer unit to specify smaller units under test (such as individual methods).

For unit tests, it is recommended to follow the conventions for method names: Outer `describe` is the name of the class, inner `describe` targets methods. Instance methods are prefixed with `#`, class methods with `.`.

To establish certain contexts - think *empty array* versus *array with elements* - the `context` method may be used to communicate this to the reader. It behaves exactly like `describe`.

`describe` and `context` take a description as argument (which should usually be a string) and a block containing the individual specs or nested groupings.

Concrete test cases are defined in `it` blocks. An optional (but strongly recommended) descriptive string states it's purpose and a block contains the main logic performing the test.

Test cases that have been defined or outlined but are not yet expected to work can be defined as `pending` instead of `it`. They will not be run but show up in the spec report as pending.

Specs then use the `should` or `should_not` method on actual to verify that the value matches the expectation provided as argument.

### Expectations

Expectations define if a actual value matches a certain value or specific criteria.

| Matcher        | Description |
| --             | -- |
| `eq(value)`    | passes if actual equals *value* (`==`) |
| `be(value)`    | passes if actual and *value* are identical (`.same?`) |
| `be_nil`       | passes if actual is nil (`== nil`) |
| `be_true`      | passes if actual is true (`== true`) |
| `be_false`     | passes if actual is false (`== false`) |
| `be_truthy`    | passes if actual is truthy (neither `nil` nor `false`) |
| `be_falsey`    | passes if actual is falsy (`nil` or `false`) |
| `be.<(value)`  | passes if actual is lesser than *value* (`<`) |
| `be.<=(value)` | passes if actual is lesser than or equal *value* (`<=`) |
| `be.>(value)`  | passes if actual is greater than *value* (`>`) |
| `be.>=(value)` | passes if actual is greater than or equal *value* (`>=`) |
| `be_close(expected, delta)` | passes if actual is within *delta* of *expected* |
| `contain`      | passes if actual includes *expected* (`.includes?`) |
| `match(value)` | passes if actual matches *value* (`=~`) |
| `be_a(type)`   | passes if actual is of type *type* (`is_a?`) |
| `expect_raises(&block)` | passes if the block raises an exception |
| `expect_raises(klass, &block)` | passes if the block raises an exception of type *klass* |
| `expect_raises(klass, message, &block)` | passes if the block raises an exception of type *klass* and the error message contains *message* |

## Running specs

All specs of a project are compiled and executed through the command `crystal spec`.

By convention, specs live in the `spec/` directory of a project. Spec files must end with `_spec.cr` to be recognizable as such by the compiler command.

You can compile and run specs from folder trees, individual files or specific lines in a file.

Run  all specs in files matching `spec/**/*_spec.cr`:
```
crystal spec
```

Run all specs in files matching `spec/my/test/**/*_spec.cr`:
```
crystal spec spec/my/test/
```

Run all specs in file `spec/my/test/file_spec.cr`:
```
crystal spec spec/my/test/file_spec.cr
```

Run the spec defined in line `14` of file `spec/my/test/file_spec.cr`:
```
crystal spec spec/my/test/file_spec.cr:14
```

The default formatter outputs the file and line style command for failing specs which makes it easy to rerun just this individual spec.

## Spec helper

Many projects use a custom spec helper file, usually named `spec/spec_helper.cr`.

This file is used to require `spec` and other includes like code from the project needed for every spec file. This is also a good place to define global helper methods that make writing specs easier and avoid code duplication.

```crystal
# spec/spec_helper.cr
require "spec"
require "../src/my_project.cr"

def create_test_object(name)
  project = MyProject.new(option: false)
  object = project.create_object(name)
  object
end

# spec/my_project_spec.cr
require "./spec_helper"

describe "MyProject::Object" do
  it "is created" do
    object = create_test_object(name)
    object.should_not be_nil
  end
end
```

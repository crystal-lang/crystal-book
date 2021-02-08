# Requiring files

Writing a program in a single file is OK for little snippets and small benchmark code. Big programs are better maintained and understood when split across different files.

To make the compiler process other files you use `require "..."`. It accepts a single argument, a string literal, and it can come in many flavors.

Once a file is required, the compiler remembers its absolute path and later `require`s of that same file will be ignored.

## require "filename"

This looks up "filename" in the require path.

By default the require path is the location of the standard library that comes with the compiler, and the "lib" directory relative to the current working directory (given by `pwd` in a Unix shell). These are the only places that are looked up.

The lookup goes like this:

* If a file named "filename.cr" is found in the require path, it is required.
* If a directory named "filename" is found and it contains a file named "filename.cr" directly underneath it, it is required.
* If a directory named "filename" is found with a directory "src" in it and it contains a file named "filename.cr" directly underneath it, it is required.
* If a directory named "filename" is found with a directory "src" in it and it contains a directory named "filename" directly underneath it with a "filename.cr" file inside it, it is required.
* Otherwise a compile-time error is issued.

The second rule means that in addition to having this:

```
- project
  - src
    - file
      - sub1.cr
      - sub2.cr
    - file.cr (requires "./file/*")
```

you can have it like this:

```
- project
  - src
    - file
      - file.cr (requires "./*")
      - sub1.cr
      - sub2.cr
```

which might be a bit cleaner depending on your taste.

The third rule is very convenient because of the typical directory structure of a project:

```
- project
  - lib
    - foo
      - src
        - foo.cr
    - bar
      - src
        - bar.cr
  - src
    - project.cr
  - spec
    - project_spec.cr
```

That is, inside "lib/{project}" each project's directory exists (`src`, `spec`, `README.md` and so on)

For example, if you put `require "foo"` in `project.cr` and run `crystal src/project.cr` in the project's root directory, it will find `foo` in `lib/foo/foo.cr`.

The fourth rule is the second rule applied to the third rule.

If you run the compiler from somewhere else, say the `src` folder, `lib` will not be in the path and `require "foo"` can't be resolved.

## require "./filename"

This looks up "filename" relative to the file containing the require expression.

The lookup goes like this:

* If a file named "filename.cr" is found relative to the current file, it is required.
* If a directory named "filename" is found and it contains a file named "filename.cr" directly underneath it, it is required.
* Otherwise a compile-time error is issued.

This relative is mostly used inside a project to refer to other files inside it. It is also used to refer to code from [specs](../guides/testing.md):

```crystal
# in spec/project_spec.cr
require "../src/project"
```

## Other forms

In both cases you can use nested names and they will be looked up in nested directories:

* `require "foo/bar/baz"` will lookup "foo/bar/baz.cr", "foo/bar/baz/baz.cr", "foo/src/bar/baz.cr" or "foo/src/bar/baz/baz.cr" in the require path.
* `require "./foo/bar/baz"` will lookup "foo/bar/baz.cr" or "foo/bar/baz/baz.cr" relative to the current file.

You can also use "../" to access parent directories relative to the current file, so `require "../../foo/bar"` works as well.

In all of these cases you can use the special `*` and `**` suffixes:

* `require "foo/*"` will require all ".cr" files below the "foo" directory, but not below directories inside "foo".
* `require "foo/**"` will require all ".cr" files below the "foo" directory, and below directories inside "foo", recursively.

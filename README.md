# Crystal Programming Language

This is the documentation for the Crystal programming language.

Crystal is a programming language with the following goals:

* Have a syntax similar to Ruby (but compatibility with it is not a goal)
* Be statically type-checked, but without having to specify the type of variables or method arguments.
* Be able to call C code by writing bindings to it in Crystal.
* Have compile-time evaluation and generation of code, to avoid boilerplate code.
* Compile to efficient native code.

## Build

```
$ git clone git@github.com:crystal-lang/crystal-book.git
$ cd crystal-book
$ npm install -g gitbook-cli
$ gitbook build --gitbook=2.3.2
```

Html output will be in `_book` folder.

# Crystal Programming Language

This is the language reference for the Crystal programming language.

Crystal is a programming language with the following goals:

* Have a syntax similar to Ruby (but compatibility with it is not a goal).
* Be statically type-checked, but without having to specify the type of variables or method parameters.
* Be able to call C code by writing bindings to it in Crystal.
* Have compile-time evaluation and generation of code, to avoid boilerplate code.
* Compile to efficient native code.

**Crystal's standard library is documented in the [API docs](https://crystal-lang.org/api).**

## Contributing to the Language Reference

Do you consider yourself a helpful person? If you find bugs or sections
which need more clarification you're welcome to contribute to this
language reference. You can submit a pull request to this repository:
https://github.com/crystal-lang/crystal-book

Thank you very much!

### Building and Serving Locally

```console
$ git clone https://github.com/crystal-lang/crystal-book
$ cd crystal-book
```

Live preview (at http://127.0.0.1:8000):

```console
$ make serve
INFO    -  Building documentation...
INFO    -  Cleaning site directory
INFO    -  Documentation built in 3.02 seconds
INFO    -  Serving on http://127.0.0.1:8000
...
```

Build into the `site` directory (some functionality won't work if opening the files locally):

```console
$ make build
```

### Adding a page

To add a page, create a Markdown file in the desired location. Then, add a link in the `SUMMARY.md` file which acts as the navigation for the language reference.

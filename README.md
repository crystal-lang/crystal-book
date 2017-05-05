# Crystal Programming Language

This is the documentation for the Crystal programming language.

Crystal is a programming language with the following goals:

* Have a syntax similar to Ruby (but compatibility with it is not a goal).
* Be statically type-checked, but without having to specify the type of variables or method arguments.
* Be able to call C code by writing bindings to it in Crystal.
* Have compile-time evaluation and generation of code, to avoid boilerplate code.
* Compile to efficient native code.

## Contributing to the Language Reference

Do you consider yourself a helpful person? If you find bugs or sections
which need more clarification you're welcome to contribute to this
documentation. You can submit a pull request to this repository:
https://github.com/crystal-lang/crystal-book

Thank you very much!

### Building and Serving Locally

```
$ git clone https://github.com/crystal-lang/crystal-book.git
$ cd crystal-book
$ npm install -g gitbook-cli@2.3.0
$ npm install
$ gitbook serve
Live reload server started on port: 35729
Press CTRL+C to quit ...

info: 8 plugins are installed
info: loading plugin "ga"... OK
...
Starting server ...
Serving book on http://localhost:4000

```

Html output will be in `_book` folder (some links won't work if opening the files locally).
There is also a docker environment to avoid installing dependencies globally:

```
$ docker-compose up
...
gitbook_1  | Starting server ...
gitbook_1  | Serving book on http://localhost:4000
gitbook_1  | Restart after change in file node_modules/.bin
...
```

### Adding a page

To add a page, create a markdown file in the desired location. Example: `overview/hello_world.md`. Then, add a link in the `SUMMARY.md` file which acts as the navigation for the documentation.

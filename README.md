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

### Branches

There is a separate branch for every minor Crystal release, all deployed alongside each other on https://crystal-lang.org/reference/
Typically, only branches of maintained releases receive updates, i.e. the branch for the most recent Crystal release.

* Changes that apply to the current Crystal release should go into the most recent `release/*` branch.
* Changes that apply to yet unreleased features should go into `master`. They'll be part of the `release/*` branch for the next release.
  The `master` branch is deployed at https://crystal-lang.org/reference/master/

### Building and Serving Locally

```console
$ git clone https://github.com/crystal-lang/crystal-book
$ cd crystal-book
$ pip install -r requirements.txt
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

### devenv environment

This project includes configuration for a reproducible environment via [devenv.sh](https://devenv.sh/)
with integrated pre-commit checks.

Live preview (at http://127.0.0.1:8000):

```console
$ devenv up
Building shell ...
pre-commit-hooks.nix: hooks up to date
17:37:13 system  | serve.1 started (pid=6507)
17:37:13 serve.1 | INFO     -  Building documentation...
17:37:13 serve.1 | INFO     -  Cleaning site directory
17:37:16 serve.1 | INFO     -  Documentation built in 2.64 seconds
17:37:16 serve.1 | INFO     -  [17:37:16] Watching paths for changes: 'docs', 'mkdocs.yml'
17:37:16 serve.1 | INFO     -  [17:37:16] Serving on http://127.0.0.1:8000/reference/latest/
````

Build the site:

```console
$ devenv shell build
Building shell ...
pre-commit-hooks.nix: hooks up to date
rm -rf ./site
mkdocs build -d ./site  --strict
INFO     -  Cleaning site directory
INFO     -  Building documentation to directory: ./site
INFO     -  Documentation built in 2.43 seconds
```

Enter the development shell and build the site from there:

```console
$ devenv shell
Building shell ...
Entering shell ...

pre-commit-hooks.nix: hooks up to date
$(devenv) make build
mkdocs build -d ./site  --strict
INFO     -  Cleaning site directory
INFO     -  Building documentation to directory: ./site
INFO     -  Documentation built in 2.43 seconds
```

Run pre-commit checks on the entire repository:

```console
$ devenv ci
```

### Adding a page

To add a page, create a Markdown file in the desired location. Then, add a link in the `SUMMARY.md` file which acts as the navigation for the language reference.

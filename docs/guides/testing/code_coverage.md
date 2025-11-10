# Code Coverage Reporting

Writing [tests](../testing.md) is an important part of creating an easy to maintain codebase by providing an automated way to ensure your program is doing what it should be.
But how do you know if you’re testing the right things, or how effective your tests actually are? Simple: code coverage reporting.

Code coverage reporting is a process in which your specs are ran, and some tool keeps track of what lines of code in your program were executed.
From here, the report may then be used to influence where to focus your efforts to improve the coverage percentage, or more ideally ensure all newly added code is covered.

## Crystal Code Coverage

Unfortunately there is no super straightforward way to do this via a single `--coverage` flag when running `crystal spec` for example.
But the overall process is not overly complex, just consists of a few steps:

1. Generate the “core” coverage report
2. Generate another report representing unreachable methods
3. Generate a report for macros

### Core Report

*The process for this section all was inspired from a [blog post](https://hannes.kaeufler.net/posts/measuring-code-coverage-in-crystal-with-kcov) by* @hanneskaeufler

Given there is no internal way to generate this report within Crystal itself, we need to look for alternatives.
The simplest of which is to make use of the fact Crystal uses [DWARF](https://dwarfstd.org/) for its debug information (the internal data used to power stack traces and such).
Knowing this we can use a tool like [kcov](https://github.com/SimonKagstrom/kcov) to read this information to produce our coverage report.

The one problem with `kcov` however, is that it needs to run against a built binary; meaning we can’t just leverage or tap into `crystal spec`, but instead must first build a binary that would run the specs when executed.
Because there is not single entrypoint into your specs, the easiest way to do this is by creating a file that requires all files within the `spec/` directory, then use that as the entrypoint.
Something like this, from the root of your shard:

```sh
echo 'require "./spec/**"' > './coverage.cr'
mkdir ./bin
crystal build './coverage.cr' -o './bin/coverage'
```

From here you can run `kcov` against `./bin/coverage`:

```sh
kcov --clean --include-path="./src" ./coverage ./bin/coverage --order=random
```

Let’s break this down:

* `--clean` makes it so only the latest run is kept
* `--include-path` will only include `src/` in the report. I.e. we don’t want code from Crystal’s stdlib or external dependencies to be included
* `./coverage` represents the directory the report will be written to

The second argument is our built spec binary, which can still accept spec runner options like `--order=random`.

If all went well you should now have a `coverage/index.html` file that you can open in your browser to view your core coverage report.
It also includes various machine readable coverage report formats that we’ll get to later.

### Unreachable Code

Crystal’s compiler removes dead code automatically when building a binary, or in other words, things that are unused (methods, types, etc) will not be included at all in the resulting binary.
This is usually a good thing as it’s less code, thus reducing the final binary size.

However, the con of this feature is that because the compiler just totally ignores these unused methods, no type checking occurs on them.
This can lead to a sense of false security in that your code could compile just fine, but then start to fail once one of those unused methods starts being used if there is a syntax error within its definition for example.
Additionally, `kcov` is entirely unaware these methods exist and as such do not mark them as missed.

Fortunately for us, there is a built-in tool we can use to identify these unused methods:

```sh
crystal tool unreachable --no-color --format=codecov ./coverage.cr > "./coverage/unreachable.codecov.json"
```

This will output a report marking unreachable methods as missed.
More on the `--format=codecov` in the [Tooling](#tooling) section later on.

### Macro Code

Up until now, all of the coverage reporting we’ve generated are for the program at runtime.
However, Crystal’s [macros](../../syntax_and_semantics/macros/README.md) can be quite complex as well.
We can leverage another `crystal tool` to generate a coverage report for your program’s compile time macro code.
This step can be skipped of course if you don’t use any custom macros at all.

```sh
crystal tool macro_code_coverage --no-color "./coverage.cr" > "./coverage/macro_coverage.root.codecov.json"
```

## Tooling

At this point you will have multiple files that each represent a portion of your program’s code coverage.
But it’s not super clear how they all fit together.
Taking things a step further we can leverage a vendor like [Codecov](https://about.codecov.io/) to provide extra capabilities to both make understanding your reports easier, integrate CI checks, and allow sharing results of your project.

All of the reports we generated are in the [codecov custom coverage format](https://docs.codecov.com/docs/codecov-custom-coverage-format).
(`kcov` also generates others which Codecov supports as well).
As such, we can upload all of them and Codecov will take care of merging them together into a single view of coverage.

This is as simple as setting up the [Codecov Action](https://github.com/codecov/codecov-action) if you’re using GitHub Actions.
For our case, the key thing we need to set is what files to upload, setting the `files` input to `'**/cov.xml,**/unreachable.codecov.json,**/macro_coverage.*.codecov.json'` to ensure all the files are uploaded.

There is a lot more nuance to code coverage than what I covered here.
The big one being that having 100% test coverage does not imply that your code is bug free, or that it’s even worth trying to get to that level.
Instead a good middle ground, for Codecov at least, is to set the target `patch` percentage to `100%` and set `project` target to `auto`.
These will ensure that all *new* code is fully covered and does not reduce the overall coverage of the codebase.

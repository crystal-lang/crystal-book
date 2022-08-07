# Writing Shards

How to write and release Crystal Shards.

## _What's a Shard?_

Simply put, a Shard is a package of Crystal code, made to be shared-with and used-by other projects.

See [the Shards command](../the_shards_command/README.md) for details.

## Introduction

In this tutorial, we'll be making a Crystal library called _palindrome-example_.

> For those who don't know, a palindrome is a word which is spelled the same way forwards as it is backwards. e.g. racecar, mom, dad, kayak, madam

### Requirements

In order to release a Crystal Shard, and follow along with this tutorial, you will need the following:

* A working installation of the [Crystal compiler](../using_the_compiler/README.md)
* A working installation of [Git](https://git-scm.com)
* A [GitHub](https://github.com) or [GitLab](https://gitlab.com/) account

### Creating the Project

Begin by using [the Crystal compiler](../using_the_compiler/README.md)'s `init lib` command to create a Crystal library with the standard directory structure.

In your terminal: `crystal init lib <YOUR-SHARD-NAME>`

e.g.

```console
$ crystal init lib palindrome-example
    create  palindrome-example/.gitignore
    create  palindrome-example/.editorconfig
    create  palindrome-example/LICENSE
    create  palindrome-example/README.md
    create  palindrome-example/shard.yml
    create  palindrome-example/src/palindrome-example.cr
    create  palindrome-example/spec/spec_helper.cr
    create  palindrome-example/spec/palindrome-example_spec.cr
Initialized empty Git repository in /<YOUR-DIRECTORY>/.../palindrome-example/.git/
```

...and `cd` into the directory:

e.g.

```bash
cd palindrome-example
```

Then `add` & `commit` to start tracking the files with Git:

```console
$ git add -A
$ git commit -am "First Commit"
[master (root-commit) 77bad84] First Commit
 8 files changed, 104 insertions(+)
 create mode 100644 .editorconfig
 create mode 100644 .gitignore
 create mode 100644 LICENSE
 create mode 100644 README.md
 create mode 100644 shard.yml
 create mode 100644 spec/palindrome-example_spec.cr
 create mode 100644 spec/spec_helper.cr
 create mode 100644 src/palindrome-example.cr
```

### Writing the Code

The code you write is up to you, but how you write it impacts whether people want to use your library and/or help you maintain it.

#### Testing the Code

* Test your code. All of it. It's the only way for anyone, including you, to know if it works.
* Crystal has [a built-in testing library](https://crystal-lang.org/api/Spec.html). Use it!

#### Documentation

* Document your code with comments. All of it. Even the private methods.
* Crystal has [a built-in documentation generator](../syntax_and_semantics/documenting_code.md). Use it!

Run `crystal docs` to convert your code and comments into interlinking API documentation. Open the files in the `/docs/` directory with a web browser to see how your documentation is looking along the way.

See below for instructions on hosting your compiler-generated docs on GitHub/GitLab Pages.

Once your documentation is ready and available, you can add a documentation badge to your repository so users know that it exists. In GitLab this badge belongs to the project so we'll cover it in the GitLab instructions below, for GitHub it is common to place it below the description in your README.md like so:
(Be sure to replace `<LINK-TO-YOUR-DOCUMENTATION>` accordingly)

```markdown
[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](<LINK-TO-YOUR-DOCUMENTATION>)
```

### Writing a README

A good README can make or break your project.
[Awesome README](https://github.com/matiassingers/awesome-readme) is a nice curation of examples and resources on the topic.

Most importantly, your README should explain:

1. What your library is
2. What it does
3. How to use it

This explanation should include a few examples along with subheadings.

NOTE: Be sure to replace all instances of `[your-github-name]` in the Crystal-generated README template with your GitHub/GitLab username. If you're using GitLab, you'll also want to change all instances of `github` with `gitlab`.

#### Coding Style

* It's fine to have your own style, but sticking to [some core rubrics defined by the Crystal team](../conventions/coding_style.md) can help keep your code consistent, readable and usable for other developers.
* Utilize Crystal's [built-in code formatter](../syntax_and_semantics/documenting_code.md) to automatically format all `.cr` files in a directory.

e.g.

```
crystal tool format
```

To check if your code is formatted correctly, or to check if using the formatter wouldn't produce any changes, simply add `--check` to the end of this command.

e.g.

```
crystal tool format --check
```

This check is good to add as a step in [continuous integration](ci/README.md).

### Writing a `shard.yml`

[The spec](https://github.com/crystal-lang/shards/blob/master/docs/shard.yml.adoc) is your rulebook. Follow it.

#### Name

Your `shard.yml`'s `name` property should be concise and descriptive.

* Search any of the available [shard databases](https://crystal-lang.org/community/#shards) to check if your name is already taken.

e.g.

```yaml
name: palindrome-example
```

#### Description

Add a `description` to your `shard.yml`.

A `description` is a single line description used to search for and find your shard.

A description should be:

1. Informative
2. Discoverable

#### Optimizing

It's hard for anyone to use your project if they can't find it.
There are several services for discovering shards, a list is available on the [Crystal Community page](https://crystal-lang.org/community/#shards).

There are people looking for the _exact_ functionality of our library and the _general_ functionality of our library.
e.g. Bob needs a palindrome library, but Felipe is just looking for libraries involving text and Susan is looking for libraries involving spelling.

Our `name` is already descriptive enough for Bob's search of "palindrome". We don't need to repeat the _palindrome_ keyword. Instead, we'll catch Susan's search for "spelling" and Felipe's search for "text".

```yaml
description: |
  A textual algorithm to tell if a word is spelled the same way forwards as it is backwards.
```

### Hosting

From here the guide differs depending on whether you are hosting your repo on GitHub or GitLab. If you're hosting somewhere else, please feel free to write up a guide and add it to this book!

* [Hosting on GitHub](./hosting/github.md)
* [Hosting on GitLab](./hosting/gitlab.md)

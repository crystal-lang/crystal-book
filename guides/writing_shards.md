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
* A [GitHub](https://github.com) account

### Creating the Project

Begin by using [the Crystal compiler](../using_the_compiler/README.md)'s `init lib` command to create a Crystal library with the standard directory structure.

In your terminal: `crystal init lib <YOUR-SHARD-NAME>`

e.g.
```bash
 $  crystal init lib palindrome-example
      create  palindrome-example/.gitignore
      create  palindrome-example/.editorconfig
      create  palindrome-example/LICENSE
      create  palindrome-example/README.md
      create  palindrome-example/.travis.yml
      create  palindrome-example/shard.yml
      create  palindrome-example/src/palindrome-example.cr
      create  palindrome-example/src/palindrome-example/version.cr
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

```bash
 $  git add -A
 $  git commit -am "First Commit"
[master (root-commit) 77bad84] First Commit
 10 files changed, 102 insertions(+)
 create mode 100644 .editorconfig
 create mode 100644 .gitignore
 create mode 100644 .travis.yml
 create mode 100644 LICENSE
 create mode 100644 README.md
 create mode 100644 shard.yml
 create mode 100644 spec/palindrome-example_spec.cr
 create mode 100644 spec/spec_helper.cr
 create mode 100644 src/palindrome-example.cr
 create mode 100644 src/palindrome-example/version.cr
```

### Writing the Code

The code you write is up to you, but how you write it impacts whether people want to use your library and/or help you maintain it.

#### Testing the Code
- Test your code. All of it. It's the only way for anyone, including you, to know if it works.
- Crystal has [a built-in testing library](https://crystal-lang.org/api/Spec.html). Use it!

#### Documentation
- Document your code with comments. All of it. Even the private methods.
- Crystal has [a built-in documentation generator](../conventions/documenting_code.md). Use it!

Run `crystal docs` to convert your code and comments into interlinking API documentation. Open the files in the `/docs/` directory with a web browser to see how your documentation is looking along the way.

See below for instructions on hosting your compiler-generated docs on GitHub Pages.

Once your documentation is ready and available, add this documentation badge below the description in your README.md so users know that it exists.
(Be sure to replace `<LINK-TO-YOUR-DOCUMENTATION>` accordingly)

```Markdown
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

NOTE: Be sure to replace all instances of `[your-github-name]` in the Crystal-generated README template with your GitHub username.


#### Coding Style 
- It's fine to have your own style, but sticking to [some core rubrics defined by the Crystal team](../conventions/coding_style.md) can help keep your code consistent, readable and usable for other developers.
- Utilize Crystal's [built-in code formatter](../conventions/documenting_code.md) to automatically format all `.cr` files in a directory.

e.g. 
```
crystal tool format
```

To check if your code is formatted correctly, or to check if using the formatter wouldn't produce any changes, simply add `--check` to the end of this command. 

e.g. 
```
crystal tool format --check
```

See the Travis CI section below to implement this in your build.


### Writing a `shard.yml`

[The spec](https://github.com/crystal-lang/shards/blob/master/SPEC.md) is your rulebook. Follow it.

#### Name
Your `shard.yml`'s `name` property should be concise and descriptive. 

- Search [crystalshards.xyz](https://crystalshards.xyz/) to check if your name is already taken.

e.g.
```YAML
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
[crystalshards.xyz](https://crystalshards.xyz/) is currently the go-to place for Crystal libraries, so that's what we'll optimize for.

There are people looking for the _exact_ functionality of our library and the _general_ functionality of our library.
e.g. Bob needs a palindrome library, but Felipe is just looking for libraries involving text and Susan is looking for libraries involving spelling.

Our `name` is already descriptive enough for Bob's search of "palindrome". We don't need to repeat the _palindrome_ keyword. Instead, we'll catch Susan's search for "spelling" and Felipe's search for "text".
```YAML
description: |
  A textual algorithm to tell if a word is spelled the same way forwards as it is backwards.
```

### GitHub

- Create a repository with the same `name` and `description` as specified in your `shard.yml`.

- Add and commit everything:
```bash
$ git add -A && git commit -am "shard complete"
```
- Add the remote: (Be sure to replace `<YOUR-GITHUB-USERNAME>` and `<YOUR-REPOSITORY-NAME>` accordingly)

NOTE: If you like, feel free to replace `public` with `origin`, or a remote name of your choosing.
```bash 
$ git remote add public https://github.com/<YOUR-GITHUB-NAME>/<YOUR-REPOSITORY-NAME>.git
```
- Push it: 
```bash
$ git push public master
```

#### GitHub Releases
It's good practice to do GitHub Releases.

Add the following markdown build badge below the description in your README to inform users what the most current release is:
(Be sure to replace `<YOUR-GITHUB-USERNAME>` and `<YOUR-REPOSITORY-NAME>` accordingly)

```Markdown
[![GitHub release](https://img.shields.io/github/release/<YOUR-GITHUB-USERNAME>/<YOUR-REPOSITORY-NAME>.svg)](https://github.com/<YOUR-GITHUB-USERNAME>/<YOUR-REPOSITORY-NAME>/releases)
```

Start by navigating to your repository's _releases_ page.
  - This can be found at `https://github.com/<YOUR-GITHUB-NAME>/<YOUR-REPOSITORY-NAME>/releases`

Click "Create a new release".

According to [the Crystal Shards README](https://github.com/crystal-lang/shards/blob/master/README.md), 
> When libraries are installed from Git repositories, the repository is expected to have version tags following a semver-like format, prefixed with a `v`. Examples: v1.2.3, v2.0.0-rc1 or v2017.04.1

Accordingly, in the input that says `tag version`, type `v0.1.0`. Make sure this matches the `version` in `shard.yml`. Title it `v0.1.0` and write a short description for the release.

Click "Publish release" and you're done!

You'll now notice that the GitHub Release badge has updated in your README.

Follow [Semantic Versioning](http://semver.org/) and create a new release every time your push new code to `master`.

### Travis CI and `.travis.yml`
If you haven't already, [sign up for Travis CI](https://travis-ci.org/).

Insert the following markdown build badge below the description in your README.md:
(be sure to replace `<YOUR-GITHUB-USERNAME>` and `<YOUR-REPOSITORY-NAME>` accordingly)
```Markdown
[![Build Status](https://travis-ci.org/<YOUR-GITHUB-USERNAME>/<YOUR-REPOSITORY-NAME>.svg?branch=master)](https://travis-ci.org/<YOUR-GITHUB-USERNAME>/<YOUR-REPOSITORY-NAME>) 
```
Build badges are a simple way to tell people whether your Travis CI build passes.

Add the following lines to your `.travis.yml`:
```YAML
script:
  - crystal spec
```

This tells Travis CI to run your tests.
Accordingly with the outcome of this command, Travis CI will return a [build status](https://docs.travis-ci.com/user/for-beginners/#breaking-the-build) of "passed", "errored", "failed" or "canceled".


If you want to verify that all your code has been formatted with `crystal tool format`, add a script for `crystal tool format --check`. If the code is not formatted correctly, this will [break the build](https://docs.travis-ci.com/user/for-beginners/#breaking-the-build) just as failing tests would.

e.g.
```YAML
script:
  - crystal spec
  - crystal tool format --check
```


Commit and push to GitHub.

Follow [these guidelines](https://docs.travis-ci.com/user/getting-started/) to get your repo up & running on Travis CI.

Once you're up and running, and the build is passing, the build badge will update in your README.


#### Hosting your `docs` on GitHub-Pages

Add the following `script` to your `.travis.yml`:
```YAML
  - crystal docs
```

This tells Travis CI to generate your documentation.

Next, add the following lines to your `.travis.yml`.
(Be sure to replace all instances of `<YOUR-GITHUB-REPOSITORY-NAME>` accordingly)
```YAML
deploy:
  provider: pages
  skip_cleanup: true
  github_token: $GITHUB_TOKEN
  project_name: <YOUR-GITHUB-REPOSITORY-NAME>
  on:
    branch: master
  local_dir: docs
```

[Set the Environment Variable](https://docs.travis-ci.com/user/environment-variables#defining-variables-in-repository-settings), `GITHUB_TOKEN`, with your [personal access token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).

If you've been following along, your `.travis.yml` file should look something like this:

```YAML
language: crystal
script:
  - crystal spec
  - crystal docs
deploy:
  provider: pages
  skip_cleanup: true
  github_token: $GITHUB_TOKEN
  project_name: <YOUR-GITHUB-REPOSITORY-NAME>
  on:
    branch: master
  local_dir: docs
```

[Click Here](https://docs.travis-ci.com/user/deployment/pages/) for the official documentation on deploying to GitHub-Pages with Travis CI.

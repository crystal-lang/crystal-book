# Hosting on GitHub

- Create a project with the same `name` and `description` as specified in your `shard.yml`.

- Add and commit everything:
```bash
$ git add -A && git commit -am "shard complete"
```
- Add the remote: (Be sure to replace `<YOUR-GITHUB-USERNAME>` and `<YOUR-REPOSITORY-NAME>` accordingly)

```bash
$ git remote add origin https://github.com/<YOUR-GITHUB-NAME>/<YOUR-REPOSITORY-NAME>.git
```
- Push it:
```bash
$ git push origin master
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

Follow [Semantic Versioning](http://semver.org/).

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
Accordingly with the outcome of this command, Travis CI will return a [build status](https://docs.travis-ci.com/user/customizing-the-build/#Breaking-the-Build) of "passed", "errored", "failed" or "canceled".


If you want to verify that all your code has been formatted with `crystal tool format`, add a script for `crystal tool format --check`. If the code is not formatted correctly, this will [break the build](https://docs.travis-ci.com/user/for-beginners/#Breaking-the-Build) just as failing tests would.

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

[Set the Environment Variable](https://docs.travis-ci.com/user/environment-variables#Defining-Variables-in-Repository-Settings), `GITHUB_TOKEN`, with your [personal access token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).

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

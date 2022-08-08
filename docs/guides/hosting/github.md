# Hosting on GitHub

- Create a repository with the same `name` and `description` as specified in your `shard.yml`.

- Add and commit everything:

    ```console
    $ git add -A && git commit -am "shard complete"
    ```

- Add the remote: (Be sure to replace `<YOUR-GITHUB-USERNAME>` and `<YOUR-REPOSITORY-NAME>` accordingly)

    NOTE: If you like, feel free to replace `public` with `origin`, or a remote name of your choosing.

    ```console
    $ git remote add public https://github.com/<YOUR-GITHUB-NAME>/<YOUR-REPOSITORY-NAME>.git
    ```

- Push it:

    ```console
    $ git push public master
    ```

## GitHub Releases

It's good practice to do GitHub Releases.

Add the following markdown build badge below the description in your README to inform users what the most current release is:
(Be sure to replace `<YOUR-GITHUB-USERNAME>` and `<YOUR-REPOSITORY-NAME>` accordingly)

```markdown
[![GitHub release](https://img.shields.io/github/release/<YOUR-GITHUB-USERNAME>/<YOUR-REPOSITORY-NAME>.svg)](https://github.com/<YOUR-GITHUB-USERNAME>/<YOUR-REPOSITORY-NAME>/releases)
```

Start by navigating to your repository's _releases_ page.
This can be found at `https://github.com/<YOUR-GITHUB-NAME>/<YOUR-REPOSITORY-NAME>/releases`

Click "Create a new release".

According to [the Crystal Shards README](https://github.com/crystal-lang/shards/blob/master/README.md), 
> When libraries are installed from Git repositories, the repository is expected to have version tags following a semver-like format, prefixed with a `v`. Examples: v1.2.3, v2.0.0-rc1 or v2017.04.1

Accordingly, in the input that says `tag version`, type `v0.1.0`. Make sure this matches the `version` in `shard.yml`. Title it `v0.1.0` and write a short description for the release.

Click "Publish release" and you're done!

You'll now notice that the GitHub Release badge has updated in your README.

Follow [Semantic Versioning](http://semver.org/) and create a new release every time your push new code to `master`.

## Continuous integration

GitHub Actions allows you to automatically test your project on every commit. Configure it according to the [dedicated guide](../ci/gh-actions.md).

You can also [add a build status badge](https://docs.github.com/en/actions/managing-workflow-runs/adding-a-workflow-status-badge) below the description in your README.md.

### Hosting your docs on GitHub Pages

As an extension of the GitHub Actions config, you can add the steps to build the API doc site and then upload them, correspondingly:

```yaml
    steps:

      - name: Build docs
        run: crystal docs
      - name: Deploy docs
        if: github.event_name == 'push' && github.ref == 'refs/heads/master'
        uses: ...
        with:
          ...
```

-- where the latter `...` placeholder is any of the generic GitHub Actions to push a directory to the *gh-pages* branch. Some options are:

* [JamesIves/github-pages-deploy-action](https://github.com/JamesIves/github-pages-deploy-action) [[Search](https://github.com/search?q=JamesIves+crystal+path%3A.github%2Fworkflows&type=Code)]
* [crazy-max/ghaction-github-pages](https://github.com/crazy-max/ghaction-github-pages) [[Search](https://github.com/search?q=%22ghaction-github-pages%22+crystal+path%3A.github%2Fworkflows&type=Code)]
* [peaceiris/actions-gh-pages](https://github.com/peaceiris/actions-gh-pages) [[Search](https://github.com/search?q=peaceiris%2Factions-gh-pages+crystal+path%3A.github%2Fworkflows&type=Code)]
* [oprypin/push-to-gh-pages](https://github.com/oprypin/push-to-gh-pages) [[Search](https://github.com/search?q=%22oprypin%2Fpush-to-gh-pages%22+crystal+path%3A.github%2Fworkflows&type=Code)]

This uses Crystal's built-in API doc generator to make a generic site based on your code and comments to the items in it.

Rather than just publishing the generated API docs, consider also making a full textual manual of your project, for a well-rounded introduction.

For one of the options for static site generation, [mkdocs-material](https://squidfunk.github.io/mkdocs-material), there's a solution to tightly integrate API documentation into an overall documentation site: [mkdocstrings-crystal](https://github.com/mkdocstrings/crystal). Consider it as an alternative to `crystal docs`.

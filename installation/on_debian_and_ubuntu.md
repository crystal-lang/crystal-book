# On Debian and Ubuntu

In Debian derived distributions, you can use the official Crystal repository.

## Setup repository

First you have to add the repository to your APT configuration. For easy setup just run in your command line:

```bash
curl -sSL https://dist.crystal-lang.org/apt/setup.sh | sudo bash
```

That will add the signing key and the repository configuration. If you prefer to do it manually, execute the following commands:

```bash
sudo sh -c 'apt-key adv --keyserver keys.gnupg.net --recv-keys 09617FD37CC06B54 && \
            echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list && \
            apt-get update'
```

**NOTE:** There is a bug in Ubuntu 18.04 running on Windows Subystem for Linux, making `apt-key adv` fail.
As a workaround, the first command can be replaced by `curl -sL "https://keybase.io/crystal/pgp_keys.asc" | sudo apt-key add`.

## Install
Once the repository is configured you're ready to install Crystal:

```bash
sudo apt install crystal
```

Sometimes the package `build-essential` needs to be installed in order to run/build Crystal programs (see [issue #4342](https://github.com/crystal-lang/crystal/issues/4342)):

```bash
sudo apt install build-essential
```

The following packages are not required, but recommended for using the respective stlib features:

```bash
sudo apt install libssl-dev      # for using OpenSSL
sudo apt install libxml2-dev     # for using XML
sudo apt install libyaml-dev     # for using YAML
sudo apt install libgmp-dev      # for using Big numbers
sudo apt install libreadline-dev # for using Readline
```

For building the Crystal compiler itself, a few other dependencies are needed, see [wiki page](https://github.com/crystal-lang/crystal/wiki/All-required-libraries#ubuntu). They are not required for regular compiler use.

## Upgrade

When a new Crystal version is released you can upgrade your system using:

```bash
sudo apt update
sudo apt install crystal
```

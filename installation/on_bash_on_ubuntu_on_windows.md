# On Bash on Ubuntu on Windows

Crystal doesn't support Windows _yet_, but if you're using Windows 10 you can (experimentally) try Crystal using [Bash on Ubuntu on Windows](https://msdn.microsoft.com/en-us/commandline/wsl/about), an experimental Bash environment running on Windows. The installation instructions are the same as for [Debian/Ubuntu](on_debian_and_ubuntu.md), but there are a few rough edges to be aware of.

Don't forget - **this is highly experimental**.

## Setup repository

First you have to add the repository to your APT configuration. For easy setup just run in your command line:

```
curl https://dist.crystal-lang.org/apt/setup.sh | sudo bash
```

That will add the signing key and the repository configuration. If you prefer to do it manually, execute the following commands:

```
sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 09617FD37CC06B54
echo "deb https://dist.crystal-lang.org/apt crystal main" | sudo tee /etc/apt/sources.list.d/crystal.list
sudo apt-get update
```

## Dependencies
Crystal needs a C compiler (`cc`) and linker (`ld`) to be able to compile Crystal programs - so you should install them:

```
sudo apt-get install clang binutils
```

## Install
Once the repository is configured and you have the dependencies, you're ready to install Crystal:

```
sudo apt-get install crystal
```

## Upgrade

When a new Crystal version is released you can upgrade your system using:

```
sudo apt-get update
sudo apt-get install crystal
```

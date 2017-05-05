# On Debian and Ubuntu

In Debian derived distributions, you can use the official Crystal repository.

## Setup repository

First you have to add the repository to your APT configuration. For easy setup just run in your command line:

```
curl https://dist.crystal-lang.org/apt/setup.sh | sudo bash
```

That will add the signing key and the repository configuration. If you prefer to do it manually, execute the following commands as *root*:

```
apt-key adv --keyserver keys.gnupg.net --recv-keys 09617FD37CC06B54
echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list
apt-get update
```

## Install
Once the repository is configured you're ready to install Crystal:

```
sudo apt-get install crystal
```

## Install required libraries
Before you can use Crystal you'll need to install some required libraries:

```
sudo apt-get install \
  libbsd-dev \
  libedit-dev \
  libevent-core-2.0-5 \
  libevent-dev \
  libevent-extra-2.0-5 \
  libevent-openssl-2.0-5 \
  libevent-pthreads-2.0-5 \
  libgmp-dev \
  libgmpxx4ldbl \
  libssl-dev \
  libxml2-dev \
  libyaml-dev \
  libreadline-dev \
  automake \
  libtool \
  git \
  llvm
```

## Upgrade

When a new Crystal version is released you can upgrade your system using:

```
sudo apt-get update
sudo apt-get install crystal
```

# On Debian and Ubuntu

In Debian derived distributions, you can use the official Crystal repository.

## Update package signing key

In June 2017, the package signing key used to ship Crystal was updated. Users of
the old key might see a message similar to the following when
running `apt-get update`:

```
W: An error occurred during the signature verification. The repository is not updated and the previous index files will be used. GPG error: https://dist.crystal-lang.org crystal InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY A4EBAC6667697DD2
W: Failed to fetch https://dist.crystal-lang.org/apt/dists/crystal/InRelease
W: Some index files failed to download. They have been ignored, or old ones used instead.
```

To fix this error, import the new key and delete the old one:

```
apt-key adv --keyserver keys.gnupg.net --recv-keys A4EBAC6667697DD2
apt-key del 09617FD37CC06B54
```

## Setup repository

First you have to add the repository to your APT configuration. For easy setup just run in your command line:

```
curl https://dist.crystal-lang.org/apt/setup.sh | sudo bash
```

That will add the signing key and the repository configuration. If you prefer to do it manually, execute the following commands as *root*:

```
apt-key adv --keyserver keys.gnupg.net --recv-keys A4EBAC6667697DD2
echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list
apt-get update
```

## Install
Once the repository is configured you're ready to install Crystal:

```
sudo apt-get install crystal
```

Sometimes [you will need](https://github.com/crystal-lang/crystal/issues/4342) to install the package `build-essential` in order to run/build Crystal programs. You can install it with the command:

```
sudo apt-get install build-essential
```


## Upgrade

When a new Crystal version is released you can upgrade your system using:

```
sudo apt-get update
sudo apt-get install crystal
```

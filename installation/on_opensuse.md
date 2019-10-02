# On OpenSUSE

On OpenSUSE, Crystal can be installed from the official rpm package using Zypper.

## Setup repository

First add the signing key:

```
rpm --import https://dist.crystal-lang.org/rpm/RPM-GPG-KEY
```

Next configure the repository in Zypper:

```
sudo zypper ar -e -f -t rpm-md https://dist.crystal-lang.org/rpm/ Crystal
```

## Install

Once the repository is configured, Crystal can be installed:

```
sudo zypper install crystal
```

## Upgrade

When a new Crystal version is released you can upgrade Crystal using:

```
sudo zypper update crystal
```

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

## Common Installation Issues on Debian Distro
 
* #####Curl command not found
	If curl is not already installed, then you might consider installing it using
```
sudo apt-get install curl
```

* #####The method driver /usr/lib/apt/methods/https could not be found

	Debian package installation mechanism does not support HTTPS for its transport by default.To use HTTPS downloads, we have to install apt-transport-https . You can install the same using the following command:
```
sudo apt-get install apt-transport-https
```

* #####GPG Error that signatures can't be verified. Public key is not available.

	The key to get  repository  is not in your existing list of trusted sources. So when you try to add an external key to the list, some systems might show this issue. Installation would still continue with your permission.

* #####Dirmngr not found

	Dirmngr is used for network access by gpg, gpgsm, and dirmngr-client, among other tools. Unless this package is installed, the parts of the GnuPG suite that try to interact with the network will fail.

	To install dirmngr, execute the following in the terminal
```
sudo apt-get install dirmngr
```

* #####Gpg: keyserver receive failed. Connection refused

	This could either because of poor internet connection or a restriction posed by your server or system administrator. Contact the same to resolve this.



# On macOS using Homebrew

To easily install Crystal on Mac you can use [Homebrew](http://brew.sh/).

```
brew update
brew install crystal
```

## Troubleshooting on OSX 10.11 (El Capitan)

If you get an error like:

```
ld: library not found for -levent
```

you need to reinstall the command line tools and then select the default active toolchain:

```
$ xcode-select --install
$ xcode-select --switch /Library/Developer/CommandLineTools
```

## Troubleshooting on macOS MacOS 10.14.2 (Mojave)

If you get an error like:

```
ld: library not found for -lssl (this usually means you need to install the development package for libssl)
```

you may need to install OpenSSL and link pkg-config to OpenSSL

```
brew install openssl
```

```
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/opt/openssl/lib/pkgconfig
```

```
As with other keg-only formulas there are some caveats shown in brew info <formula> that advertise how to link pkg-config with this library.

Crystal compiler by default will use pkg-config to find the location of libraries to link.
```

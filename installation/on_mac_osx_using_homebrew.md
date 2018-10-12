# On macOS using Homebrew

To easily install Crystal on Mac you can use [Homebrew](http://brew.sh/).

```
brew update
brew install crystal
```

(this might take quite some time ☕️)

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

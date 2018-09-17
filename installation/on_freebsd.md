# On FreeBSD

FreeBSD includes the Crystal compiler in the ports tree, starting from version FreeBSD 11.0.

Currently, it is only available for `aarch64` and `amd64` platforms.

When building Crystal code with the `--release` flag on FreeBSD, the `--no-debug` flag should be added too in order to avoid LLVM assertion errors.

## Install Package

Crystal is available as a compiled package. However, it might not be the most recent version available.

```bash
sudo pkg install -y crystal shards
```

## Install Port

For building Crystal yourself, the required installation is available in the ports tree.

If the ports collection is not already installed, it can be downloaded using `portsnap fetch` or `git clone https://github.com/freebsd/freebsd-ports`.

```bash
sudo make -C/usr/ports/lang/crystal/ reinstall clean
sudo make -C/usr/ports/lang/shards/ reinstall clean
```

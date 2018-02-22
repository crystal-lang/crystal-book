# On FreeBSD

FreeBSD includes the Crystal compiler in the Ports collection.

The package is available for FreeBSD 11.x and 12-CURRENT, on amd64 (64-bit x86) architecture only.

## Install from package

```
su
pkg install crystal shards
```

(You can use e.g. `sudo` or `doas` instead of `su`.)

## Install from source

If you don't have the ports collection downloaded, you need to fetch it using `portsnap` (or svn, or git) to build packages from source.

```
su
make -C/usr/ports/lang/crystal install
make -C/usr/ports/devel/shards install
```

## Install optional dependencies

If you want to use `BigInt` in your Crystal programs:

```
pkg install gmp
```

If you want to use XML in your Crystal programs:

```
pkg install libxml2
```

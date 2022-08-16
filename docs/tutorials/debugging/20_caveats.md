# Caveats

## Segmentation Fault During GC Initialization

It is generally safe to ignore `SIGSEGV` during startup of a Crystal program. This is intended behavior; see the [Debugging](https://hboehm.info/gc/debugging.html) documentation of Crystal's [GC library](https://hboehm.info/gc/).

### Mitigation

Automatically ignore this segmentation fault with breakpoints:

<!-- TODO: GDB mitigation instructions -->

#### LLDB


```
breakpoint set -n main -G true -o true -C 'process handle -s false -n false SIGSEGV SIGBUS'
breakpoint set -n __crystal_main -G true -o true -C 'process handle -s true -n true SIGSEGV SIGBUS'
```

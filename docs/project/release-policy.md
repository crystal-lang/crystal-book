# Release Policy

Crystal releases have a version indicated by a major, minor and patch number.

The current major branch number is `1`.

New features are added in minor releases (`1.x.0`) which are regularly scheduled every three months.

Patch releases contain only important bug fixes and are released when necessary.
They usually only appear for the latest minor branch.

New releases are announced at [crystal-lang.org/releases](https://crystal-lang.org/releases) ([RSS feed](https://crystal-lang.org/releases)).

There are currently no plans for a new major release.

## Backwards compatibility

Minor and patch releases are backwards compatible: Well-defined behaviours and documented APIs in a given version
will continue working on future versions within the same major branch.

As a result, migrating to a new minor release is usually seamless.

### Reservations

Although we expect the vast majority of programs to remain compatible over time,
it is impossible to guarantee that no future change will break any program.
Under some unlikely circumstances, we may introduce changes that break existing code.
Rest assured we are commited to keep the impact as minimal as possible.

* Security: a security issue in the implementation may arise whose resolution requires backwards incompatible changes. We reserve the right to address such security issues.

* Bugs: if an API has undesired behaviour, a program that depends on the buggy behaviour may break if the bug is fixed. We reserve the right to fix such bugs.

* Compiler front-end: improvements may be done to the compiler, introducing new warnings for ambiguous modes and providing more detailed error messages. Those can lead to compilation errors (when building with `--error-on-warnings`) or tooling failures when asserting on specific error messages (although one should avoid such). We reserve the right to do such improvements.

* Feature additions: When introducing new features into the language or core library, there can be collisions with the names of types, methods, etc. defined in user code. We reserve the right to add new names when necessary.

The changelog and release notes highlight any changes that have a considerable potential for breaking existing code, even if it uses experimental, undocumented or unsupported features.

### Experimental features

The only exception to the compatibility guarantees are experimental features, which are explicitly designated as such with the [`@[Experimental]`](https://crystal-lang.org/api/Experimental.html) annotation.
There is no compatibility guarantee until they are stabilized (at which point the annotation is dropped).

# Runtime Tracing

The Crystal runtime has a tracing feature for low level functionality. It prints diagnostic info about runtime internals.

A program must be built with the flag `-Dtracing` to support tracing.
At runtime, the individual tracing components can be enabled via the environment variable `CRYSTAL_TRACE`. It receives a comma separated list of sections to enable.

* `CRYSTAL_TRACE=none` Disable tracing (default)
* `CRYSTAL_TRACE=gc`: Enable tracing for the garbage collector
* `CRYSTAL_TRACE=sched`: Enable tracing for the scheduler
* `CRYSTAL_TRACE=gc,sched`: Enable tracing for the garbage collector and scheduler
* `CRYSTAL_TRACE=all` Enable all tracing (equivalent to `gc,sched`)

Example:

```console
$ crystal build -Dtracing hello-world.cr
$ CRYSTAL_TRACE=sched ./hello-world
sched.spawn 70569399740240 thread=0x7f48d7dc9740:? fiber=0x7f48d7cd0f00:main fiber=0x7f48d7cd0dc0:Signal Loop
sched.enqueue 70569399831716 thread=0x7f48d7dc9740:? fiber=0x7f48d7cd0f00:main fiber=0x7f48d7cd0dc0:Signal Loop duration=163
Hello World
```

The traces are printed to the standard error by default.
This can be changed at runtime with the `CRYSTAL_TRACE_FILE` environment variable.

For example, `CRYSTAL_TRACE_FILE=trace.log` prints all tracing output to a file `trace.log`.

## Tracing Format

Each trace entry stands on a single line, terminated by linefeed, and is at most 512 bytes long.

Each entry starts with an identifier consisting of section and operation names, separated by a dot (e.g. `gc.malloc`).
Then comes a timestamp represented as an integer in nanoseconds.
Finally, a list of metadata properties in the form `key=value` separated by single spaces.

The first two properties are always the originating `thread` and `fiber`. Both are identified by id and name, separated by a colon (e.g `0x7f48d7cd0f00:main`).

* The thread id is the OS handle, so we can match a thread to a debugger session for example.
* The fiber id is an internal address in the Crystal runtime. Names are optional and not necessarily unique.

Trace items from early in the runtime startup may be missing fiber metadata and thread names.

More metadata properties can follow depending on the specific trace entry.

For example, `gc.malloc` indicates how much memory is being allocated.

Reported values are typically represented as integers with the following semantics:

* Times and durations are in nanoseconds as per the monotonic clock of the operating system (e.g. `123` is `123ns`, `5000000000` is `5s`).
* Memory sizes are in bytes (e.g. `1024` is `1KB`).

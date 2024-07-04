# Runtime Tracing

The Crystal runtime has a tracing feature for low level functionality. It prints diagnostic info about runtime internals.

A program must be built with the flag `-Dtracing` to support tracing.
At runtime, the individual tracing components can be enabled via the environment variable `CRYSTAL_TRACE`. It receives a comma separated list of sections to enable.

* `CRYSTAL_TRACE=none` Disable tracing (default)
* `CRYSTAL_TRACE=gc`: Enable tracing for the garbage collector
* `CRYSTAL_TRACE=sched`: Enalbe tracing for the scheduler
* `CRYSTAL_TRACE=gc,sched`: Enable tracing for the garbage collector and scheduler
* `CRYSTAL_TRACE=all` Enable all tracing

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

# Parallelism

Parallelism is the ability to run multiple fibers simultaneously.

In Crystal, a program is concurrent by default, hence runs multiple fibers
sequentially, one at a time. Parallelism is opt‑in and manually enabled by
resizing the default execution context or starting additional contexts.

This guide assumes you are already familiar with the [concurrency
model](./concurrency.md) of Crystal.

## Execution contexts

There are different ways to spread an application to leverage many CPU cores.

- Sometimes we need a fiber to own a thread, notably GUI and game loops.
- Sometimes we need a set of fibers to run concurrently.
- Sometimes we need fibers to autoscale to as many CPU cores as possible.

*Execution Contexts* define how to orchestrate fibers across one or many threads.
Ultimately, we plan to make the interface public, so you may write your own models.

[Execution contexts] are the runtime's building block for orchestrating how a set
of fibers will run through a common interface. Contexts run in parallel of each
other, and each context has its own rules to run fibers.

The overall interface is merely:

1. Start context(s);
2. Spawn fibers inside a specific context ([`context.spawn`][context.spawn]), or into the current
   context ([`spawn`][spawn]);

There are three built‑in execution context types: concurrent, parallel, and
isolated.

### Concurrent

Fibers spawned into a [concurrent context] run concurrently to each other, and
will never run in parallel. Keep in mind that they will run in parallel with
fibers running in other contexts!

A fiber doing CPU heavy computation in a concurrent context will block other
fibers in the same context from progressing, but doesn't impact fibers in
other contexts.

Example:

```cr
ctx = Fiber::ExecutionContext::Concurrent.new("SINGLE")
ctx.spawn { puts "fiber 1" }
ctx.spawn { puts "fiber 2" }
```

Everything stated in the [Concurrency guide](./concurrency.md) is true inside
a concurrent context due to fibers only running sequentially.

### Parallel

Fibers spawned in a [parallel context] run both concurrently and in parallel with
each other (if parallelism is greater than 1), in addition to fibers running in
other contexts.

Parallel contexts auto-scale up to their maximum parallelism. The execution
will remain sequential until there are blocked fibers, which will start more
schedulers (parallelism increases) until they have nothing left to do
(parallelism decreases).

A fiber doing CPU heavy computation in a parallel context won't block other
fibers in the context from progressing.

That said, many simultaneously blocking fibers can reach the maximum parallelism
of the context, and will start blocking other fibers from progressing! We
recommend not creating more blocking fibers than necessary, to use counting
semaphores, and to keep some room for other fibers that still need to run in the
context, or start more contexts.

Example:

```cr
ctx = Fiber::ExecutionContext::Parallel.new("MULTI", maximum: 4)
ctx.spawn { puts "fiber 1" }
ctx.spawn { puts "fiber 2" }
```

You can notice that the interface is almost identical to `Concurrent`. The
only difference is that the `SINGLE` context will have one scheduler that can
run one fiber at a time (parallelism of 1), while `MULTI` will have up to four
schedulers, and is capable to run four fibers at the same time (parallelism of
4).

Everything stated in the [Concurrency guide](./concurrency.md) is true inside
a parallel context, with slight differences in the actual runtime due to
fibers running in parallel to each other.

### Isolated

An [isolated context] spawns a single fiber to a thread. The fiber owns the thread for
its whole lifetime — the thread may be reused after the fiber terminates. The
fiber can block the thread however it wants (it owns it) with no impact on
your application. The OS will preempt the thread as needed.

Example:

```cr
ctx = Fiber::ExecutionContext::Isolated.new("GUI") do
  GUI.blocking_main_loop
end
ctx.wait
```

An isolated context can't spawn more fibers inside the context (by design),
but the fiber can still spawn more fibers into other contexts. Since it can be
complex and cumbersome to retain a reference to a specific context, fibers
will be spawned into the default context or a "spawn context" defined at
creation:

```cr
workers = Fiber::ExecutionContext::Concurrent.new("workers")

main = Fiber::ExecutionContext::Isolated.new("GUI", spawn_context: workers) do
  spawn { puts "running in workers context" }
end

main.wait
```

### Default

All programs run in the [*default* context][ExecutionContext.default], which is a parallel context with a
default parallelism of 1 so it behaves like a concurrent context until programs
opt-in to multithreading at runtime.

Example:

```cr
Fiber::ExecutionContext.default.resize(4)
```

Instead of hardcoding `4` you may use a CLI argument such as `--threads 4` or
default to how many logical CPU the current system has ([`System.cpu_count`][System.cpu_count]).

Once resized to a parallelism greater than 1, the default context will no longer
behave like a concurrent, but be a truly parallel context. Parallelism won't
increase immediately, but will start increasing and decreasing as needed.

Resizing the default context is optional. You may prefer to keep it concurrent
and instead start additional contexts.

### Relationship with system threads

The term "parallelism" doesn't refer to how many system threads have been
started and are currently running, or waiting. The term refers to the maximum
number of fibers that can run Crystal code in parallel. Said differently, there
can only be up to *parallelism* schedulers running, but there can be more
threads.

For example, one thread can be waiting on a blocking system call while the
scheduler continues to run in another thread. Parallelism is still one because
only one fiber is running Crystal code, though there are two system threads.

When the thread waiting on the system call returns, or when an isolated context
terminates, the thread doesn't exit immediately, but enters the thread pool and
suspends itself for a few minutes, after which it will finally exit. During that
time window, the thread may be picked by any execution context to resume a
concurrent or parallel scheduler or to start an isolated context.

> **NOTE:**
> The isolated context owns its system thread for its lifetime only. The thread
> may have been taken from the thread pool and will return to it when the
> context terminates.

These behaviors mean thread locals must be avoided. We cannot recommend enough
to never use the [`@[ThreadLocal]`][ThreadLocal] annotation (stdlib barely does), and to be
very careful when integrating with an external C library, where you may consider
to start an isolated context or to back up and restore the thread local state
around lib calls.

## Thread safety issues

Ideally an application would use communication only (e.g. [`Channel`][Channel]) but
sometimes an application needs global and shared data. The problem is that
accessing, replacing and mutating shared data will corrupt this data in a
parallel environment.

### Shared variables

When we think of shared variables to be protected, we mostly think of globals as
detailed in the next sections, but a simple local variable may be accessed from
multiple fibers, making it a shared variable. For example:

```cr
foo = 1

5.times do
  spawn { p foo }
end
```

The above example is safe because the `foo` variable is first initialized, then
fibers are spawned that only read its value, and the variable is never replaced
nor its value is mutated. The following example, however, will eventually
corrupt the variable's value, because multiple fibers mutate the array, possibly
in parallel:

```cr
foo = [] of Int32

5.times do
  spawn(name: "consumer") do
    loop { p foo.pop? }
  end

  spawn(name: "producer") do
    loop { foo.push(rand(Int32)) }
  end
end
```

Since the `foo` variable is shared, its accesses must be protected.

You can start a concurrent context and spawn the fibers there, so the fibers
will never run in parallel, but you must ensure that there isn't another fiber
that can mutate the array from another context.

You can't parallelize the execution, though, which is likely fine for I/O bound
fibers, but CPU bound fibers would benefit from parallelism. In that case you
may protect the variable with a [`Sync::Exclusive(T)`][Sync::Exclusive(T)] object. I'm using an
exclusive lock rather than a shared lock because we only mutate the array (i.e.
only writes), but if the usage was more towards regular reads and seldom writes,
then a [`Sync::Shared(T)`][Sync::Shared(T)] would be a much more efficient choice.

```cr
foo = [] of Int32

5.times do
  spawn(name: "consumer") do
    loop do
      value = foo.lock &.pop?
      p value
    end
  end

  spawn(name: "producer") do
    loop do
      value = rand(Int32)
      foo.lock &.push(value)
    end
  end
end
```

That being said, the proper solution for a multiple producers and consumers
problem, is to just use a [`Channel`][Channel] instead:

```cr
channel = Channel(Int32).new(16)

5.times do
  spawn(name: "consumer") do
    loop do
      p channel.receive
    end
  end

  spawn(name: "producer") do
    loop do
      channel.send rand(Int32)
    end
  end
end
```

### Constants

Constants are always safely initialized once. You don't have to protect their
initialization. Crystal takes care of that.

Constants can't be replaced after initialization (unique value), but the value
itself can be mutable, for example an `Array` or a `Hash`.

A constant value must either be read-only after its initialization, or be
protected by a [`Sync`][Sync] object, for example [`Sync::Mutex`][Sync::Mutex] or [`Sync::RWLock`][Sync::RWLock].

### Class variables

Class variables are always safely initialized once. You don't have to protect
their initialization. Crystal takes care of that.

Unlike constants, class variables can be replaced by another value at runtime,
and the value itself may be mutable, for example be an `Array` or a `Hash`.

A class variable must either be read-only after its initialization, or be
protected by a [`Sync`][Sync] object, for example [`Sync::Exclusive(T)`][Sync::Exclusive(T)] or
[`Sync::Shared(T)`][Sync::Shared(T)].

If a class variable is larger than a register (e.g. `Int128`), a mixed union
(e.g. `Int32 | Int64 | Nil`) or is a struct with more than one property (or a
property larger than a register), then writing to the class variable must be
protected, otherwise different threads may read incomplete, and thus invalid
values. For example:

```cr
module Foo
  @@bar = Sync::Shared(Int128).new(Int128::MIN)

  spawn { loop { @@bar.set(rand(Int128)) } }
  spawn { loop { puts @@bar.get } }
end
```

## Going further

- The [Concurrency guide](./concurrency.md).
- The [Channel](https://crystal-lang.org/api/Channel.html) type.
- The [Sync](https://crystal-lang.org/api/Sync.html) module.

[Channel]: https://crystal-lang.org/api/Channel.html
[context.spawn]: https://crystal-lang.org/api/Fiber/ExecutionContext.html#spawn(*,name:String|Nil=nil,&block:-%3E):Fiber-instance-method
[ExecutionContext.default]: https://crystal-lang.org/api/Fiber/ExecutionContext.html#default%3AExecutionContext%3A%3AParallel-class-method
[spawn]: https://crystal-lang.org/api/toplevel.html#spawn(*,name:String|Nil=nil,same_thread=false,&block)-class-method
[Sync::Exclusive(T)]: https://crystal-lang.org/api/Sync/Exclusive.html
[Sync::Mutex]: https://crystal-lang.org/api/Sync/Mutex.html
[Sync::RWLock]: https://crystal-lang.org/api/Sync/RWLock.html
[Sync::Shared(T)]: https://crystal-lang.org/api/Sync/Shared.html
[Sync]: https://crystal-lang.org/api/Sync.html
[System.cpu_count]: https://crystal-lang.org/api/System.html#cpu_count:Int32-class-method
[ThreadLocal]: https://crystal-lang.org/api/ThreadLocal.html
[concurrent context]: https://crystal-lang.org/api/Fiber/ExecutionContext/Concurrent.html
[execution contexts]: https://crystal-lang.org/api/Fiber/ExecutionContext.html
[isolated context]: https://crystal-lang.org/api/Fiber/ExecutionContext/Isolated.html
[parallel context]: https://crystal-lang.org/api/Fiber/ExecutionContext/Parallel.html

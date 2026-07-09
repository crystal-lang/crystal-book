# Parallelism

Parallelism in Crystal is the ability to run multiple fibers simultaneously,
multiple fibers at a time, not just sequentially, one fiber at a time.

In Crystal, a program is concurrent by default. Parallelism is opt‑in and
manually enabled by resizing the default execution contexts or starting
additional execution contexts for example.

This guide assumes you are already familiar with the [concurrency
model](./concurrency.md) of Crystal.

## Execution contexts

There are different ways to spread an application to leverage many CPU cores.

* Sometimes we need a fiber to own a thread, notably GUI and game loops.
* Sometimes we need a set of fibers to run concurrently.
* Sometimes we need fibers to autoscale to has many CPU cores as possible.

Hence came **Execution Contexts**. Plural, because there are multiple ways to
orchestrate fibers across one to many threads. Ultimately we plan to make the
interface public, so you may write your own models.

Execution contexts are the runtime's building block for orchestrating how a set
of fibers will run through a common interface. Contexts run in parallel of each
others, and each context has its own rules to run fibers.

The overall interface is merely:

1. Start context(s);
2. Spawn fibers inside a specific context (`context.spawn`), or into the current
   context (`spawn`);

There are three built‑in execution context types: concurrent, parallel, and
isolated.

### Concurrent

Fibers spawned into a concurrent context run concurrently to
each others, and will never run in parallel. Keep in mind that they will run
in parallel to fibers running in other contexts!

A fiber doing CPU heavy computation in a concurrent context will block other
fibers in the same context from progressing, but doesn't impact fibers in
other contexts.

Example:

```
ctx = Fiber::ExecutionContext::Concurrent.new("SINGLE")
ctx.spawn { puts "fiber 1" }
ctx.spawn { puts "fiber 2" }
```

Everything stated in the [Concurrency guide](./concurrency.md) is true inside
a concurrent context dur to fibers only running sequentially.

### Parallel

Fibers spawned in a parallel context run both concurrently and
in parallel to each others (if parallelism is greater than 1), in addition to
fibers running in other contexts.

Parallel contexts auto-scale up to their maximum parallelism. The execution
will remain sequential until there are blocked fibers, which will start more
schedulers (parallelism increases) until they have nothing left to do
(parallelism decreases).

A fiber doing CPU heavy computation in a parallel context won't block other
fibers in the context from progressing.

That being said, many blocking fibers running at the same time can reach the
maximum parallelism of the context, and will start blocking other fibers from
progressing! We recommend to not create more blocking fibers than necessary,
to use counting semaphores, and to keep some room if other fibers must still
run in the context, or to start more contexts.

Example:

```
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
fibers not running sequentially anymore.

### Isolated

Spawn a single fiber to a thread. The fiber owns the thread for
its whole lifetime — the thread may be reused after the fiber terminates. The
fiber can block the thread however it wants (it owns it) with no impact on
your application. The OS will preempt the thread as needed.

Example:

```
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

```
workers = Fiber::ExecutionContext::Concurrent.new("workers")

main = Fiber::ExecutionContext::Isolated.new("GUI", spawn_context: workers) do
  spawn { puts "running in workers context" }
end

main.wait
```

### Default

All programs run in the *default* context, which is a parallel context with a
parallelism of 1 so it behaves as a concurrent context until programs opt-in to
multithreading at runtime.

Example:

```crystal
Fiber::ExecutionContext.default.resize(4)
```

Instead of hardcoding `4` you may use a CLI argument such as `--threads 4` or
default to how many logical CPU the current system has (`System.cpu_count`).

Once resized, the default context

Resizing the default context is optional. You may prefer to keep it concurrent
and instead start additional contexts.

### Relationship with system threads

*TODO: parallelism is num. of schedulers, not num. of system threads*
*TODO: threads can switch contexts (thread pool)*
*TODO: schedulers can jump to another thread during blocking syscalls (except isolated)*
*TODO: warning: be careful with thread locals*

## Perf tools

*TODO: scheduler trace*

## Thread safety issues

Ideally an application would use communication only (e.g. `Channel`) but
sometimes an application needs global and shared data. The problem is that
accessing, replacing and mutating shared data will quickly corrupt this data in
a parallel environment.

### Shared variables

When we think or shared variables to be protected, we mostly think of globals as
detailed in the next sections, but a simple local variable may be accessible
from multiple fibers, making it a shared variable. For example:

```
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

```
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
may protect the variable with a `Sync::Exclusive(T)` object. I'm using an
exclusive lock rather than a shared lock because we only mutate the array (i.e.
only writes), but if the usage was more towards regular reads and seldom writes,
then a `Sync::Shared(T)` would be a much more efficient choice.

```
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

That being said, the proper solution for a multiple producers & consumers
problem, is to just use a `Channel` instead:

```
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
itself can be mutable, for example be an `Array` or a `Hash`.

A constant value must either be read-only after its initialization, or be
protected by a `Sync` object, for example `Sync::Mutex` or `Sync::RWLock`.

### Class variables

Class variables are always safely initialized once. You don't have to protect
their initialization. Crystal takes care of that.

Unlike constants class variables can be replaced by another value at runtime,
and the value itself may be mutable, for example be an `Array` or a `Hash`.

A class variable must either be read-only after its initialization, or be
protected by a `Sync` object, for example `Sync::Exclusive(T)` or
`Sync::Shared(T)`.

If a class variable is larger than a register (e.g. `Int128`), a mixed union
(e.g. `Int32 | Int64 | Nil`) or is a struct with more than one property (or a
property larger than a register), then writing to the class variable must be
protected, otherwise different threads may read incomplete, and thus invalid,
values. For example:

```
module Foo
  @@bar = Sync::Shared(Int128).new(Int128::MIN)

  spawn { loop { @@bar.set(rand(Int128)) } }
  spawn { loop { puts @@bar.get }
end
```

## Going further

* The [Concurrency guide](./concurrency.md).
* The [Channel](https://crystal-lang.org/api/Channel.html) type.
* The [Sync](https://crystal-lang.org/api/Sync.html) module.

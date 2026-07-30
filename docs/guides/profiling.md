# The shard `perf_tools`: profiling memory and fibers

The shard [perf-tools](https://github.com/crystal-lang/perf-tools) contains two handy tools: a memory profiler and a fiber profiler. In order to use it in your project, first add the dependency in the `shards.yml` file (detailed instructions in the readme). Then, follow instructions according to the case.

## Finding leaks with `perf_tools/mem_prof`

We are going to show a set of tools for profiling memory with a little toy example. Say we have an application that first calculates the maximum size of auto-generated strings:

```crystal
def calculate_max
  max = 0
  (1..1000).each do |i|
    s = "crystal" * i
    Logger.log s
    max = s.size if s.size > max
  end
  max
end
```

We note that after calling `calculate_max` the app takes a huge amount of memory. We insert an explicit `GC.collect` but to no avail. We confirm the leak by requiring `perf_tools/mem_prof` and calling it after calculating the max:

```crystal
max = calculate_max
PerfTools::MemProf.pretty_log_allocations(STDOUT)
```

It prints the following table, rendered from its Markdown output:

| Allocations | Total size | Context |
|------------:|-----------:|---------|
| 999 | 3,509,487 | ` src/memory-consuming.cr:19:5 in 'calculate_max' `<br>` src/memory-consuming.cr:30:1 in '__crystal_main' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/main.cr:129:5 in 'main_user_code' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/main.cr:115:7 in 'main' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/main.cr:141:3 in 'main' ` |
|   2 |     8,304 | ` /Users/beta/projects/crystal/crystal/src/array.cr:2100:17 in 'resize_to_capacity' `<br>` /Users/beta/projects/crystal/crystal/src/array.cr:2094:5 in 'increase_capacity' `<br>` /Users/beta/projects/crystal/crystal/src/array.cr:2026:7 in 'check_needs_resize' `<br>` /Users/beta/projects/crystal/crystal/src/array.cr:1363:5 in 'push' `<br>` /Users/beta/projects/crystal/crystal/src/array.cr:401:5 in '<<' ` |
|   1 |     7,013 | ` src/memory-consuming.cr:19:5 in 'calculate_max' `<br>` src/memory-consuming.cr:30:1 in '__crystal_main' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/main.cr:129:5 in 'main_user_code' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/main.cr:115:7 in 'main' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/main.cr:141:3 in 'main' ` |

We see the leak immediately: those 999 allocations. Inspecting the stack trace we note they come from the auto-generated strings. We still don't know who's holding those strings though. So we call another tool, the object size counter:

```crystal
PerfTools::MemProf.log_object_sizes(STDOUT)
```

We obtain the following (trimmed) table:

```text
26
4 (class 94)
216 (class 137)
80 Crystal::SpinLock
16 (class 93)
24 (class 20)
3524852 Array(String)
24 (class 143)
24 (class 163)
...
```

We know now that `Array(String)` is the class with the biggest sum of object sizes. But how many `Array(String)`s are there? We call

```crystal
PerfTools::MemProf.log_object_counts(STDOUT)
```

And obtain (trimmed):

```text
...
1 Hash(String, NamedTuple(time: Time, location: Time::Location))
1 Array(String)
```

So just one array is holding all the `String` references! Looking at the stack traces from the first table, we see that indeed there is an operation on an array taking some size. But the stack is not enough to inform us where is it coming from, so we expand the number of stack traces to include and print the table again. One option is to re-run the application with the environment variable `MEMPROF_STACK_DEPTH` set to a higher value (default is 5).

Looking at that specific line we note that now it's blaming the `log` method.

` /Users/beta/projects/crystal/crystal/src/array.cr:2100:17 in 'resize_to_capacity' `<br>` /Users/beta/projects/crystal/crystal/src/array.cr:2094:5 in 'increase_capacity' `<br>` /Users/beta/projects/crystal/crystal/src/array.cr:2026:7 in 'check_needs_resize' `<br>` /Users/beta/projects/crystal/crystal/src/array.cr:1363:5 in 'push' `<br>` /Users/beta/projects/crystal/crystal/src/array.cr:401:5 in '<<' `<br>` src/memory-consuming.cr:12:5 in 'log' `<br>` src/memory-consuming.cr:7:3 in 'log' `

Aha! The person that added the logging didn't know Crystal comes with its own [logging framework](https://crystal-lang.org/api/Log.html), and created a leaky one!

```crystal
class Logger
  @@values = Array(String).new

  def self.log(what : String, print = false)
    puts what if print
    @@values << what
  end
end
```

The `MemProf` tool can be tweaked with other parameters as well, such as how many stack traces to skip, which size to start considering allocations from, and more.

## Profiling fibers with `fiber_trace`

Another useful little tool helps us track fibers. In a program having several fibers, this tool allow us to show fibers that might be idly waiting for some resource that would never be available.

For instance, let's say we have a program to remove concurrently elements from an array `values` (note: for this example we're assuming no multi-threading). We add some random waiting just to make results unpredictable, and we add one fiber that will get stuck.

```crystal
values.each do |i|
  spawn name: "Worker #{i}" do
    sleep (rand 5000).milliseconds
    if i == 5
      while true
        Fiber.yield
      end
    end
    values.delete i
  end
end

# we wait until all of the values are removed
while values.size > 0
  Fiber.yield
end
```

If we run this program, giving some array of numbers as `values`, it will naturally get stuck at some point. We can then add a little helper fiber to print the fibers that are running, until finding the one that's stuck.

```crystal
spawn name: "Fiber Tracer" do
  while true
    puts "\x1b[2J" # clears the screen
    PerfTools::FiberTrace.pretty_log_fibers(STDOUT)
    sleep 500.milliseconds
  end
end
```

After running for a while, we see the number of fibers downing until it stabilizes. We see listed Crystal's own fibers (`Fiber Clean loop` and `Signal Loop`), the `Fiber Tracer` fiber we created, and the leaking one (`Worker 5`):

| Count | Fibers | Spawn stack | Yield stack |
|------:|:-------|:------------|:------------|
| 1 | ` Fiber Clean Loop ` | ` /Users/beta/projects/crystal/crystal/src/kernel.cr:552:1 in '__crystal_main' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/main.cr:115:5 in 'main_user_code' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/main.cr:101:7 in 'main' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/main.cr:127:3 in 'main' `<br>` /usr/lib/dyld in 'start' ` | ` /Users/beta/projects/crystal/crystal/src/crystal/scheduler.cr:174:5 in 'sleep' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/scheduler.cr:58:5 in 'sleep' `<br>` /Users/beta/projects/crystal/crystal/src/concurrent.cr:14:3 in 'sleep' `<br>` /Users/beta/projects/crystal/crystal/src/kernel.cr:552:1 in '->' `<br>` lib/perf_tools/src/perf_tools/fiber_trace.cr:193:3 in 'run' ` |
| 1 | ` Worker 5 ` | ` src/bad-fibers.cr:6:3 in '__crystal_main' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/main.cr:115:5 in 'main_user_code' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/main.cr:101:7 in 'main' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/main.cr:127:3 in 'main' `<br>` /usr/lib/dyld in 'start' ` | ` /Users/beta/projects/crystal/crystal/src/crystal/scheduler.cr:174:5 in 'sleep' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/scheduler.cr:179:5 in 'yield' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/scheduler.cr:62:5 in 'yield' `<br>` /Users/beta/projects/crystal/crystal/src/fiber.cr:287:5 in 'yield' `<br>` src/bad-fibers.cr:10:9 in '->' ` |
| 1 | ` Logger ` | ` src/bad-fibers.cr:17:1 in '__crystal_main' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/main.cr:115:5 in 'main_user_code' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/main.cr:101:7 in 'main' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/main.cr:127:3 in 'main' `<br>` /usr/lib/dyld in 'start' ` | ` /Users/beta/projects/crystal/crystal/src/crystal/scheduler.cr:174:5 in 'sleep' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/scheduler.cr:58:5 in 'sleep' `<br>` /Users/beta/projects/crystal/crystal/src/concurrent.cr:22:3 in 'sleep' `<br>` src/bad-fibers.cr:21:5 in '->' `<br>` lib/perf_tools/src/perf_tools/fiber_trace.cr:193:3 in 'run' ` |
| 1 | ` Signal Loop ` | ` /Users/beta/projects/crystal/crystal/src/crystal/system/unix/signal.cr:60:5 in 'start_loop' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/system/unix/signal.cr:163:5 in 'setup_default_handlers' `<br>` /Users/beta/projects/crystal/crystal/src/kernel.cr:552:1 in '__crystal_main' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/main.cr:115:5 in 'main_user_code' `<br>` /Users/beta/projects/crystal/crystal/src/crystal/main.cr:101:7 in 'main' ` | ` /Users/beta/projects/crystal/crystal/src/crystal/scheduler.cr:50:5 in 'reschedule' `<br>` /Users/beta/projects/crystal/crystal/src/io/evented.cr:128:5 in 'wait_readable' `<br>` /Users/beta/projects/crystal/crystal/src/io/evented.cr:119:3 in 'wait_readable' `<br>` /Users/beta/projects/crystal/crystal/src/io/evented.cr:59:9 in 'unbuffered_read' `<br>` /Users/beta/projects/crystal/crystal/src/io/buffered.cr:261:5 in 'fill_buffer' ` |

We can see in the `Yield stack` column the place at which the fiber yielded control to the scheduler. In `Worker 5` the stack trace points at the `Fiber.yield` within the loop.

As with `MemProf`, we can tweak the stack trace to present relevant data.

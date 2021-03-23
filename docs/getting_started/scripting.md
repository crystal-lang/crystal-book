# Scripting with Crystal

## Cacheless
```
#!/usr/bin/env crystal

puts "Hello CRYSTAL"
```

## Cached compilations
This can be achieved using third-party tools such as [scriptisto](https://github.com/igor-petruk/scriptisto).

```
#!/usr/bin/env scriptisto

# scriptisto-begin
# script_src: src/main.cr
# build_cmd: crystal build src/main.cr --release -o output_binary
# target_bin: output_binary
# scriptisto-end

puts "Hello CRYSTAL"
```

## Benchmarks

```
hyperfine --warmup 3 --export-markdown /dev/stdin './script.cr' './scriptisto.cr'
```

| Command | Mean [s] | Min [s] | Max [s] | Relative |
|:---|---:|---:|---:|---:|
| `./script.cr` | 1.196 ± 0.034 | 1.148 | 1.248 | 95.01 ± 17.95 |
| `./scriptisto.cr` | 0.013 ± 0.002 | 0.010 | 0.028 | 1.00 |

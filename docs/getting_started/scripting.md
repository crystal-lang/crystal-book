# Scripting with Crystal (Shebang Lines)

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
crystal build script.cr -o compiled_binary --release

hyperfine --warmup 3 --export-markdown /dev/stdin './script.cr' './scriptisto.cr' 'compiled_binary'
```

| Command | Mean [s] | Min [s] | Max [s] | Relative |
|:---|---:|---:|---:|---:|
| `./script.cr` | 1.228 ± 0.075 | 1.177 | 1.430 | 535.24 ± 406.84 |
| `./scriptisto.cr` | 0.010 ± 0.002 | 0.008 | 0.022 | 4.34 ± 3.37 |
| `./compiled_binary` | 0.002 ± 0.002 | 0.000 | 0.015 | 1.00 |

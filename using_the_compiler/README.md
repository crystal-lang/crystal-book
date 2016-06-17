# 使用編譯器

一旦我們[安裝](../installation/README.md)了編譯器之後，我們就有了 `crystal` 執行檔可以使用。

在接下來的內容裡，金錢符號（`$`）會被用來表示命令列。

## 編譯並執行

想要編譯並且直接執行程式，我們可以執行 `crystal` 並在後面加上檔案名稱：

```
$ crystal some_program.cr
```

Crystal 檔案以 `.cr` 作為副檔名。

我們也可以使用 `run`：

```
$ crystal run some_program.cr
```

## 產生執行檔

使用 `compile` 命令來產生一個執行檔：

```
$ crystal compile some_program.cr
```

這會產生一個可供執行的 `some_program` 檔案：

```
$ ./some_program
```

**注意：** 在預設情況下產生的執行檔**並沒有被完全優化**。我們可以使用 `--release` 參數來啟用優化功能：

```
$ crystal compile some_program.cr --release
```

請確保在每次編譯發行版本<small>(Production-ready)</small>的執行檔或是用來評比效能<small>(Benchmarks)</small>時都使用 `--release`。

要這麼做的原因是就算沒有進行完全優化，它的表現還是非常好而且編譯的速度會比較快，讓我們可以像使用直譯器一樣使用 `crystal` 命令。

## 產生一個專案或函式庫

使用 `init` 命令來產生一個擁有標準目錄結構的 Crystal 專案。

```
$ crystal init lib MyCoolLib
      create  MyCoolLib/.gitignore
      create  MyCoolLib/LICENSE
      create  MyCoolLib/README.md
      create  MyCoolLib/.travis.yml
      create  MyCoolLib/shard.yml
      create  MyCoolLib/src/MyCoolLib.cr
      create  MyCoolLib/src/MyCoolLib/version.cr
      create  MyCoolLib/spec/spec_helper.cr
      create  MyCoolLib/spec/MyCoolLib_spec.cr
Initialized empty Git repository in ~/MyCoolLib/.git/
```

## 其他命令及選項

輸入 `crystal` 並且不加上任何參數來瀏覽所有可用的命令：

```
$ crystal
Usage: crystal [command] [switches] [program file] [--] [arguments]

Command:
    init                     generate a new project
    compile                  compile program
    deps                     install project dependencies
    docs                     generate documentation
    env                      print Crystal environment information
    eval                     eval code from args or standard input
    play                     starts crystal playground server
    run (default)            compile and run program
    spec                     compile and run specs (in spec directory)
    tool                     run a tool
    help, --help, -h         show this help
    version, --version, -v   show version
```

在命令後使用 `--help` 來查看該命令所有可用的選項：

```
$ crystal compile --help
Usage: crystal compile [options] [programfile] [--] [arguments]

Options:
    --cross-compile                  cross-compile
    -d, --debug                      Add symbolic debug info
    -D FLAG, --define FLAG           Define a compile-time flag
    --emit [asm|llvm-bc|llvm-ir|obj] Comma separated list of types of output for the compiler to emit
    -f text|json, --format text|json Output format text (default) or json
    -h, --help                       Show this message
    --ll                             Dump ll to .crystal directory
    --link-flags FLAGS               Additional flags to pass to the linker
    --mcpu CPU                       Target specific cpu type
    --no-color                       Disable colored output
    --no-codegen                     Don't do code generation
    -o                               Output filename
    --prelude                        Use given file as prelude
    --release                        Compile in release mode
    -s, --stats                      Enable statistics output
    --single-module                  Generate a single LLVM module
    --threads                        Maximum number of threads to use
    --target TRIPLE                  Target triple
    --verbose                        Display executed commands
```

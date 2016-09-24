# 使用編譯器

一旦你 [安裝](../installation/README.md) 了編譯器你就有了個 `crystal` 二進位檔在你的配置當中。

在接下來的部分，錢字號 (`$`) 表示命令列。

## 編譯並執行

想要編譯並且直接執行程式你可以執行 `crystal` 並在後面加上檔案名稱:


```
$ crystal some_program.cr
```

Crystal 檔案以 `.cr` 作為副檔名。

你也可以使用 `run` :

```
$ crystal run some_program.cr
```

## 產生一個執行檔

使用 `build` 命令產生一個執行檔:

```
$ crystal build some_program.cr
```

這會產生一個可供執行的 `some_program` 檔案:

```
$ ./some_program
```

**注意 :** 在預設情況下產生的執行檔 **並沒有被完全優化**。 使用 `--release` 參數來啟用優化功能:

```
$ crystal build some_program.cr --release
```

確保在編譯準備發行( production-ready )的執行檔及評效( benchmarks )時每次都有使用 `--release`。

這麼做的原因是因為就算沒有完全優化，它的表現還是非常好而且編譯的較快，所以你可以像使用直譯器一樣使用 `crystal` 命令。

## 產生一個專案或是函式庫


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

輸入  `crystal` 並且不加上任何參數來瀏覽所有可用的命令:

```
$ crystal
Usage: crystal [command] [switches] [program file] [--] [arguments]

Command:
    init                     generate new crystal project
    build                    compile program file
    deps                     install project dependencies
    docs                     generate documentation
    eval                     eval code from args or standard input
    run (default)            compile and run program file
    spec                     compile and run specs (in spec directory)
    tool                     run a tool
    --help, -h               show this help
    --version, -v            show version
```

在命令後使用 `--help` 來查看該命令所有可用的選項:

```
$ crystal build --help
Usage: crystal build [options] [programfile] [--] [arguments]

Options:
    --cross-compile flags            cross-compile
    -d, --debug                      Add symbolic debug info
    -D FLAG, --define FLAG           Define a compile-time flag
    --emit [asm|llvm-bc|llvm-ir|obj] Comma separated list of types of output for the compiler to emit
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

# asm

The `asm` keyword can be used to insert inline assembly, which is needed for a very small set of features such as fiber switching and system calls:

```crystal
# x86-64 targets only
dst = 0
asm("mov $$1234, $0" : "=r"(dst))
dst # => 1234
```

An `asm` expression consists of up to 5 colon-separated sections, and components inside each section are separated by commas. For example:

```crystal
asm(
  # the assembly template string, following the
  # syntax for LLVM's integrated assembler
  "nop" :
  # output operands
  "=r"(foo), "=r"(bar) :
  # input operands
  "r"(1), "r"(baz) :
  # names of clobbered registers
  "eax", "memory" :
  # optional flags, corresponding to the LLVM IR
  # sideeffect / alignstack / inteldialect / unwind attributes
  "volatile", "alignstack", "intel", "unwind"
)
```

Only the template string is mandatory, all other sections can be empty or omitted:

```crystal
asm("nop")
asm("nop" :: "b"(1), "c"(2)) # output operands are empty
```

For more details, refer to the [LLVM documentation's section on inline assembler expressions](https://llvm.org/docs/LangRef.html#inline-assembler-expressions).

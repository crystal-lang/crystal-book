# 正規表示式 (Regex)

正規表示式（[Regex](http://crystal-lang.org/api/Regex.html)）通常可以用以下方式表達：

```crystal
foo_or_bar = /foo|bar/
heeello    = /h(e+)llo/
integer    = /\d+/
```

正規表示式的常值以 `/` 標示，且使用 [PCRE](http://pcre.org/pcre.txt) 語法。

此外，還可以使用以下的模式修飾字：

* i: 忽略大小寫 (PCRE_CASELESS)
* m: 多行比對 (PCRE_MULTILINE)
* x: PCRE 擴充模式 (PCRE_EXTENDED)

例如：

```crystal
r = /foo/imx
```

若要在正規表示式中描述斜線(`/`)，則需以跳脫表達：

```crystal
slash = /\//
```

或使用以下的語法：

```crystal
r = %r(regex with slash: /)
```

# HTTP Server

一個更有趣的例子是  HTTP Server :

```crystal
require "http/server"

server = HTTP::Server.new(8080) do |context|
  context.response.content_type = "text/plain"
  context.response.print "Hello world! The time is #{Time.now}"
end

puts "Listening on http://0.0.0.0:8080"
server.listen
```


在讀完整份文件後就能理解上述的程式碼了，但是我們能夠發現一些事情。

* 你可以 [包含(require)](../syntax_and_semantics/requiring_files.html)   其他文件裡面的程式碼:

    ```
    require "http/server"
    ```

* 你可以定義 [區域變數](../syntax_and_semantics/local_variables.html) 而且不需要指定型態:

    ```
    server = HTTP::Server.new ...
    ```


* 你可以呼叫物件的[方法](../syntax_and_semantics/classes_and_methods.html) ( 或傳送訊息 )來撰寫程式:

    ```
    HTTP::Server.new(8000) ...
    ...
    Time.now
    ...
    puts "Listening on http://0.0.0.0:8080"
    ...
    server.listen
    ```

* 你可以使用[區塊碼( blocks )](../syntax_and_semantics/blocks_and_procs.html)，而這是個重複利用程式碼的好方法也是函式化的特色之一。

    ```ruby
    HTTP::Server.new(8080) do |context|
      ...
    end
    ```


* 你可以用嵌入的方式簡單的產生一個字串，稱作字串內插( string interpolation )。同時 Crystal 也能使用其他 [語法](../syntax_and_semantics/literals.html) 來產生陣列、雜湊( hash )、範圍類別( range )、元組( tuple ) 等等 :

    ```
    "Hello world! The time is #{Time.now}"
    ```



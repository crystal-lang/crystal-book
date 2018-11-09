# HTTP 伺服器

一個更有趣的例子是 HTTP 伺服器：

```crystal
require "http/server"

server = HTTP::Server.new do |context|
  context.response.content_type = "text/plain"
  context.response.print "Hello world! The time is #{Time.now}"
end

address = server.bind_tcp 8080
puts "Listening on http://#{address}"
server.listen
```

在讀完整份文件後就能理解上述的程式碼了，但是我們能夠發現一些事情。

* 我們可以[引入 (Require)](../syntax_and_semantics/requiring_files.md)其他文件裡面的程式碼：

    ```crystal
    require "http/server"
    ```

* 我們可以定義[區域變數](../syntax_and_semantics/local_variables.md)而且還不需要指定型態：

    ```crystal
    server = HTTP::Server.new ...
    ```

* 我們可以透過 `HTTP::Server` 提供的 `bind_tcp` 方法來指定 HTTP 伺服器的埠號：

    ```crystal
    address = server.bind_tcp 8080
    ```

* 我們可以透過呼叫物件的[方法](../syntax_and_semantics/classes_and_methods.md)（或傳送訊息）來撰寫程式：

    ```crystal
    HTTP::Server.new ...
    ...
    Time.now
    ...
    address = server.bind_tcp 8080
    ...
    puts "Listening on http://#{address}"
    ...
    server.listen
    ```

* 我們還可以使用[程式區塊 (Blocks)](../syntax_and_semantics/blocks_and_procs.md)，這是個重複利用程式碼的好方法，同時也可以用來模仿函數程式設計的特性。

    ```crystal
    HTTP::Server.new do |context|
      ...
    end
    ```

* 我們可以輕鬆地建立並嵌入內容到一個字串，稱作字串內插<small>(String interpolation)</small>：

    ```crystal
    "Hello world! The time is #{Time.now}"
    ``` 

    同時 Crystal 也能使用其他[語法](../syntax_and_semantics/literals.md)來產生陣列、雜湊<small>(Hash)</small>、範圍<small>(Range)</small>、序組<small>(Tuple)</small>……等物件。

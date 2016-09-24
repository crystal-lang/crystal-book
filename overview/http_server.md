# HTTP 伺服器

一個更有趣的例子是 HTTP 伺服器：

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

* 我們可以[引入 (Require)](../syntax_and_semantics/requiring_files.md)其他文件裡面的程式碼：

    ```
    require "http/server"
    ```

* 我們可以定義[區域變數](../syntax_and_semantics/local_variables.md)而且還不需要指定型態：

    ```
    server = HTTP::Server.new ...
    ```

* 我們可以透過呼叫物件的[方法](../syntax_and_semantics/classes_and_methods.md)（或傳送訊息）來撰寫程式：
    ```ruby
    HTTP::Server.new(8080) ...
    ...
    Time.now
    ...
    puts "Listening on http://0.0.0.0:8080"
    ...
    server.listen
    ```

* 我們還可以使用[程式區塊 (Blocks)](../syntax_and_semantics/blocks_and_procs.md)，這是個重複利用程式碼的好方法，同時也可以用來模仿函數程式設計的特性。

    ```ruby
    HTTP::Server.new(8080) do |context|
      ...
    end
    ```

* 我們可以輕鬆地建立並嵌入內容到一個字串，稱作字串內插<small>(String interpolation)</small>。同時 Crystal 也能使用其他[語法](../syntax_and_semantics/literals.md)來產生陣列、雜湊<small>(Hash)</small>、範圍<small>(Range)</small>、序組<small>(Tuple)</small>……等：

    ```
    "Hello world! The time is #{Time.now}"
    ```


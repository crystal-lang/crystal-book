# HTTP Server

A slightly more interesting example is an HTTP Server:

```crystal
require "http/server"

server = HTTP::Server.new do |context|
  context.response.content_type = "text/plain"
  context.response.print "Hello world! The time is #{Time.local}"
end

address = server.bind_tcp 8080
puts "Listening on http://#{address}"
server.listen
```

The above code will make sense once you read the whole language reference, but we can already learn some things.

* You can [require](../../syntax_and_semantics/requiring_files.html) code defined in other files:

    ```crystal
    require "http/server"
    ```
* You can define [local variables](../../syntax_and_semantics/local_variables.html) without the need to specify their type:

    ```crystal
    server = HTTP::Server.new ...
    ```
* The port of the HTTP server is set by using the method bind_tcp on the object HTTP::Server (the port set to 8080).
    ```crystal
    address = server.bind_tcp 8080
    ```


* You program by invoking [methods](../../syntax_and_semantics/classes_and_methods.html) (or sending messages) to objects.

    ```crystal
    HTTP::Server.new ...
    ...
    Time.local
    ...
    address = server.bind_tcp 8080
    ...
    puts "Listening on http://#{address}"
    ...
    server.listen
    ```

* You can use code blocks, or simply [blocks](../../syntax_and_semantics/blocks_and_procs.html), which are a very convenient way to reuse code and get some features from the functional world:

    ```crystal
    HTTP::Server.new do |context|
      ...
    end
    ```

* You can easily create strings with embedded content, known as string interpolation. The language comes with other [syntax](../../syntax_and_semantics/literals.html) as well to create arrays, hashes, ranges, tuples and more:

    ```crystal
    "Hello world! The time is #{Time.local}"
    ```

# Shipping

_Ahoy, matey!_
Oh! you've built the greatest app ever and, of course, using Crystal!!
And now you want to share it with the whole world?!

Well, it’s your lucky ~~pirate~~ day because we are going to ship our first Crystal application!!

So, _weigh anchor and hoist the mizzen! Yarr!_

## The App

The application we are shipping is an example of a static file sharing server. Here’s the source code:

```crystal
# staticserver.cr
require "http"
require "option_parser"

# Handle Ctrl+C and kill signal.
# Needed for hosting this process in a docker
# as the entry point command
Signal::INT.trap { puts "Caught Ctrl+C..."; exit }
Signal::TERM.trap { puts "Caught kill..."; exit }

path = "/www"
port = 80

option_parser = OptionParser.parse do |parser|
 parser.on "-f PATH", "--files=PATH", "Files path (default: /www)" do |files_path|
   path = files_path
 end
 parser.on "-p PORT", "--port=PORT", "Port to listen (default: 80)" do |server_port|
   port = server_port.to_i
 end
end

server = HTTP::Server.new([
 HTTP::LogHandler.new,
 HTTP::ErrorHandler.new,
 HTTP::StaticFileHandler.new(path),
])

address = server.bind_tcp "0.0.0.0", port
puts "Listening on http://#{address} and serving files in path #{path}"
server.listen
```

So, starting the server (listening on port 8080 and serving files under the current directory) is as easy as running:

```shell-session
$ crystal ./src/staticserver.cr -- -p 8080 -f .
Listening on http://0.0.0.0:8080 and serving files in path .
```

**Note:** the default behavior is to listen on `port 80` and serve the folder `/www`.

## Compiling our application

Let’s go over Crystal’s [introduction](https://crystal-lang.org/reference/). One of the  main goals of the language is to _Compile to efficient native code_. That means that each time that we compile our code then an executable is built, but with an important property: it has a target platform (architecture and operating system), which is where the application will run. Crystal knows the target platform because is the same as the one being used to compile.
For example, if we use a Linux OS based computer for compiling, then the executable will be meant to run on a Linux OS (and in some cases we will need to use the same Linux distribution).

Can we set the target when calling the compiler? Oh, that’s a great idea, but for now it’s not an option (there are a lot of great buccanears [working on a solution](https://forum.crystal-lang.org/t/cross-compiling-automatically-to-osx/1330/12) and remember that Crystal is open source: so you are welcome aboard!)

Let’s compile our application:

```shell-session
$ shards build --production
Dependencies are satisfied
Building: staticserver
```

and now, if we want to know the file type:

If we are using Mac OS, we will see something like this:

```shell-session
$ file bin/staticserver
bin/staticserver: Mach-O 64-bit executable x86_64
```

And if we are using a Linux distribution, for example Ubuntu:

```shell-session
$ file bin/staticserver
bin/staticserver: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/l, for GNU/Linux 2.6.32, BuildID[sha1]=a78ffe59325c3f9668d551852e7717e3996edb3b, not stripped
```


Furthermore, our application may use some libraries (our application’s dependencies!) and so the target platform should have this libraries installed. To list the libraries used by our application:

On Mac OS:

```shell-session
$ otool -L ./bin/staticserver
./bin/staticserver:
 /usr/lib/libz.1.dylib (compatibility version 1.0.0, current version 1.2.11)
 /usr/local/opt/openssl/lib/libssl.1.0.0.dylib (compatibility version 1.0.0, current version 1.0.0)
 /usr/local/opt/openssl/lib/libcrypto.1.0.0.dylib (compatibility version 1.0.0, current version 1.0.0)
 /usr/lib/libpcre.0.dylib (compatibility version 1.0.0, current version 1.1.0)
 /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1252.250.1)
 /usr/local/opt/libevent/lib/libevent-2.1.7.dylib (compatibility version 8.0.0, current version 8.0.0)
 /usr/lib/libiconv.2.dylib (compatibility version 7.0.0, current version 7.0.0)
```

On a Linux OS we may use `ldd bin/staticserver` with a similar result.

Up to this point, we know that for shipping our application, we need to compile for each target platform where we want our application to run; and also, we need to provide the dependencies used by our application.

Here we will see two ways for shipping our application:

* Using a [Docker](https://www.docker.com/get-started) image.
* Using a [Snapcraft](https://snapcraft.io/build) package.


## Shipping with Docker

The idea behind using Docker is to create a Docker container, with a target platform, and use it for building our application and then create a really small image for shipping and running our application!

Wow! I want to [embark on this adventure](./shipping/docker.html)!

## Shipping with Snapcraft

The idea behind using Snapcraft is to use this tool for building an executable targeting the Linux OS and then publishing it!

Oh great! Let’s follow [this sea lane](./shipping/snapcraft.html)!

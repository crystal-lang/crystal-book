# Coding Style

This style is used in the standard library. You can use it in your own project to make it familiar to other developers.

## Naming

**Type names** are PascalCased. For example:

```crystal
class ParseError < Exception
end

module HTTP
  class RequestHandler
  end
end

alias NumericValue = Float32 | Float64 | Int32 | Int64

lib LibYAML
end

struct TagDirective
end

enum Time::DayOfWeek
end
```

**Method names** are snake_cased. For example:

```crystal
class Person
  def first_name
  end

  def date_of_birth
  end

  def homepage_url
  end
end
```

**Variable names** are snake_cased. For example:

```crystal
class Greeting
  @@default_greeting = "Hello world"

  def initialize(@custom_greeting = nil)
  end

  def print_greeting
    greeting = @custom_greeting || @@default_greeting
    puts greeting
  end
end
```

**Constants** are SCREAMING_SNAKE_CASED. For example:

```crystal
LUCKY_NUMBERS     = [3, 7, 11]
DOCUMENTATION_URL = "http://crystal-lang.org/docs"
```

### Acronyms

In class names, acronyms are *all-uppercase*. For example, `HTTP`, and `LibXML`.

In method names, acronyms are *all-lowercase*. For example `#from_json`, `#to_io`.

### Libs

`Lib` names are prefixed with `Lib`. For example: `LibC`, `LibEvent2`.

### Directory and File Names

Within a project:

* `/` contains a readme, any project configurations (eg, CI or editor configs), and any other project-level documentation (eg, changelog or contributing guide).
* `src/` contains the project's source code.
* `spec/` contains the [project's specs](../guides/testing.md), which can be run with `crystal spec`.
* `bin/` contains any executables.

File paths match the namespace of their contents. Files are named after the class or namespace they define, with *snake_case*.

For example, `HTTP::WebSocket` is defined in `src/http/web_socket.cr`.

## Indentation

Use **two spaces** to indent code inside namespaces, methods, blocks or other nested contexts. For example:

```crystal
module Scorecard
  class Parser
    def parse(score_text)
      begin
        score_text.scan(SCORE_PATTERN) do |match|
          handle_match(match)
        end
      rescue err : ParseError
        # handle error ...
      end
    end
  end
end
```

Within a class, separate method definitions, constants and inner class definitions with **one newline**. For example:

```crystal
module Money
  CURRENCIES = {
    "EUR" => 1.0,
    "ARS" => 10.55,
    "USD" => 1.12,
    "JPY" => 134.15,
  }

  class Amount
    getter :currency, :value

    def initialize(@currency, @value)
    end
  end

  class CurrencyConversion
    def initialize(@amount, @target_currency)
    end

    def amount
      # implement conversion ...
    end
  end
end
```

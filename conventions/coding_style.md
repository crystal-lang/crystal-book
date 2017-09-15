# Coding Style
Ce type de style est utilise dans la librairie standard.  Vous pouvez l'utiliser sur vos propre projet, pour qu'il soit famillier aux autres developpeurs.

## Nommage
camelcased: Cela consiste à écrire un ensemble de mots en les liant sans espace ni ponctuation, 
et en mettant en majuscule la première lettre de chaque mot ou chaque mot excepté le premier

__Type de nom__ sont camelcased. Par exemple:

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
__Les noms des methodes sont avec le tiret du bas. Par exemple:

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
__Variable de nom sont avec le tiret du bas. Par exemple:

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
__Les variables constants__sont en majuscule. Par exemple:

```crystal
LUCKY_NUMBERS     = [3, 7, 11]
DOCUMENTATION_URL = "http://crystal-lang.org/docs"
```

### Acronyme

Les noms des classes, sont tous en majuscules. Par exemple `HTTP`, et `LibXML`.

Les noms des méthodes, sont tous en minuscule. Par exemple `#from_json`,  `#to_io`.


### Libs

`Lib` Les noms sont préfixes avec `Lib`. Par exemple: `LibC`, `LibEvent2`.

### Répertoire et nom de fichier 

Dans un projet:

- `/`     il contient le Readme, ainsi que toutes les configurations des projets (ex, CI ou les config des editeurs, et tous les autres niveaux de projet de documentations (ex, changelog ou le guide de contribution)            
- `src/`  Contient le code source du projet.
- `spec/` Contient les specs du projet,ce qui peut être lancé avec `crystal spec`.
- `bin/`  Contient tous les exécutables.

Les espace de nom des fichiers correspondant à leurs contenus. Les fichiers sont nommés apres que la classe ou que le namespace soit défini avec le _tiret-du-bas_

For example, `HTTP::WebSocket` is defined in `src/http/web_socket.cr`.

## Espace blanc

Utiliser __deux espaces__ pour indenter le code a l'intérieur des namespaces, méthodes, bloc ou tous autres contenus imbriqués. Par exemple :
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
Dans une classe, séparer les méthodes définis, constantes et interne a la definition de classe avec __une nouvelle ligne__. Par exemple :

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
      # implémentation de la conversion ...
    end
  end
end
```

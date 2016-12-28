# Working with Strings

```crystal
"abcd" # => "abcd" : String

# Access a part of a string
"abcd"[1..2] # => "bc" : String

# Start at a position and continue for X characters
"abcd"[2,2] # => "cd" : String

# Concatenate strings
"abcd" + "e" # => "abcde"

# Regex Match (will be evaluated as truthy in a conditional statement if a match is found)
"abcd".match(/b/) # => #<Regex::MatchData "b"> : (Regex::MatchData | Nil)

# a single replacement or "substitution"
"wow".sub("w", "m") # => "mow"

# a global replacement or "substitution" (hence gsub)
"wow".gsub("w", "m") # => "mom"

# global substitution with regex
"how now brown cow".gsub(/w/, "www") # => "howww nowww browwwn cowww"
```

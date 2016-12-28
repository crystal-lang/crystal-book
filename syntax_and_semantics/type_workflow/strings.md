# Working with Strings

```crystal
"abcd" # => "abcd" : String

# Access a part of a string
"abcd"[1..2] # => "bc" : String

# Start at a position and continue for X characters
"abcd"[2,2] # => "cd" : String

# Concatenate strings
"abcd" + "e" # => "abcde"

# 
"abcd".match(/b/) # => #<Regex::MatchData "b"> : (Regex::MatchData | Nil)
# Will be evaluated as truthy in a conditional statement

# Multiple replacements with regex
"how now brown cow".gsub(/w/, "www") # => "howww nowww browwwn cowww"
```

# Collections

Collections of objects, such as [Array](https://crystal-lang.org/api/Array.html), [Hash](https://crystal-lang.org/api/Hash.html), and [Set](https://crystal-lang.org/api/Set.html) are powerful data structures for storing groups of data. Crystal offers a number of Modules to assist developers working with collections of objects in the Standard Library. 


```
arr = Array(String).new
arr << "Foo"
arr << "Bar"
arr << "Baz"
arr << "Foo"
 
arr.size # returns 4
arr.empty? # returns false

arr.count "Foo" # returns 2
arr.count "Nope" # returns 0

arr.index { |i| i == "Baz" } # returns 1
arr.index { |i| i == "Nope" } # returns 

arr.find { |i| i == "Foo" } # return "Foo"
arr.find { |i| i == "Nope" } # return nil

```

For full details, see the [Indexable](https://crystal-lang.org/api/Indexable.html), [Enumerable]((https://crystal-lang.org/api/Enumerable.html), [Iterable](https://crystal-lang.org/api/Iterable.html) Modules.

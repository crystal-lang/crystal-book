---
title: Connection
---

A connection is one of the key parts when working with databases. It represents the *runway* through which statements travel from our application to the database.

In Crystal we have two ways of building this connection. And so, coming up next, we are going to present examples with some advice on when to use each one.

## DB module

> _Give me a place to stand, and I shall move the earth._  
> Archimedes

The DB module, is our place to stand when working with databases in Crystal. As written in the documentation: _is a unified interface for database access_.

One of the methods implemented in this module is `DB#connect`. Using this method is the **first way** for creating a connection. Let's see how to use it.

## DB#connect

When using `DB#connect` we are indeed opening a connection to the database. The `uri` passed as the parameter is used by the module to determine which driver to use (for example: `mysql://`, `postgres://`, `sqlite://`, etc.) i.e. we do not need to specify which database we are using.

The `uri` for this example is `mysql://root:root@localhost/test`, and so the module will use the `mysql driver` to connect to the MySQL database.

Here is the example:

```crystal
require "mysql"

cnn = DB.connect("mysql://root:root@localhost/test")
puts typeof(cnn) # => DB::Connection
cnn.close
```

It's worth mentioning that the method returns a `DB::Connection` object. Although more specifically, it returns a `MySql::Connection` object, it doesn't matter because all types of connections should be polymorphic. So hereinafter we will work with a `DB::Connection` instance, helping us to abstract from specific issues of each database engine.

When creating a connection _manually_ (as we are doing here) we are responsible for managing this resource, and so we must close the connection when we are done using it. Regarding the latter, this little details can be the cause of huge bugs! Crystal, being _a language for humans_, give us a more safe way of _manually_ creating a connection using blocks, like this:

```crystal
require "mysql"

DB.connect "mysql://root:root@localhost/test", do |cnn|
  puts typeof(cnn) # => DB::Connection
end # the connection will be closed here
```

Ok, now we have a connection, let's use it!

```crystal
require "mysql"

DB.connect "mysql://root:root@localhost/test", do |cnn|
  puts typeof(cnn) # => DB::Connection
  puts "Connection closed: #{cnn.closed?}" # => false

  result = cnn.exec("drop table if exists contacts")
  puts result

  result = cnn.exec("create table contacts (name varchar(30), age int)")
  puts result

  cnn.transaction do |tx|
    cnn2 = tx.connection
    puts "Yep, it is the same connection! #{cnn == cnn2}"

    cnn2.exec("insert into contacts values ('Joe', 42)")
    cnn2.exec("insert into contacts values (?, ?)", "Sarah", 43)
  end

  cnn.query_each "select * from contacts" do |rs|
    puts "name: #{rs.read}, age: #{rs.read}"
  end
end
```

First, in this example, we are using a transaction (check the [transactions](https://crystal-lang.org/reference/database/transactions.html) section for more information on this topic)
Second, it's important to notice that the connection given by the transaction **is the same connection** that we were working with, before the transaction begin. That is, there is only **one** connection at all times in our program.
And last, we are using the method `#exec` and `#query`. You may read more about executing queries in the [database](https://crystal-lang.org/reference/database/) section.

Now that we have a good idea about creating a connection, let's present the **second way** for creating one: `DB#open`

## DB#open

```crystal
require "mysql"

db = DB.open("mysql://root:root@localhost/test")
puts typeof(db) # DB::Database
db.close
```

As with a connection, we should close the database once we don't need it anymore.
Or instead, we could use a block and let Crystal close the database for us!

But, where is the connection?
Well, we should be asking for the **connections**. When a database is created, a pool of connections is created with connections to the database prepared and ready to use! (Do you want to read more about **pool of connections**? In the [connection pool](https://crystal-lang.org/reference/database/connection_pool.html) section you may read all about this interesting topic!)

How do we use a connection from the `database` object?
For this, we could ask the database for a connection using the method `Database#checkout`. But, doing this will require to explicitly return the connection to the pool using `Connection#release`. Here is an example:

```crystal
require "mysql"

DB.open "mysql://root:root@localhost/test" do |db|
  cnn = db.checkout
  puts typeof(cnn)

  puts "Connection closed: #{cnn.closed?}" # => false
  cnn.release
  puts "Connection closed: #{cnn.closed?}" # => false
end
```

And we want a _safe_ way (i.e. no need for us to release the connection) to request and use a connection from the `database`, we could use `Database#using_connection`:

```crystal
require "mysql"

DB.open "mysql://root:root@localhost/test" do |db|
  db.using_connection do |cnn|
    puts typeof(cnn)
    # use cnn
  end
end
```

In the next example we will let the `database` object *to manage the connections by itself*, like this:

```crystal
require "mysql"

DB.open "mysql://root:root@localhost/test" do |db|
  db.exec("drop table if exists contacts")
  db.exec("create table contacts (name varchar(30), age int)")

  db.transaction do |tx|
    cnn = tx.connection
    cnn.exec("insert into contacts values ('Joe', 42)")
    cnn.exec("insert into contacts values (?, ?)", "Sarah", 43)
  end

  db.query_each "select * from contacts" do |rs|
    puts "name: #{rs.read}, age: #{rs.read}"
  end
end
```

As we may notice, the `database` is polymorphic with a `connection` object with regard to the `#exec` / `#query` / `#transaction` methods. The database is responsible for the use of the connections. Great!

## When to use one or the other?
Given the examples, it may come to our attention that **the number of connections is relevant**.
If we are programming a short living application with only one user starting requests to the  database then a single connection managed by us (i.e. a `DB::Connection` object) should be enough (think of a command line application that receives parameters, then starts a request to the database and finally displays the result to the user)
On the other hand, if we are building a system with many concurrent users and with heavy database access, then we should use a `DB::Database` object; which by using a connection pool will have a number of connections already prepared and ready to use (no bootstrap/initialization-time penalizations). Or imagine that you are building a long-living application (like a background job) then a connection pool will free you from the responsibility of monitoring the state of the connection: is it alive or does it need to reconnect?



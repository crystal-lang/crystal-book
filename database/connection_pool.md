# Connection pool

When a connection is established it usually means opening a TCP connection or Socket. The socket will handle one statement at a time. If a program needs to perform many queries simultaneously, or if it handles concurrent requests that aim to use a database, it will need more than one active connection.

Since databases are separate services from the application using them, the connections might go down, the services might be restarted, and other sort of things the program might not want to care about.

To address this issues usually a connection pool is a neat solution.

When a database is opened with `crystal-db` there is already a connection pool working. `DB.open` returns a `DB::Database` object which manages the whole connection pool and not just a single connection.

```crystal
DB.open("mysql://root@localhost/test") do |db|
  # db is a DB::Database
end
```

When executing statements using `db.query`, `db.exec`, `db.scalar`, etc. the algorithm goes:

1. Find an available connection in the pool.
   1. Create one if needed and possible.
   2. If the pool is not allowed to create a new connection, wait a for a connection to become available.
      1. But this wait should be aborted if it takes too long.
2. Checkout that connection from the pool.
3. Execute the SQL command.
4. If there is no `DB::ResultSet` yielded, return the connection to the pool. Otherwise, the connection will be returned to the pool when the ResultSet is closed.
5. Return the statement result.

If a connection can't be created, or if a connection loss occurs while the statement is performed the above process is repeated.

> The retry logic only happens when the statement is sent through the `DB::Database` . If it is sent through a `DB::Connection` or `DB::Transaction` no retry is performed since the code will state that certain connection object was expected to be used.

## Configuration

The behavior of the pool can be configured from a set of parameters that can appear as query string in the connection URI.

| Name | Default value |
| :--- | :--- |
| initial\_pool\_size | 1 |
| max\_pool\_size | 0 \(unlimited\) |
| max\_idle\_pool\_size | 1 |
| checkout\_timeout | 5.0 \(seconds\) |
| retry\_attempts | 1 |
| retry\_delay | 1.0 \(seconds\) |

When `DB::Database` is opened an initial number of `initial_pool_size` connections will be created. The pool will never hold more than `max_pool_size` connections. When returning/releasing a connection to the pool it will be closed if there are already `max_idle_pool_size` idle connections.

If the `max_pool_size` was reached and a connection is needed, wait up to `checkout_timeout` seconds for an existing connection to become available.

If a connection is lost or can't be established retry at most `retry_attempts` times waiting `retry_delay` seconds between each try.

## Sample

The following program will print the current time from MySQL but if the connection is lost or the whole server is down for a few seconds the program will still run without raising exceptions.

```crystal
# file: sample.cr
require "mysql"

DB.open "mysql://root@localhost?retry_attempts=8&retry_delay=3" do |db|
  loop do
    pp db.scalar("SELECT NOW()")
    sleep 0.5
  end
end
```

```
$ crystal sample.cr
db.scalar("SELECT NOW()") # => 2016-12-16 16:36:57
db.scalar("SELECT NOW()") # => 2016-12-16 16:36:57
db.scalar("SELECT NOW()") # => 2016-12-16 16:36:58
db.scalar("SELECT NOW()") # => 2016-12-16 16:36:58
db.scalar("SELECT NOW()") # => 2016-12-16 16:36:59
db.scalar("SELECT NOW()") # => 2016-12-16 16:36:59
# stop mysql server for some seconds
db.scalar("SELECT NOW()") # => 2016-12-16 16:37:06
db.scalar("SELECT NOW()") # => 2016-12-16 16:37:06
db.scalar("SELECT NOW()") # => 2016-12-16 16:37:07
```

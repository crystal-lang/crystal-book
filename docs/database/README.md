# Database

To access a relational database you will need a shard designed for the database server you want to use. The package [crystal-lang/crystal-db](https://github.com/crystal-lang/crystal-db) offers a unified api across different drivers.

The following packages are compliant with crystal-db

* [crystal-lang/crystal-sqlite3](https://github.com/crystal-lang/crystal-sqlite3) for sqlite
* [crystal-lang/crystal-mysql](https://github.com/crystal-lang/crystal-mysql) for mysql & mariadb
* [will/crystal-pg](https://github.com/will/crystal-pg) for postgres

And several [more](https://github.com/crystal-lang/crystal-db).

This guide presents the api of crystal-db, the sql commands might need to be adapted for the concrete driver due to differences between postgres, mysql and sqlite.

Also some drivers may offer additional functionality like postgres `LISTEN`/`NOTIFY`.

## Installing the shard

Choose the appropriate driver from the list above and add it as any shard to your application's `shard.yml`

There is no need to explicitly require `crystal-lang/crystal-db`

During this guide `crystal-lang/crystal-mysql` will be used.

```yaml
dependencies:
  mysql:
    github: crystal-lang/crystal-mysql
```

## Open database

`DB.open` will allow you to easily connect to a database using a connection uri. The schema of the uri determines the expected driver. The following sample connects to a local mysql database named test with user root and password blank.

```crystal
require "db"
require "mysql"

DB.open "mysql://root@localhost/test" do |db|
  # ... use db to perform queries
end
```

Other connection uris are

* `sqlite3:///path/to/data.db`
* `mysql://user:password@server:port/database`
* `postgres://user:password@server:port/database`

Alternatively you can use a non yielding `DB.open` method as long as `Database#close` is called at the end.

```crystal
require "db"
require "mysql"

db = DB.open "mysql://root@localhost/test"
begin
  # ... use db to perform queries
ensure
  db.close
end
```

Alternatively, you can use `DB.connect` method to open a single connection to the database instead of a pool.

## Exec

To execute sql statements you can use `Database#exec`

```crystal
db.exec "create table contacts (name varchar(30), age int)"
```

```crystal
db.exec "insert into contacts (name, age) values ('abc', 30)"
```

Values can be provided as query parameters, see below.

## Query

To perform a query and get the result set use `Database#query`.

`Database#query` returns a `ResultSet` that needs to be closed. As in `Database#open`, if called with a block, the `ResultSet` will be closed implicitly.

```crystal
db.query "select name, age from contacts order by age desc" do |rs|
  rs.each do
    # ... perform for each row in the ResultSet
  end
end
```

Values can be provided as query parameters, see below.

## Query Parameters

To avoid [SQL injection](https://owasp.org/www-community/attacks/SQL_Injection) values can be provided as query parameters.
The syntax for using query parameters depends on the database driver because they are typically just passed through to the database. MySQL uses `?` for parameter expansion and assignment is based on argument order. PostgreSQL uses `$n` where `n` is the ordinal number of the argument (starting with 1).

```crystal
# MySQL
db.exec "insert into contacts values (?, ?)", "John", 30
# Postgres
db.exec "insert into contacts values ($1, $2)", "Sarah", 33
# Queries:
db.query("select name from contacts where age = ?", 33) do |rs|
  rs.each do
    # ... perform for each row in the ResultSet
  end
end
```

Query parameters are effected under the covers with prepared statements (sometimes cached),
or insertion on the client side, depending on the driver, but will always avoid SQL Injection.

If you want to manually use prepared statements, you can with the `build` method:

```crystal
# MySQL
mysql_prepared_statement = mysql_db.build("select * from contacts where id=?")
# Postgres
postgres_prepared_statement = postgres_db.build("select * from contacts where id=$1")
# Use prepared statement:
prepared_statement.query(3) do |rs|
  # ... use rs
end
prepared_statement.query(4) do |rs|
  # ... use rs
end
prepared_statement.close
```

## Reading Query Results

When reading values from the database there is no type information during compile time that crystal can use. You will need to call `rs.read(T)` with the type `T` you expect to get from the database.

```crystal
db.query "select name, age from contacts order by age desc" do |rs|
  rs.each do
    name = rs.read(String)
    age = rs.read(Int32)
    puts "#{name} (#{age})"
    # => Sarah (33)
    # => John Doe (30)
  end
end
```

There are many convenient query methods built on top of `#query` to make this easier.

You can read multiple columns at once:

```crystal
name, age = rs.read(String, Int32)
```

Or read a single row:

```crystal
name, age = db.query_one "select name, age from contacts order by age desc limit 1", as: {String, Int32}
```

Or read a scalar value without dealing explicitly with the ResultSet:

```crystal
max_age = db.scalar "select max(age) from contacts"
```

There are many other helper methods to query with types, query column names with types, etc.
All available methods to perform statements in a database are defined in `DB::QueryMethods`.

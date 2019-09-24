# Transactions
When working with databases, it is common to need to group operations in such a way that if one fails, then we can go back to the latest safe state.
This solution is described in the **transaction paradigm**, and is implemented by most database engines as it is necessary to meet ACID properties (Atomicity, Consistency, Isolation, Durability) [^ACID]

With this in mind, we present the following example:

We have two accounts (each represented by a name and an amount of money).

```crystal
  db = get_bank_db

  create_account db, "John", amount: 100
  create_account db, "Sarah", amount: 100
```

In one moment a transfer is made from one account to the other. For example, _John transfers $50 to Sarah_

We have two accounts (each represented by a name and an amount of money).

```crystal
  deposit db, "Sarah", 50
  withdraw db, "John", 50
```


It is important to have in mind that if one of the operations fails then the final state would be inconsistent. So we need to execute the **two operations** (deposit and withdraw) as **one operation**. And if an error occurs then we would like to go back in time as if that one operation was never executed.

```crystal
  db = get_bank_db

  create_account db, "John", amount: 100
  create_account db, "Sarah", amount: 100

  db.transaction do |tx|
    cx = tx.connection

    transfer_amount = 1000
    deposit cx, "Sarah", transfer_amount
    withdraw cx, "John", transfer_amount
  end
```


In the above example, we start a transaction simply by calling the method `Database#transaction` (how we get the `database` object is encapsulated in the method `get_bank_db` and is out of the scope of this document).
The `block` is the body of the transaction. When the `block` gets executed (without any error) then an **implicit commit** is finally executed to persist the changes in the database.
If an exception is raised by one of the operations, then an **implicit rollback** is executed, bringing the database to the state before the transaction started.

## Exception handling and rolling back
As we mentioned early, an **implicit rollback** gets executed when an exception is raised, and it’s worth mentioning that the exception may be rescued by us.

```crystal
  db = get_bank_db

  create_account db, "John", amount: 100
  create_account db, "Sarah", amount: 100

  begin
    db.transaction do |tx|
      cx = tx.connection

      transfer_amount = 1000
      deposit(cx, "Sarah", transfer_amount)
      # John does not have enough money in his account!
      withdraw(cx, "John", transfer_amount)
    end
  rescue ex
    puts "Transfer has been rolled back due to: #{ex}"
  end
```

We may also raise an exception in the body of the transaction:

```crystal
  db = get_bank_db

  create_account db, "John", amount: 100
  create_account db, "Sarah", amount: 100

  begin
    db.transaction do |tx|
      cx = tx.connection

      transfer_amount = 50
      deposit(cx, "Sarah", transfer_amount)
      withdraw(cx, "John", transfer_amount)
      raise Exception.new "Because ..."
    end
  rescue exception
    puts "Transfer has been rolled back due to: #{exception}"
  end
```

As the previous example the exception cause the transaction to rollback and then is rescued by us.

There is one `exception` with a different behaviour. If a `DB::Rollback` is raised within the block, the implicit rollback will happen, but the exception will not be raised outside the block.

```crystal
  db = get_bank_db

  create_account db, "John", amount: 100
  create_account db, "Sarah", amount: 100

  begin
    db.transaction do |tx|
      cx = tx.connection

      transfer_amount = 50
      deposit(cx, "Sarah", transfer_amount)
      withdraw(cx, "John", transfer_amount)

      # rollback exception
      raise DB::Rollback.new
    end
  rescue ex
    # ex is never a DB::Rollback
  end
```

## Explicit commit and rollback

In all the previous examples, the rolling back is **implicit**, but we can also tell the transaction to rollback:

```crystal
  db = get_bank_db

  create_account db, "John", amount: 100
  create_account db, "Sarah", amount: 100

  begin
    db.transaction do |tx|
      cx = tx.connection

      transfer_amount = 50
      deposit(cx, "Sarah", transfer_amount)
      withdraw(cx, "John", transfer_amount)

      tx.rollback

      puts “Rolling Back the changes!”
    end
  rescue ex
    # Notice that no exception is used in this case.
  end
```

And we also can send the message `commit` to the transaction:

```crystal
  db = get_bank_db

  db.transaction do |tx|
    cx = tx.connection

    transfer_amount = 50
    deposit(cx, "Sarah", transfer_amount)
    withdraw(cx, "John", transfer_amount)

    tx.commit
  end
```

Note: After `commit` or `rollback` are used, the transaction is no longer usable. The connection is still open but any statement will be performed outside the context of the terminated transaction.

## Nested transactions
As the name suggests, a nested transaction is a transaction created inside the scope of another transaction. Here is an example:

```crystal
  db = get_bank_db

  create_account db, "John", amount: 100
  create_account db, "Sarah", amount: 100
  create_account db, "Jack", amount: 0

  begin
    db.transaction do |outer_tx|
      outer_cx = outer_tx.connection

      transfer_amount = 50
      deposit(outer_cx, "Sarah", transfer_amount)
      withdraw(outer_cx, "John", transfer_amount)

      outer_tx.transaction do |inner_tx|
        inner_cx = inner_tx.connection

        # John => 50 (pending commit)
        # Sarah => 150 (pending commit)
        # Jack => 0

        another_transfer_amount = 150
        deposit(inner_cx, "Jack", another_transfer_amount)
        withdraw(inner_cx, "Sarah", another_transfer_amount)
      end
    end
  rescue exception
    puts "Exception raised due to: #{exception}"
  end
```

Some observations from the example above:
the `inner_tx` works with the values updated although the `outer_tx` is pending the commit.
the connection used by `outer_cx` and `inner_cx` is **the same connection**. This is because the `inner_tx` inherits the connection from the `outer_tx` when created.


### Rollback nested transactions

As we’ve already seen, a rollback may be fired at any time (by an exception or by sending the message `rollback` explicitly)

So let’s present an example with a **rollback fired by an exception placed at the outer-transaction**:

```crystal
  db = get_bank_db

  create_account db, "John", amount: 100
  create_account db, "Sarah", amount: 100
  create_account db, "Jack", amount: 0

  begin
    db.transaction do |outer_tx|
      outer_cx = outer_tx.connection

      transfer_amount = 50
      deposit(outer_cx, "Sarah", transfer_amount)
      withdraw(outer_cx, "John", transfer_amount)

      outer_tx.transaction do |inner_tx|
        inner_cx = inner_tx.connection

        # John => 50 (pending commit)
        # Sarah => 150 (pending commit)
        # Jack => 0

        another_transfer_amount = 150
        deposit(inner_cx, "Jack", another_transfer_amount)
        withdraw(inner_cx, "Sarah", another_transfer_amount)
      end

      raise Exception.new("Rollback all the things!")
    end
  rescue exception
    puts "Exception raised due to: #{exception}"
  end
```

The rollback place in the `outer-transaction`, rolled back all the changes including the ones in the `inner-transaction` (the same happens if we use an **explicit** rollback)

If the **rollback is fired by an exception at the inner-transaction** all the changes including the ones in the `outer-transaction` are rollbacked.

```crystal
  db = get_bank_db

  create_account db, "John", amount: 100
  create_account db, "Sarah", amount: 100
  create_account db, "Jack", amount: 0

  begin
    db.transaction do |outer_tx|
      outer_cx = outer_tx.connection

      transfer_amount = 50
      deposit(outer_cx, "Sarah", transfer_amount)
      withdraw(outer_cx, "John", transfer_amount)

      outer_tx.transaction do |inner_tx|
        inner_cx = inner_tx.connection

        # John => 50 (pending commit)
        # Sarah => 150 (pending commit)
        # Jack => 0

        another_transfer_amount = 150
        deposit(inner_cx, "Jack", another_transfer_amount)
        withdraw(inner_cx, "Sarah", another_transfer_amount)

        raise Exception.new("Rollback all the things!")
      end
    end
  rescue exception
    puts "Exception raised due to: #{exception}"
  end
```

There a way to rollback the changes in the `inner-transaction` but keep the ones in the `outer-transaction`. Use `rollback` in the `inner_tx` object. This will rollback **only** then inner-transaction. Here is the example:

```crystal
  db = get_bank_db

  create_account db, "John", amount: 100
  create_account db, "Sarah", amount: 100
  create_account db, "Jack", amount: 0

  begin
    db.transaction do |outer_tx|
      outer_cx = outer_tx.connection

      transfer_amount = 50
      deposit(outer_cx, "Sarah", transfer_amount)
      withdraw(outer_cx, "John", transfer_amount)

      outer_tx.transaction do |inner_tx|
        inner_cx = inner_tx.connection

        # John => 50 (pending commit)
        # Sarah => 150 (pending commit)
        # Jack => 0

        another_transfer_amount = 150
        deposit(inner_cx, "Jack", another_transfer_amount)
        withdraw(inner_cx, "Sarah", another_transfer_amount)

        inner_tx.rollback
      end
    end
  rescue exception
    puts "Exception raised due to: #{exception}"
  end
```


The same happens if a `DB::Rollback exception` is raised in the `inner-transaction` block.

```crystal
  db = get_bank_db

  create_account db, "John", amount: 100
  create_account db, "Sarah", amount: 100
  create_account db, "Jack", amount: 0

  begin
    db.transaction do |outer_tx|
      outer_cx = outer_tx.connection

      transfer_amount = 50
      deposit(outer_cx, "Sarah", transfer_amount)
      withdraw(outer_cx, "John", transfer_amount)

      outer_tx.transaction do |inner_tx|
        inner_cx = inner_tx.connection

        # John => 50 (pending commit)
        # Sarah => 150 (pending commit)
        # Jack => 0

        another_transfer_amount = 150
        deposit(inner_cx, "Jack", another_transfer_amount)
        withdraw(inner_cx, "Sarah", another_transfer_amount)

        # Rollback exception
        raise DB::Rollback.new
      end
    end
  rescue exception
    puts "Exception raised due to: #{exception}"
  end
```

And that’s all for **Transactions** in Crystal!! `Commit!`

[^ACID]: Theo Haerder and Andreas Reuter. 1983. Principles of transaction-oriented database recovery. ACM Comput. Surv. 15, 4 (December 1983), 287-317. DOI=http://dx.doi.org/10.1145/289.291

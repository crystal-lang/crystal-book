# select

The `select` expression chooses from a set of blocking operations and proceeds with the branch that becomes available first.

## Syntax

The expression starts with the keyword `select`, followed by a list of one or more `when` branches.
Each branch has a condition and a body, separated by either
a statement separator or the keyword `then`.
Optionally, the last branch may be `else` (without condition).  This denotes the `select` action as non-blocking.
The expression closes with an `end` keyword.

> NOTE:
> `select` is similar to a [`case` expression](./case.md) with all branches referring to potentially blocking operations.

Each condition is either a call to a select action or an assignment whose right-hand side is a call to a select action.

```crystal
select
when foo = foo_channel.receive
  puts foo
when bar = bar_channel.receive
  puts bar
when exit_channel.receive
  exit
when timeout(5.seconds)
  puts "Timeout"
end
```

## Select actions

A select action call calls a method with the implicit suffix "_select_action".
This method returns an instance of the select action.

The `select` expression initiates the select action associated with each branch. If either of them immediately returns, it proceeds with that.
Otherwise it waits for completion. As soon as one branch completes, all
others are canceled.
An `else` branch completes immediately so there will not be any waiting.

Execution continues in the completed branch.
If the branch condition is an assignment, the result of the select call is assigned to the target variable.

<!-- markdownlint-disable MD046 -->

!!! info "Select actions in the standard library"
    The standard library provides the following select actions:

    * `Channel#send_select_action`
    * `Channel#receive_select_action`
    * `Channel#receive_select_action?`
    * [`::timeout_select_action`](https://crystal-lang.org/api/toplevel.html#timeout_select_action(timeout:Time::Span):Channel::TimeoutAction-class-method)

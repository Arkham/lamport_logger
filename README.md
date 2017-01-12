# Lamport Logger

This app simulates the behaviour of a logging service, which receives messages
from multiple workers. The role of the logging service is to make sense of the
ordering of the messages and print them out in a sensible order.

## Example

Using default logging behaviour

```
iex(16)> LamportLogger.TestRun.run(200, 1000)
log: %LamportLogger.Time{value: 2}      :ringo  {:recv, {:hello, 93306}}
log: %LamportLogger.Time{value: 3}      :ringo  {:send, {:hello, 2480}}
log: %LamportLogger.Time{value: 1}      :george {:send, {:hello, 65313}}
log: %LamportLogger.Time{value: 5}      :george {:recv, {:hello, 52060}}
log: %LamportLogger.Time{value: 1}      :paul   {:send, {:hello, 93306}}
log: %LamportLogger.Time{value: 2}      :paul   {:recv, {:hello, 65313}}
log: %LamportLogger.Time{value: 4}      :paul   {:recv, {:hello, 2480}}
log: %LamportLogger.Time{value: 5}      :paul   {:recv, {:hello, 95224}}
log: %LamportLogger.Time{value: 4}      :ringo  {:send, {:hello, 52060}}
log: %LamportLogger.Time{value: 1}      :john   {:send, {:hello, 95224}}
log: %LamportLogger.Time{value: 7}      :john   {:recv, {:hello, 57731}}
log: %LamportLogger.Time{value: 8}      :john   {:recv, {:hello, 57017}}
log: %LamportLogger.Time{value: 6}      :george {:send, {:hello, 57731}}
log: %LamportLogger.Time{value: 7}      :george {:recv, {:hello, 91097}}
log: %LamportLogger.Time{value: 8}      :george {:send, {:hello, 4432}}
log: %LamportLogger.Time{value: 10}     :george {:recv, {:hello, 15638}}
log: %LamportLogger.Time{value: 5}      :ringo  {:send, {:hello, 57017}}
log: %LamportLogger.Time{value: 6}      :paul   {:send, {:hello, 91097}}
log: %LamportLogger.Time{value: 9}      :paul   {:recv, {:hello, 4432}}
```

Using logging that relies on Lamport timestamps

```
iex(18)> LamportLogger.TestRun.run(200, 1000)
log: %LamportLogger.Time{value: 1}      :john   {:send, {:hello, 95224}}
log: %LamportLogger.Time{value: 1}      :paul   {:send, {:hello, 93306}}
log: %LamportLogger.Time{value: 1}      :george {:send, {:hello, 65313}}
log: %LamportLogger.Time{value: 2}      :paul   {:recv, {:hello, 65313}}
log: %LamportLogger.Time{value: 2}      :ringo  {:recv, {:hello, 93306}}
log: %LamportLogger.Time{value: 3}      :ringo  {:send, {:hello, 2480}}
log: %LamportLogger.Time{value: 4}      :ringo  {:send, {:hello, 52060}}
log: %LamportLogger.Time{value: 4}      :paul   {:recv, {:hello, 2480}}
log: %LamportLogger.Time{value: 5}      :ringo  {:send, {:hello, 57017}}
log: %LamportLogger.Time{value: 5}      :paul   {:recv, {:hello, 95224}}
log: %LamportLogger.Time{value: 5}      :george {:recv, {:hello, 52060}}
log: %LamportLogger.Time{value: 6}      :ringo  {:send, {:hello, 77703}}
log: %LamportLogger.Time{value: 6}      :paul   {:send, {:hello, 91097}}
log: %LamportLogger.Time{value: 6}      :george {:send, {:hello, 57731}}
log: %LamportLogger.Time{value: 7}      :ringo  {:send, {:hello, 67606}}
log: %LamportLogger.Time{value: 7}      :george {:recv, {:hello, 91097}}
log: %LamportLogger.Time{value: 7}      :john   {:recv, {:hello, 57731}}
log: %LamportLogger.Time{value: 8}      :george {:send, {:hello, 4432}}
log: %LamportLogger.Time{value: 8}      :john   {:recv, {:hello, 57017}}
```

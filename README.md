rzmq-workers
============

Call R functions through ZMQ and get answers.

Pass a function name (string) and args (hash) through a REQ socket and have
the result returned, again as JSON:

```coffee
input_json = {
"fun": "sqrt",
"args": {
"x": 10000
}
} -> "100"
```

See the `rzmq-test-client.R` for an example.

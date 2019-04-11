# DMS (Dead Man's Switch)

A simple OTP Application (and eventually an HTTP API) which enables short
circuiting when a service becomes unavailable.

_Used as a learning project for members of Belfast Elixir._

Build: `mix do deps.get, compile`
Test:  `mix test`
REPL:  `iex -S mix`

## API

```elixir
# Ping will register service with that id as alive
id = "my-svc-id"
DMS.ping(id) # => :pong
DMS.alive?(id) # => true ~ Service with id responds as alive
# After @timeout period and no further pings
DMS.alive?(id) # => false ~ Service with id responds as dead
```

```elixir
# An id which has never pinged will also respond as dead
false = DMS.alive?("another-svc-id") #=> false
```

## TODO

* Add Documentation with [ExDoc](https://github.com/elixir-lang/ex_doc)
* Add Credo & Dialyzer for linting and static analysis.
* Add API to set service as down (before timeout).
* Enhance `DMS.id` to contain service id and account token + hash it before use
  as key in `DMS.Servise.Registry`.
* Add HTTP API.
* Add Pub/Sub push based API to notify when service is down.
* Publish on HEX package manager.

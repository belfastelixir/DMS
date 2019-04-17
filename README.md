# DMS (Dead Man's Switch)

A simple OTP Application (and eventually an HTTP API) which enables short
circuiting when a service becomes unavailable.

_Used as a learning project for members of Belfast Elixir._

* Build:   `mix do deps.get, compile`
* Test:    `mix test`
* REPL:    `iex -S mix`
* Observe: `:observer.start`

## API Examples

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

## Checklist

- [x] ([#13](https://github.com/belfastelixir/DMS/issues/13)) Model a Service as a Process (`DMS.Service`)
- [x] ([#1](https://github.com/belfastelixir/DMS/issues/1)) Register Service against an `id` (`DMS.Servce.Registry`)
- [x] ([#2](https://github.com/belfastelixir/DMS/issues/2)) Add a supervisor for Service Process (`DMS.Service.Supervisor`)
- [x] ([#3](https://github.com/belfastelixir/DMS/issues/3)) Add `ping(id)` function which will init Service if doesn't exist
- [x] ([#4](https://github.com/belfastelixir/DMS/issues/4)) Add `alive?(id)` function which returns `true` if service alive otherwise `false`
- [x] ([#5](https://github.com/belfastelixir/DMS/issues/5)) Add timer to service process which will terminate the process if it hasn't been pinged within `@timeout`
- [ ] ([#12](https://github.com/belfastelixir/DMS/issues/12)) Add Documentation with [ExDoc](https://github.com/elixir-lang/ex_doc)
- [ ] ([#6](https://github.com/belfastelixir/DMS/issues/6)) Add Credo & Dialyzer for linting and static analysis.
- [ ] ([#7](https://github.com/belfastelixir/DMS/issues/7)) Add API to set service as down (before timeout).
- [ ] ([#8](https://github.com/belfastelixir/DMS/issues/8)) Enhance `DMS.id` to contain service id and account token + hash it before use as key in `DMS.Servise.Registry`.
- [ ] ([#9](https://github.com/belfastelixir/DMS/issues/9)) Add HTTP API.
- [ ] ([#10](https://github.com/belfastelixir/DMS/issues/10)) Add Pub/Sub push based API to notify when service is down.
- [ ] ([#11](https://github.com/belfastelixir/DMS/issues/11)) Publish on HEX package manager.


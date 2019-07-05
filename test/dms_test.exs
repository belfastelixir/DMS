defmodule DMSTest do
  use ExUnit.Case
  use ExUnitProperties

  doctest DMS

  @moduletag :capture_log

  property "ping should init a new dms" do
    check all id <- Fixtures.ServiceId.generator() do
      assert :pong = DMS.ping(id)
      assert DMS.alive?(id)
    end
  end

  test "ping twice should return ok" do
    id = Fixtures.ServiceId.valid()
    ping = fn -> DMS.ping(id) end

    resps =
      1..10
      |> Enum.map(fn _ -> Task.async(ping) end)
      |> Enum.map(fn t -> Task.await(t) end)

    for resp <- resps do
      assert :pong = resp
    end
  end

  test "service should die after timeout expires" do
    id = Fixtures.ServiceId.valid()

    timeout_ms = 1
    assert :pong = DMS.ping(id, timeout_ms: timeout_ms)
    Process.sleep(2)
    refute DMS.alive?(id)
  end

  test "ping should update the service timeout" do
    id = Fixtures.ServiceId.valid()

    timeout_ms = 60_000
    short_timeout = 1

    assert :pong = DMS.ping(id, timeout_ms: timeout_ms)
    assert :pong = DMS.ping(id, timeout_ms: short_timeout)
    Process.sleep(2)

    refute DMS.alive?(id)
  end

  test "ping should return :pang when passed an empty string" do
    id = Fixtures.ServiceId.invalid(:empty)
    assert :pang = DMS.ping(id)
  end

  test "ping should return :pang when passed a string that is too long" do
    id = Fixtures.ServiceId.invalid(:too_long)
    assert :pang = DMS.ping(id)
  end

  test "ping should use default timeout when no override is passed" do
    id = Fixtures.ServiceId.valid()
    assert :pong = DMS.ping(id)
    assert 5_000 = DMS.Service.timeout_ms(id)
  end

  test "ping should use timeout value passed" do
    id = Fixtures.ServiceId.valid()
    custom_timeout = 666
    assert :pong = DMS.ping(id, timeout_ms: custom_timeout)
    assert custom_timeout = DMS.Service.timeout_ms(id)
  end
end


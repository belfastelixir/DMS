defmodule DMSTest do
  use ExUnit.Case
  doctest DMS

  test "ping should init a new dms" do
    payload = %{id: "test-svc"}
    assert :pong = DMS.ping(payload)
  end
end

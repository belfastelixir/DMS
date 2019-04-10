defmodule DMSTest do
  use ExUnit.Case
  doctest DMS

  test "ping should init a new dms" do
    id = "test-svc"
    assert :pong = DMS.ping(id)
    assert DMS.alive?(id)
  end

  test "service should die after 5 seconds" do
    id = "test-svc-2"
    assert :pong = DMS.ping(id)
    Process.sleep(5_000)
    refute DMS.alive?(id)
  end
end

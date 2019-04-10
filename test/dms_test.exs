defmodule DmsTest do
  use ExUnit.Case
  doctest Dms

  test "greets the world" do
    assert Dms.hello() == :world
  end
end

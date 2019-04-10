defmodule DMS do
  @moduledoc """
  Dead Mans Switch

  -
  """

  @typedoc "id of the service"
  @type id :: String.t()

  alias DMS.Service

  @spec ping(id) :: :pong | :pang
  def ping(id) do
    Service.ping(id)
  end

  @spec alive?(id) :: boolean()
  def alive?(id) do
    Service.alive?(id)
  end
end

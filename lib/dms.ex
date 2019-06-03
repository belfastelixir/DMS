defmodule DMS do
  @moduledoc """
  Dead Mans Switch

  Allows a service to ping with an identity which will result in that
  identity responding as alive.

  After a @timeout period where a service has not pinged with said identity,
  the service will no longer respond as alive.
  """

  @typedoc "id of the service"
  @type id :: String.t()

  alias DMS.Service

  @doc """
  Returns `:pong` if service has been acknowledged as alive by DMS otherwise `:pang`.
  """
  @spec ping(id) :: :pong | :pang
  def ping(id) do
    Service.ping(id)
  end

  @doc """
  Returns `true` if service with `id` has pinged within `@timeout` period otherwise `false`.
  """
  @spec alive?(id) :: boolean()
  def alive?(id) do
    Service.alive?(id)
  end
end

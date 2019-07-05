defmodule DMS do
  @moduledoc """
  Dead Mans Switch

  Allows a service to ping with an identity which will result in that
  identity responding as alive.

  After a @timeout period where a service has not pinged with said identity,
  the service will no longer respond as alive.
  """

  alias DMS.Service

  @typedoc "id of the service"
  @type id :: String.t()

  @typedoc "options for configuring service"
  @type service_option :: {:timeout_ms, pos_integer()}

  @typedoc "list of options for configuring service"
  @type service_options :: [service_option]

  @typedoc "return type of ping/1 and ping/2"
  @type ping_ret :: :pong | :pang

  @doc """
  Returns `:pong` if service has been acknowledged as alive by DMS otherwise `:pang`.
  """
  @spec ping(id) :: ping_ret()
  @spec ping(id, service_options) :: ping_ret()
  def ping(id, service_options \\ [])

  @max_byte_size 256
  def ping(id, service_options) when is_binary(id) and byte_size(id) <= @max_byte_size do
    if id == "" do
      :pang
    else
      Service.ping(id, service_options)
    end
  end

  def ping(_id, _service_options) do
    :pang
  end

  @doc """
  Returns `true` if service with `id` has pinged within `@timeout` period otherwise `false`.
  """
  @spec alive?(id) :: boolean()
  def alive?(id) do
    Service.alive?(id)
  end
end

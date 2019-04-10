defmodule DMS.Service do
  @moduledoc """
  Service Actor

  Holds information and activity of a service

  1. ID keyed process registry
  2. Supervisor (Dynamic Supervisor)
  3. Timer
    * ping: signals service is alive
    * timer: checks if service has pinged within interval
  """
  use GenServer

  @server __MODULE__

  @doc """
  Signals service is alive.
  Returns pong if signal was successful, otherwise pang.
  """
  @spec ping(DMS.id) :: :pong | :pang
  def ping(id) do
    # TODO Create ServiceRegistry
    # TODO Create Service if does not exist
  end

  @doc "states if service has signaled within interval"
  @spec alive?(DMS.id) :: boolean
  def alive?(id) do
    #GenServer.call(id, :alive?)
  end

  def start_link(args) do
    GenServer.start_link(@server, args)
  end

  def init(args) do
    id = args
    {:ok, %{id: id}}
  end

end

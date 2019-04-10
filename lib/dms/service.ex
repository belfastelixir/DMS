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

  use DMS.ServiceRegistry

  require Logger

  @server __MODULE__
  @supervisor __MODULE__.Supervisor
  @timeout 5 * 1000

  @doc """
  Signals service is alive.
  Returns pong if signal was successful, otherwise pang.
  """
  @spec ping(DMS.id) :: :pong | :pang
  def ping(id) do
    Logger.debug("exist? #{exists?(id)}")

    if exists?(id) do
      GenServer.cast(via_registry(id), :ping)
      :pong
    else
      child_spec = %{
        id: id,
        restart: :temporary,
        start: {__MODULE__, :start_link, [id]}
      }

      {:ok, _} = DynamicSupervisor.start_child(@supervisor, child_spec)
      Logger.debug("Registered new service: `#{id}`.")
      :pong
    end
  end

  @doc "states if service has signaled within interval"
  @spec alive?(DMS.id) :: boolean
  def alive?(id) do
    exists?(id)
  end

  def start_link(args) do
    id = args
    GenServer.start_link(@server, args, name: via_registry(id))
  end

  @impl GenServer
  def init(args) do
    id = args
    {:ok, %{id: id, timer_ref: kill_switch()}}
  end

  @impl GenServer
  def handle_cast(:ping, state) do
    Logger.info("Ping received #{state.id}.")
    :ok = Process.cancel_timer(state.timer_ref)
    {:noreply, %{state | timer_ref: kill_switch()}}
  end

  @impl GenServer
  def handle_info(:die, state) do
    Logger.info("Kill signal received #{state.id} ~ BYE!")
    {:stop, :normal, state}
  end

  @doc false
  def kill_switch() do
    Process.send_after(self(), :die, @timeout)
  end
end

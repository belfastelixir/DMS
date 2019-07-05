defmodule DMS.Service do
  @moduledoc """
  Service Actor representing an active service.
  Will terminate if there has not been a `ping/1` against a `DMS.id` within `@timeout`.
  """
  use GenServer

  import DMS.Service.Registry, only: [via_registry: 1, exists?: 1]

  require Logger

  @server __MODULE__
  @supervisor DMS.Service.Supervisor
  @timeout_ms 5 * 1000

  @doc """
  Signals service is alive.
  Returns pong if signal was successful, otherwise pang.
  """
  @spec ping(DMS.id(), DMS.service_options()) :: :pong | :pang
  def ping(id, opts) when is_list(opts) do
    child_spec = %{
      id: id,
      restart: :temporary,
      start: {__MODULE__, :start_link, [{id, opts}]}
    }

    case DynamicSupervisor.start_child(@supervisor, child_spec) do
      {:ok, _} ->
        :pong

      {:error, {:already_started, _}} ->
        GenServer.cast(via_registry(id), {:ping, opts})
        :pong
    end
  end

  @doc """
  Respond with `true` if service has been pinged within `@timeout`
  otherwise false.
  """
  @spec alive?(DMS.id()) :: boolean
  def alive?(id) do
    exists?(id)
  end

  @doc false
  def timeout_ms(id) do
    GenServer.call(via_registry(id), :timeout_ms)
  end

  @doc false
  def start_link({id, _} = args) do
    GenServer.start_link(@server, args, name: via_registry(id))
  end

  @doc false
  @impl GenServer
  def init({id, opts}) do
    timeout_ms = opts[:timeout_ms] || @timeout_ms
    Logger.debug("[id: #{id}] New service registered.")
    {:ok, %{id: id, timeout_ms: timeout_ms, timer_ref: kill_switch(timeout_ms)}}
  end

  @doc false
  @impl GenServer
  def handle_cast({:ping, opts}, state) do
    Logger.info("[id: #{state.id}] Ping received.")

    timeout_ms = opts[:timeout_ms] || state.timeout_ms
    Process.cancel_timer(state.timer_ref)
    {:noreply, %{state | timeout_ms: timeout_ms, timer_ref: kill_switch(timeout_ms)}}
  end

  @doc false
  @impl GenServer
  def handle_call(:timeout_ms, _from, state) do
    {:reply, state.timeout_ms, state}
  end

  @doc false
  @impl GenServer
  def handle_info(:die, state) do
    Logger.info("[id: #{state.id}] Kill signal received ~ terminating!")
    {:stop, :normal, state}
  end

  @doc false
  def kill_switch(timeout_ms) do
    Process.send_after(self(), :die, timeout_ms)
  end





end

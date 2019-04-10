defmodule DMS.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: DMS.Service.Supervisor},
      DMS.ServiceRegistry.child_spec()
    ]

    opts = [strategy: :one_for_one, name: DMS.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

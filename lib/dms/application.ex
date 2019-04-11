defmodule DMS.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      DMS.Service.Supervisor.child_spec(),
      DMS.Service.Registry.child_spec()
    ]

    opts = [strategy: :one_for_one, name: DMS.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

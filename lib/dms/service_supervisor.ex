defmodule DMS.Service.Supervisor do
  @moduledoc """
  `DyanmicSupervisor` for `DMS.Service` processes.
  """

  def child_spec() do
    {DynamicSupervisor, strategy: :one_for_one, name: __MODULE__}
  end
end

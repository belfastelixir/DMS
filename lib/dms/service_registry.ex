defmodule DMS.Service.Registry do
  @moduledoc """
  Helper macro and functions for leveraging a Process `Registry` which enables
  registration of `DMS.id` as a key for looking up the corresponding `DMS.Service`
  process.
  """
  @registry_name __MODULE__

  @type via_tuple :: {:via, Registry, {module(), DMS.id()}}

  @doc "Child Specification for `#{__MODULE__}`"
  @spec child_spec :: map()
  def child_spec() do
    %{
      id: __MODULE__,
      start: {Registry, :start_link, [[keys: :unique, name: @registry_name]]}
    }
  end

  @spec via_registry(DMS.id()) :: via_tuple()
  def via_registry(id) do
    {:via, Registry, {@registry_name, id}}
  end

  @doc """
  Returns `pid` of `DMS.Service` process if one exists registered against `DMS.id`,
  otherwise `:undefined`.
  """
  @spec whereis_name(DMS.id()) :: pid() | :undefined
  def whereis_name(id) do
    Registry.whereis_name({@registry_name, id})
  end

  @doc """
  Returns `true` if process is registered with `DMS.id` otherwise `false`.
  """
  @spec exists?(DMS.id()) :: boolean()
  def exists?(id), do: whereis_name(id) != :undefined
end

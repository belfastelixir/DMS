defmodule Fixtures do
  defmodule ServiceId do
    def generator() do
      StreamData.string(:alphanumeric, min_length: 1, max_length: 256)
    end

    def valid() do
      generator()
      |> Enum.take(1)
      |> hd()
    end

    def invalid(:empty), do: ""

    def invalid(:too_long) do
      StreamData.string(:alphanumeric, min_length: 257)
      |> Enum.take(1)
      |> hd()
    end
  end
end

defmodule DMS.MixProject do
  use Mix.Project

  def project do
    [
      app: :dms,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DMS.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.0", only: [:dev]},
      {:dialyxir, "~> 0.5.1", only: [:dev]}
    ]
  end
end

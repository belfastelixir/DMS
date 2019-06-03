defmodule DMS.MixProject do
  use Mix.Project

  def project do
    [
      app: :dms,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "DMS",
      source_url: "https://github.com/belfastelixir/DMS",
      homepage_url: "https://github.com/belfastelixir/DMS",
      docs: [
        main: "DMS",
        extras: ["README.md"]
      ]
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
      {:dialyxir, "~> 0.5.1", only: [:dev]},
      {:ex_doc, "~> 0.19", only: [:dev], runtime: false}
    ]
  end
end

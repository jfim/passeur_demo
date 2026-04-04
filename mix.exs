defmodule PasseurDemo.MixProject do
  use Mix.Project

  def project do
    [
      app: :passeur_demo,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {PasseurDemo.Application, []}
    ]
  end

  defp deps do
    [
      {:passeur, path: "../passeur"},
      {:passeur_files, path: "../passeur_files"}
    ]
  end
end

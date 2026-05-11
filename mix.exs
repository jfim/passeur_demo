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
      {:anubis_mcp, git: "https://github.com/jfim/anubis-mcp.git", branch: "non-upstreamed-fixes", override: true},
      {:passeur, git: "https://github.com/jfim/passeur.git"},
      {:passeur_files, git: "https://github.com/jfim/passeur_files.git"}
    ]
  end
end

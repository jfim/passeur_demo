import Config

config :passeur,
  ecto_repos: [Passeur.Repo],
  mcp_server: PasseurDemo.MCPServer

config :boruta, Boruta.Oauth,
  repo: Passeur.Repo,
  contexts: [
    resource_owners: Passeur.ResourceOwners
  ]

import_config "#{config_env()}.exs"

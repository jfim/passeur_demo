# Passeur Demo

Demo MCP server built with [Passeur](https://github.com/jfim/passeur). Use this as a starting point to build your own MCP server with OAuth 2.1 authentication that works with claude.ai, Claude Desktop, and Claude Code.

## What's included

- **greet** tool — sends a name to a Greeter GenServer actor, responds with a greeting
- **File tools** (via [passeur_files](https://github.com/jfim/passeur_files)) — list, read, write, edit, and delete files in a configurable directory

## Quick Start with Docker

```bash
# Generate a password hash
docker run --rm -it elixir:1.19-otp-28-slim sh -c \
  'mix local.hex --force && mix eval "IO.puts(Argon2.hash_pwd_salt(\"your_password\"))"'

# Create .env file
cat > .env << 'EOF'
SECRET_KEY_BASE=generate_a_64_char_random_string_here
ADMIN_USERNAME=admin
ADMIN_PASSWORD_HASH=$argon2id$v=19$m=65536,t=3,p=4$your_hash_here
SERVER_URL=https://mcp.your-domain.com
POSTGRES_PASSWORD=your_postgres_password
EOF

# Start
docker compose up -d
```

Your MCP server is now at `https://mcp.your-domain.com/mcp`.

**Note:** HTTPS is required. Use a reverse proxy (nginx, Caddy, Cloudflare Tunnel) for SSL termination in front of passeur's HTTP port.

## Development Setup

```bash
mix deps.get
mix ecto.create
mix ecto.migrate -r Passeur.Repo
mix passeur.hash_password  # generate admin password hash, update config/dev.exs
mix run --no-halt
```

## Project Structure

```
lib/
├── passeur_demo/
│   ├── application.ex      # Starts the Greeter GenServer
│   ├── greeter.ex           # GenServer that tracks greeting count
│   ├── mcp_server.ex        # MCP server definition with tools
│   └── tools/
│       └── greet.ex         # Greet tool implementation
```

## Customizing

This project is meant to be forked and modified. Here's how to make it your own:

### Removing the demo tools

Edit `lib/passeur_demo/mcp_server.ex` — remove the `component` lines you don't want:

```elixir
defmodule PasseurDemo.MCPServer do
  use Hermes.Server,
    name: "MyServer",
    version: "0.1.0",
    capabilities: [:tools]

  # Remove these:
  # component PasseurDemo.Tools.Greet
  # component PasseurFiles.Tools.ListFiles
  # ...

  # Add your own:
  component MyApp.Tools.MyTool

  @impl true
  def init(_client_info, frame), do: {:ok, frame}
end
```

If you remove all passeur_files tools, also remove `{:passeur_files, ...}` from `mix.exs` and the `config :passeur_files` lines from config.

### Adding your own tools

Create a new module under `lib/passeur_demo/tools/`:

```elixir
defmodule PasseurDemo.Tools.MyTool do
  @moduledoc "Description shown to the LLM"

  use Hermes.Server.Component, type: :tool

  schema do
    field :input, {:required, :string}, description: "What this parameter does"
  end

  @impl true
  def execute(%{input: input}, frame) do
    result = do_something(input)

    {:reply,
     Hermes.Server.Response.tool()
     |> Hermes.Server.Response.text(result),
     frame}
  end
end
```

Then add `component PasseurDemo.Tools.MyTool` to your MCP server module.

### Using third-party tool packages

Add them as dependencies in `mix.exs` and register their components:

```elixir
# mix.exs
{:some_mcp_tools, "~> 0.1"}

# mcp_server.ex
component SomeMCPTools.Tools.CoolTool
```

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `DATABASE_URL` | Yes | Postgres connection URL |
| `SECRET_KEY_BASE` | Yes | 64+ character random string |
| `ADMIN_USERNAME` | Yes | Admin login username |
| `ADMIN_PASSWORD_HASH` | Yes | Argon2 hash |
| `SERVER_URL` | Yes | Public HTTPS URL |
| `VAULT_PATH` | Yes | Directory for file tools |
| `PORT` | No | HTTP port (default: 4000) |
| `POOL_SIZE` | No | DB pool size (default: 10) |

## License

MIT

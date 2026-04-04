defmodule PasseurDemo.Tools.Greet do
  @moduledoc "Sends a greeting via the Greeter actor"

  use Hermes.Server.Component, type: :tool

  schema do
    field :name, {:required, :string}, description: "Name of the person to greet"
  end

  @impl true
  def execute(%{name: name}, frame) do
    message = PasseurDemo.Greeter.greet(name)

    {:reply,
     Hermes.Server.Response.tool()
     |> Hermes.Server.Response.text(message),
     frame}
  end
end

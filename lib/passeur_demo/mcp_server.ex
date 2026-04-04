defmodule PasseurDemo.MCPServer do
  use Hermes.Server,
    name: "PasseurDemo",
    version: "0.1.0",
    capabilities: [:tools]

  component PasseurDemo.Tools.Greet
  component PasseurFiles.Tools.ListFiles
  component PasseurFiles.Tools.ReadFile
  component PasseurFiles.Tools.WriteFile
  component PasseurFiles.Tools.EditFile
  component PasseurFiles.Tools.DeleteFile

  @impl true
  def init(_client_info, frame) do
    {:ok, frame}
  end
end

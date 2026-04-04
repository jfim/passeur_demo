defmodule PasseurDemo.Greeter do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, Keyword.put_new(opts, :name, __MODULE__))
  end

  def greet(name, server \\ __MODULE__) do
    GenServer.call(server, {:greet, name})
  end

  @impl true
  def init(:ok) do
    {:ok, %{greet_count: 0}}
  end

  @impl true
  def handle_call({:greet, name}, _from, state) do
    count = state.greet_count + 1
    {:reply, "Hello #{name}! (greeting ##{count})", %{state | greet_count: count}}
  end
end

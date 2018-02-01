defmodule TodoGenServer do
  use GenServer

  def start do
    GenServer.start(TodoGenServer, nil)
  end
  def add_entry(pid, entry) do
    GenServer.cast(pid, {:add_entry, entry})
  end
  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  def init(_) do
    {:ok, %Todos{}}
  end

  def handle_cast({:add_entry, entry}, todos) do
    {:noreply, Todos.add_entry(todos, entry)}
  end

  def handle_call({:entries, date}, _, todos) do
    {:reply, Todos.entries(todos, date), todos}
  end

end
defmodule Todo.Server do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end
  def add_entry(pid, entry) do
    GenServer.cast(pid, {:add_entry, entry})
  end
  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  defp via_tuple(name) do
    {:via, :gproc, {:n, :l, {:todo_server, name}}}
  end

  def whereis(name) do
    :gproc.whereis_name({:n, :l, {:todo_server, name}})
  end

  def init(name) do
    IO.puts("Starting to-do server for #{name}")
    data = Todo.Database.get(name)
    {:ok, {name, data || Todo.List.new()}}
  end

  def handle_cast({:add_entry, entry}, { name, todo_list}) do
    new_state = Todo.List.add_entry(todo_list, entry)
    Todo.Database.store(name, new_state)
    {:noreply, {name, new_state}}
  end

  def handle_call({:entries, date}, _, { _, todo_list} = state) do
    {:reply, Todo.List.entries(todo_list, date), state}
  end

end
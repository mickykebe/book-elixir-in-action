defmodule Todo.Server do
  use GenServer

  def start(name) do
    GenServer.start(Todo.Server, name)
  end
  def add_entry(pid, entry) do
    GenServer.cast(pid, {:add_entry, entry})
  end
  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  def init(name) do
    {:ok, {name, Todo.Database.get(name) || Todo.List.new()}}
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
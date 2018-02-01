defmodule TodoServer do

  def start do
    ServerProcess.start(TodoServer)
  end

  def add_entry(pid, entry) do
    ServerProcess.cast(pid, {:add_entry, entry})
  end

  def entries(pid, date) do
    ServerProcess.call(pid, {:entries, date})
  end

  def init do
    %Todos{}
  end

  def handle_cast({:add_entry, entry}, todos) do
    Todos.add_entry(todos, entry)
  end

  def handle_call({:entries, date}, todos) do
    {Todos.entries(todos, date), todos}
  end
  
end
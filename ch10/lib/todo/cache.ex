defmodule Todo.Cache do
  use GenServer

  def init(_) do
    IO.puts "Starting to-do cache."
    {:ok, nil}
  end
  def start_link(_ \\ nil) do
    GenServer.start_link(__MODULE__, nil, name: :todo_cache)
  end

  def server_process(todo_list_name) do
    case Todo.Server.whereis(todo_list_name) do
      :undefined ->
        GenServer.call(:todo_cache, {:server_process, todo_list_name})
      pid -> pid
    end
  end

  def handle_call({:server_process, todo_list_name}, _, state) do
    todo_server_pid = case Todo.Server.whereis(todo_list_name) do
      :undefined ->
        {:ok, pid} = Todo.ServerSupervisor.start_child(todo_list_name)
        pid
      pid -> pid
    end
    {:reply, todo_server_pid, state}
  end
end
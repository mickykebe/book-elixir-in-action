defmodule TodoServer do
  def start do
    spawn(fn -> 
      todos = Todos.new()
      loop(todos)
    end)
  end

  def add_entry(todo_server, entry) do
    send(todo_server, {:add_entry, entry})
  end
  def entries(todo_server, date) do
    send(todo_server, {:entries, self(), date})
    receive do
      {:entries, todos} -> todos
      after 5000 -> {:error, :timeout}
    end
  end

  def loop(cur_todos) do
    new_todos = receive do
      message -> process_message(cur_todos, message)
    end
    loop(new_todos)
  end

  def process_message(todos, {:add_entry, entry}) do
    Todos.add_entry(todos, entry)
  end

  def process_message(todos, {:entries, caller, date}) do
    send(caller, {:entries, Todos.entries(todos, date)})
    todos
  end
  def process_message(todos, invalid_request) do
    IO.puts("invalid request #{inspect invalid_request}")
    todos
  end
end
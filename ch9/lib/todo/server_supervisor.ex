defmodule Todo.ServerSupervisor do
  use DynamicSupervisor

  def start_link(_ \\ nil) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: :todo_server_supervisor)
  end

  def start_child(todo_list_name) do
    DynamicSupervisor.start_child(:todo_server_supervisor, %{
      id: Todo.Server,
      start: {Todo.Server, :start_link, [todo_list_name]}
    })
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
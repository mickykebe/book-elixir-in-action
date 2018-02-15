defmodule Todo.Supervisor do
  use Supervisor
  
  def start_link(_ \\ nil) do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_) do
    children = [
      %{
        id: Todo.Database,
        start: {Todo.Database, :start_link, ["./persist/"]},
        type: :supervisor
      },
      %{
        id: Todo.ServerSupervisor,
        start: {Todo.ServerSupervisor, :start_link, []},
        type: :supervisor
      },
      {Todo.Cache, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
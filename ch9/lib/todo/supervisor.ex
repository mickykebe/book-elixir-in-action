defmodule Todo.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_) do
    children = [
      {Todo.ProcessRegistry, []},
      Supervisor.child_spec({Todo.SystemSupervisor, []}, type: :supervisor)
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
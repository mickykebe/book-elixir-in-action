defmodule Todo.Database do
  use GenServer

  def start_link(db_folder) do
    # IO.puts "Starting database server."
    GenServer.start_link(__MODULE__, db_folder, name: :database_server)
  end

  def store(key, data) do
    GenServer.cast(:database_server, {:store, key, data})
  end

  def get(key) do
    GenServer.call(:database_server, {:get, key})
  end

  def init(db_folder) do
    File.mkdir_p(db_folder)
    worker_list = Enum.reduce(0..2, Map.new, fn(key, acc) ->
      {:ok, worker_pid} = Todo.DatabaseWorker.start_link(db_folder)
      Map.put(acc, key, worker_pid)
     end)
    {:ok, worker_list}
  end

  def handle_cast({:store, key, data}, worker_list) do
    worker_pid = get_worker(key, worker_list)
    Todo.DatabaseWorker.store(worker_pid, key, data)
    
    {:noreply, worker_list}
  end

  def handle_call({:get, key}, from, worker_list) do
    worker_pid = get_worker(key, worker_list)

    # spawn(fn ->
    #   data = Todo.DatabaseWorker.get(worker_pid, key)
    #   GenServer.reply(caller, data)
    # end)
    # {:noreply, worker_list}
    
    
    # data = Todo.DatabaseWorker.get(worker_pid, key)
    # {:reply, data, worker_list}

    Todo.DatabaseWorker.get(worker_pid, key, from)
    {:noreply, worker_list}
    
  end

  defp get_worker(key, worker_list) do
    worker_map_key = :erlang.phash2(key, 3)
    Map.get(worker_list, worker_map_key)
  end
end
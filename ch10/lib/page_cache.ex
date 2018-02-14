defmodule PageCache do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: :page_cache)
  end

  def init(:ok) do
    {:ok, Map.new}
  end

  def cached(key, func) do
    GenServer.call(:page_cache, {:cached, key, func})
  end

  def handle_call({:cached, key, func}, _from, cache) do
    case Map.fetch(cache, key) do
      {:ok, value} -> {:reply, value, cache}
      :error ->
        value = func.()
        {:reply, value, Map.put(cache, key, value)}
    end
  end
end

defmodule EtsPageCache do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: :ets_page_cache)
  end

  def init(_) do
    :ets.new(:ets_page_cache, [:set, :named_table, :protected])
    {:ok, nil}
  end

  def cached(key, func) do
    read_cached(key) ||
     GenServer.call(:ets_page_cache, {:cached, key, func})
  end

  def read_cached(key) do
    case :ets.lookup(:ets_page_cache, key) do
      [{^key, cached}] -> cached
      _ -> nil
    end
  end

  def handle_call({:cached, key, func}, _from, state) do
    {
      :reply, 
      read_cached(key) || cache_response(key, func), 
      state
    }
  end

  def cache_response(key, fun) do
    value = fun.()
    :ets.insert(:ets_page_cache, {key, value})
    value
  end
end
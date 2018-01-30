defmodule MultiDict do
  
  def new, do: %{}
  def add(dict, key, val) do
    Map.update(dict, key, [val], &[val | &1])
  end
  def get(dict, key) do
    Map.get(dict, key, [])
  end
end
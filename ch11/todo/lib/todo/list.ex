defmodule Todo.List do
  @moduledoc """
  Documentation for Todos.
  """
  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %Todo.List{},
      fn(entry, to_list_acc) ->
        add_entry(to_list_acc, entry)
      end
    )
  end
  def add_entry(%Todo.List{auto_id: auto_id, entries: entries}, entry) do
    entry = Map.put(entry, :id, auto_id)
    %Todo.List{ auto_id: auto_id+1, entries: Map.put(entries, auto_id, entry)}
  end
  def entries(%Todo.List{entries: entries}, date) do
    Map.values(entries)
      |> Enum.filter(fn entry -> entry.date === date end)
  end
  def update_entry(%Todo.List{entries: entries} = todos, id, fn_update) do
    case Map.has_key?(entries, id) do
      true -> %Todo.List{todos | entries: Map.update!(entries, id, fn_update)}
      false -> todos
    end
  end
  def delete_entry(%Todo.List{entries: entries} = todos, id) do
    %Todo.List{todos | entries: Map.delete(entries, id)}
  end
end

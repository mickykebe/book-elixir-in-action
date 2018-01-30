defmodule Todos.CsvImporter do
  def import(filename) do
    File.stream!(filename)
      |> Stream.map(&to_entry/1)
      |> Todos.new
  end

  def to_entry(line) do
    [date_raw, title] = String.trim(line)
      |> String.split(",")
    [y, m, d] = date_raw
     |> String.split("/")
     |> Enum.map(&String.to_integer/1)
    %{date: {y, m, d}, title: title}
  end
end
defmodule Ch10Test do
  use ExUnit.Case
  doctest Ch10

  test "greets the world" do
    assert Ch10.hello() == :world
  end
end

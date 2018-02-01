defmodule Ch7Test do
  use ExUnit.Case
  doctest Ch7

  test "greets the world" do
    assert Ch7.hello() == :world
  end
end
